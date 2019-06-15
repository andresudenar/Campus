import 'package:campus/pages/queries.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
List path = [];

class Generic extends StatelessWidget{
  String type = "";
  ValueNotifier<Client> client;
  List paths = [];

  Generic(this.type , this.paths,this.client){
    path = paths;
    path.add(type);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("Este es el path" + path.toString());
    print("Este es el tipo" + type);
    print(getQueryElementsFolder(path));
    return Scaffold(
      appBar: AppBar(
        title: Text("Generic"),
      ),
      body: Center(
          child: ShoppingBasket(),
      )
    );
  }
}


class ShoppingBasket extends StatefulWidget {
  @override
  ShoppingBasketState createState() => new ShoppingBasketState();
}

class MyItem {
  MyItem({ this.isExpanded: false, this.header, this.body });

  bool isExpanded;
  final String header;
  final String body;
}

class ShoppingBasketState extends State<ShoppingBasket> {
  List<MyItem> _items = <MyItem>[
    new MyItem(header: 'header', body: 'body'),
    MyItem(header: 'header', body: 'body'),
    MyItem(header: 'header', body: 'body')
  ];
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: [
        new ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _items[index].isExpanded = !_items[index].isExpanded;
            });
          },
          children: _items.map((MyItem item) {
            return new ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return new Text(
                  item.header,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: 'Arvo',
                    fontWeight: FontWeight.bold
                  ),
                );
              },
              isExpanded: item.isExpanded,
              body: new Container(
                child: new Text(item.body),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}