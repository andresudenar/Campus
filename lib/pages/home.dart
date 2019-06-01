import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:async';
import 'menuLista.dart';

String url = '';
List path = [];
List pathTitulos = [];

ValueNotifier<Client> client = ValueNotifier(
  Client(
    endPoint: 'http://johnmariogb.pythonanywhere.com' + '/graphql',
    cache: InMemoryCache(),
  ),
);

class Home extends StatefulWidget{
  @override
  _HomeState createState() => new _HomeState(titulo, tipo);
  final String tipo;
  final String titulo;
  Home(this.titulo,this.tipo);
}

class _HomeState extends State<Home> {

  String tipo;
  String titulo;
  Color mainColor = const Color(0xff3C3261);

  _HomeState(this.titulo,this.tipo){
    this.tipo = tipo;
    this.titulo = titulo;

    if (tipo!="Regreso") {//si contiene ese tipo no lo agregue
      path.add(tipo);//adiciona el tipo a path
      pathTitulos.add(titulo);
    }
    print(".........................Este es el pat hasta el momento "+path.toString());
  }

  Future<bool> _onWillPop() {
    if(path.length>1) {
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
                              getQueryElementsFolder(),
                              pollInterval: 12000,
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
                                                  'images/loading4.gif',
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
                                                    infoElements[folderElements[i]['name']]['title'].toString(),
                                                    infoElements[folderElements[i]['name']]['description'].toString(),
                                                    'http://johnmariogb.pythonanywhere.commenus[i]' + infoElements[folderElements[i]['name']]['icon'].toString()),
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
                                                color: Colors.white,
                                              );
                                            },
                                          ));
                                    }));
                                //menus[0][title]
                              })),
                      Text(url),
                    ],
                  ),
                ))));
  }
}

class MovieTitle extends StatelessWidget {
  final Color mainColor;

  MovieTitle(this.mainColor);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: new Text(
        'Servicos',
        style: new TextStyle(
            fontSize: 40.0,
            color: mainColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arvo'),
        textAlign: TextAlign.left,
      ),
    );
  }
}