import 'package:cinema/movie.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'menu.dart';

class Actor {
  final String id;
  final String nom;
  final String nomMaj;

  Actor({required this.id, required this.nom, required this.nomMaj});

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'],
      nom: json['name'],
      nomMaj: json['name'].toUpperCase(),
    );
  }
}

class ActorPage extends StatefulWidget {
  ActorPage({Key? key}) : super(key: key);

  @override
  ActorState createState() => ActorState();
}

class ActorState extends State<ActorPage> {
  List<Actor> actors = [];
  List<Actor> filtre = [];
  late TextEditingController _ctrlRecherche; // _ private à la chasse

  Future<void> getData() async {
    var response =
        await http.get(Uri.parse('http://100.64.98.52:3200/api/actor'));
    if (response.statusCode == 200) {
      setState(() {
        List j = json.decode(response.body);
        actors = j.map((obj) => Actor.fromJson(obj)).toList();
        filtre = new List<Actor>.from(actors);
      });
    }
  }

  @override
  void initState() {
    _ctrlRecherche = TextEditingController();
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _ctrlRecherche.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            SizedBox(
                width: 150,
                child: TextFormField(
                  controller: _ctrlRecherche,
                  onChanged: (text) {
                    //if (text.length < 3) return;
                    setState(() {
                      actors = filtre
                          .where((a) => a.nomMaj.contains(text.toUpperCase()))
                          .toList();
                    });
                  },
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    actors = filtre
                        .where((a) => a.nomMaj
                            .contains(_ctrlRecherche.text.toUpperCase()))
                        .toList();
                  });
                },
                icon: const Icon(Icons.search))
          ],
          title: Text("Acteurs"),
        ),
        drawer: Menu(context),
        body: ListView.builder(
            itemCount: actors.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                tileColor: Colors.indigo[100],
                title: Text(actors[index].nom),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoviePage(
                          idActor: actors[index].id,
                        ),
                      ));
                },
                /*leading: CircleAvatar(
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            //"https://res.cloudinary.com/lp-amio/image/upload/v1602625308/actor/706ae11c-1c62-4e6b-a864-b1cfb69822a8",
                            "https://res.cloudinary.com/lp-amio/image/upload/v1602625308/actor/${actors[index]["id"]}",
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  )*/
              );
            }));
  }
}
