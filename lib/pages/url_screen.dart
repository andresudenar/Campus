import 'package:flutter/material.dart';
import 'myPreferences.dart';

String direccion;

class URLScreen extends StatefulWidget{
  @override
  _URLScreenState createState() => new _URLScreenState();
}

class _URLScreenState extends State<URLScreen>{
  MyPreferences _myPreferences = MyPreferences();
  var _controler = new TextEditingController();
  Color mainColor = const Color(0xffc5cae9);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myPreferences.init().then((value){
      setState((){
        _myPreferences = value;
      });
    });
  }

  void SaveURL(){
    String url = _controler.text;

    _myPreferences.url = url;
    _myPreferences.commit();
    Navigator.pop(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Center(
          child:
          new SingleChildScrollView(
            child: new Container(
              margin: const EdgeInsets.all(20.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Icon(
                    Icons.cloud_circle,
                    color: Colors.black54,
                    size: 150.0,
                  ),
                  new Text(
                      "!Bienvenid@!",
                      style: new TextStyle(
                          fontSize: 40.0,
                          color: Colors.black54
                      )
                  ),
                  new Text(
                    "Para comenzar conectate a el servidor \n",
                    style: new TextStyle(
                        color: Colors.black
                    ),
                  ),
                  new TextField(
                    decoration: new InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      //hintText: "http://",
                      labelText: 'Ingresar la dirección del servidor',
                      prefixText: "http://",
                    ),
                    controller: _controler,
                  ),
                  new Text(""),
                  new RaisedButton(
                    child: const Text('Conectar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arvo'
                      ),
                    ),
                    elevation: 4.0,
                    splashColor: Colors.white24,
                    onPressed: () {
                      // Perform some action
                      SaveURL();
                    },
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}