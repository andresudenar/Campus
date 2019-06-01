import 'package:flutter/material.dart';

class MenuLista extends StatelessWidget{

  final servicio;
  final descripcion;
  final icon;

  Color mainColor = const Color(0xff3C3261);
  //var image_url = 'https://image.tmdb.org/t/p/w500/';
  MenuLista(this.servicio,this.descripcion,this.icon);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(0.0),
              child: new Container(
                margin: const EdgeInsets.all(16.0),
                child: new Container(
                  width: 70.0,
                  height: 70.0,
                ),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(50.0),
                  color: Colors.white,
                  image: new DecorationImage(
                      image: new NetworkImage(
                          icon
                      ),
                      fit: BoxFit.cover),
                  boxShadow: [
                    new BoxShadow(
                        color: mainColor,
                        blurRadius: 15.0,
                        offset: new Offset(2.0, 5.0))
                  ],
                ),
              ),
            ),
            new Expanded(

                child: new Container(
                  margin: const      EdgeInsets.fromLTRB(16.0,0.0,16.0,0.0),
                  child: new Column(children: [
                    new Text(servicio.toString(),
                      style: new TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Arvo',
                          fontWeight: FontWeight.bold,
                          color: mainColor),
                    ),
                    new Padding(padding: const EdgeInsets.all(2.0)),
                    new Text(descripcion,
                      maxLines: 3,
                      style: new TextStyle(
                          color: const Color(0xff8785A4),
                          fontFamily: 'Arvo'
                      ),)
                  ],
                    crossAxisAlignment: CrossAxisAlignment.start,),
                )
            ),
          ],
        ),
        new Container(
          width: 300.0,
          height: 0.5,
          color: const Color(0xD2D2E1ff),
          margin: const EdgeInsets.all(16.0),
        )
      ],
    );
  }
}