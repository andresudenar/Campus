import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () => Navigator.pop(context, "/"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.redAccent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /*CircleAvatar(
                        backgroundColor: Colors.black87,
                        radius: 50.0,
                        child: Icon(
                          Icons.mood,
                          color: Colors.white,
                          size: 50.0,
                        ),
                      ),*/
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Center(
                          child:
                          Text(
                            'Uni-Foss',
                            style: TextStyle(
                                fontFamily: "Sacramento",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 45.0),
                            textAlign: TextAlign.center,

                          ))
                    ],
                  ),
                ),
              ),
              /*
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      'loading',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black54),
                    )
                  ],
                ),
              )*/
            ],
          )
        ],
      ),
    );
  }
}