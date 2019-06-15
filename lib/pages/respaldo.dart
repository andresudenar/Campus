import 'package:campus/pages/url_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:async';
import 'package:campus/pages/Constants.dart';
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
  String url;

  void initState() {
    // TODO: implement initState
    super.initState();
    _myPreferences.init().then((value){
      setState((){
        _myPreferences = value;
        url= _myPreferences.url;
        url="http://"+url+"/graphql";
        url = url.replaceAll(' ', '');
      });
    });
  }

  Future<bool> _onWillPop() {
    if(pathTitulos.length>1 && path.length>1) {
      path.removeLast();
      pathTitulos.removeLast();
      Navigator.pop(context, new MaterialPageRoute(builder: (context) {
        return Home(pathTitulos.last, "Regreso");
      }));
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

  String getQueryElementsFolder() {
    String query = 'query{__type(name:"' +path[path.length-1]+ 'Elements"){fields{name type{name ofType{name}}}}}';
    print ("Aquí estamos creando la consulta de los tipos" + query);
    return query;
  }

  String getQueryInfoElementsFolder(List elements){//información de los folders
    String query = 'query{type}';
    String pathElement;

    for (int i = 0; i < path.length; i++) {
      pathElement = path[i] + '{elements{type}}';
      query = query.replaceAll('type', pathElement);
    }

    for(int i=0;i<elements.length;i++){
      pathElement = elements[i]['name'] + '{title icon state theme description} type';
      query = query.replaceAll('type', pathElement);
    }

    query = query.replaceAll('type', "");
    print ("Esta es la consulta generada"+query);
    return query;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: new Text(
                pathTitulos.last,
                style: TextStyle(
                  fontFamily: "Sacramento",
                  fontSize: 27,
                  //fontWeight: FontWeight.bold
                ),
              ),
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset('assets/forest.jpg', fit: BoxFit.cover),
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
            SliverFixedExtentList(
              itemExtent: MediaQuery.of(context).size.height,
              delegate: SliverChildListDelegate(
                [
                  Center(
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
                                    getQueryElementsFolder(),
                                    pollInterval: 120,
                                    builder: ({bool loading, Map data, Exception error}) {
                                      if (error != null) {
                                        return Text("Error en la consulta");
                                      }
                                      if (loading) {
                                        return Expanded(
                                            child: Center(
                                                child: Image.asset(
                                                  'images/loading.gif',
                                                  height: 70.0,
                                                  fit: BoxFit.cover,
                                                )));
                                      }

                                      var folderElements = data['__type']['fields'];
                                      print("ELEMENTS FOLDER "+folderElements.toString());
                                      return (Query(getQueryInfoElementsFolder(folderElements),
                                          pollInterval: 10,
                                          builder: (
                                              {bool loading, Map data, Exception error}) {
                                            if (error != null) {
                                              return Text("Error en la consulta");
                                            }
                                            if (loading) {
                                              return Expanded(
                                                  child: Center(
                                                      child: Image.asset(
                                                        'images/loading.gif',
                                                        height: 70.0,
                                                        fit: BoxFit.cover,
                                                      )));
                                            }

                                            var infoElements = data;
                                            print("ELEMENTS INFO "+infoElements.toString());
                                            for(int i=0;i<path.length;i++){
                                              infoElements = infoElements[path[i]]['elements'];
                                            }
                                            print("ELEMENTS INFO 2"+infoElements.toString());
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
                                                                }
                                                                //return Menu();
                                                              }));
                                                        },
                                                        color: Colors.transparent
                                                    );
                                                  },
                                                ));
                                          }));
                                      //menus[0][title]
                                    })),
                            //Text(url)
                          ],
                        ),
                      )
                  ),
                ],
              ),
            )
          ],
        )
    );
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