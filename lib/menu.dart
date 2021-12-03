import 'package:cinema/map.dart';
import 'package:flutter/material.dart';
import 'barcode.dart';

Drawer Menu(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        ListTile(
          tileColor: Colors.indigo[300],
          title: Text('Acteurs'),
          leading: Icon(Icons.person),
        ),
        ListTile(
          tileColor: Colors.indigo[200],
          title: Text('Films'),
          leading: Icon(Icons.movie),
        ),
        ListTile(
          tileColor: Colors.indigo[400],
          title: Text('Acheter'),
          leading: Icon(Icons.money),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => (BarCodePage()),
                ));
          },
        ),
        ListTile(
          tileColor: Colors.indigo[500],
          title: Text('Map'),
          leading: Icon(Icons.map),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => (CartePage()),
                ));
          },
        ),
      ],
    ),
  );
}
