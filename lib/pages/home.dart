import 'package:campus/pages/queries.dart';
import 'package:campus/pages/url_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:async';
import 'package:campus/pages/Constants.dart';
import 'generic.dart';
import 'menuLista.dart';
import 'myPreferences.dart';

List path = [];
List pathTitulos = [];

class Home extends StatefulWidget{
  final String tipo;
  final String titulo;
  Home(this.titulo,this.tipo){
    if(tipo == "Home"){
      path.clear();
      pathTitulos.clear();
    }
    if (tipo!="Regreso") {//si contiene ese tipo no lo agregue
      path.add(tipo);//adiciona el tipo a path
      pathTitulos.add(titulo);
    }
    print(".........................Este es el pat hasta el momento "+path.toString());
  }
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  Color mainColor = const Color(0xff3C3261);
  MyPreferences _myPreferences = MyPreferences();
  void initState() {
    // TODO: implement initState
    super.initState();
    _myPreferences.init().then((value){
      setState((){
        _myPreferences = value;
      });
    });
  }

  Future<bool> _onWillPop() {
    if(pathTitulos.length>1 && path.length>1) {
      path.removeLast();
      pathTitulos.removeLast();
      Navigator.pop(context, '/');
    }
    else{
      return showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text('¿Desea salir?'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: new Text('Si'),
            ),
          ],
        ),
      )??
          false;
    }
  }

  ValueNotifier<Client> client = ValueNotifier(
    Client(
      endPoint: 'http://johnmariogb.pythonanywhere.com' + '/graphql',
      cache: InMemoryCache(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text(
                pathTitulos.last,
                style: TextStyle(
                  fontFamily: "Sacramento",
                  fontSize: 27,
                  //fontWeight: FontWeight.bold
                ),
              ),
              actions: <Widget>[
                PopupMenuButton<String>(
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context){
                    return Constants.choices.map((String choice){
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                )
              ],
            ),

            body: new Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //new MovieTitle(mainColor),

                      GraphqlProvider(
                          client: client,
                          child: Query(
                              getQueryElementsFolder(path),
                              pollInterval: 120,
                              builder: ({bool loading, Map data, Exception error}) {
                                if (error != null) {
                                  return Text("Error en la consulta");
                                }
                                if (loading) {
                                  return Expanded(
                                    child: Center(
                                        child: CircularProgressIndicator()
                                    )
                                  );
                                }

                                var folderElements = data['__type']['fields'];
                                print("ELEMENTS FOLDER "+folderElements.toString());
                                if(folderElements == null){
                                  return Expanded(
                                      child: Center(
                                          child: CircularProgressIndicator()
                                      )
                                  );
                                }
                                return (Query(getQueryInfoElementsFolder(path, folderElements),
                                    pollInterval: 10,
                                    builder: (
                                        {bool loading, Map data, Exception error}) {
                                      if (error != null) {
                                        return Text("Error en la consulta");
                                      }
                                      if (loading) {
                                        return Expanded(
                                            child: Center(
                                                child: CircularProgressIndicator()
                                            )
                                        );
                                      }

                                      var infoElements = data;
                                      print("ELEMENTS INFO "+infoElements.toString());
                                      for(int i=0;i<path.length;i++){
                                        infoElements = infoElements[path[i]]['elements'];
                                      }
                                      print("ELEMENTS INFO 2 "+infoElements.toString());
                                      if(infoElements == null){
                                        return Expanded(
                                            child: Center(
                                                child: CircularProgressIndicator()
                                            )
                                        );
                                      }
                                      return drawMenu(infoElements, folderElements, client);
                                    }));
                                //menus[0][title]
                              })),
                      Text(url(_myPreferences))
                    ],
                  ),
                ))));
  }
  void choiceAction(String choice){
    if(choice == Constants.url){
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) {
            return URLScreen();
          }
          )
      );
      print("Configurar URL");
    }else if(choice == Constants.exit){
      print("Salir");
    }
  }
}

Expanded drawMenu(var infoElements, folderElements, client){
  return Expanded(
  child: new ListView.builder(
    itemCount: folderElements == null ? 0 : folderElements.length,
    itemBuilder: (context, i) {
      return new FlatButton(
          child: MenuLista(
              service: infoElements[folderElements[i]['name']]['title'].toString(),
              description: infoElements[folderElements[i]['name']]['description'].toString(),
              icon: 'http://johnmariogb.pythonanywhere.com/menus[i]' + infoElements[folderElements[i]['name']]['icon'].toString()
          ),
          padding: const EdgeInsets.all(0.0),
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) {
                  if (infoElements[folderElements[i]['name']]['theme'] == null) {
                    print("Tipo enviado desde aqui "+folderElements[i]['type']['name'].toString());
                    return Home(infoElements[folderElements[i]['name']]['title'].toString(),folderElements[i]['type']['name'].toString());
                  }else if(infoElements[folderElements[i]['name']]['theme'] == "generic"){
                    return Generic(folderElements[i]['type']['name'],path,client);
                  }else{
                    return Text("Tema no implementado");
                  }
                  //return Menu();
                }));
          },
          color: Colors.transparent
      );
    },
  ));
}

String url(MyPreferences _myPreferences){
  String url= _myPreferences.url;
  url="http://"+url+"/graphql";
  url = url.replaceAll(' ', '');
  return url;
}