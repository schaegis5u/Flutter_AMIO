import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'actor.dart';
import 'movie.dart';
import 'menu.dart';

class Movie {
  final String id;
  final String nom;

  Movie({required this.id, required this.nom});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      nom: json['nom'],
    );
  }
}

class MoviePage extends StatefulWidget {
  String idActor;
  MoviePage({Key? key, required this.idActor}) : super(key: key);

  @override
  MovieState createState() => MovieState();
}

class MovieState extends State<MoviePage> {
  List movies = [];
  String get idActor => widget.idActor;

  Future<String> getData() async {
    var response = await http
        .get(Uri.parse('http://100.64.98.52:3200/api/actor/${idActor}'));

    setState(() {
      dynamic data = json.decode(response.body);
      movies = data["data"]["roles"];
    });

    return "Success";
  }

  @override
  // ignore: must_call_super
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Films"),
        ),
        drawer: Menu(context),
        body: ListView.builder(
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                tileColor: Colors.indigo[200],
                title: Text(movies[index]["title"]),
                /*leading: CircleAvatar(
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://res.cloudinary.com/lp-amio/image/upload/v1602625308/movie/${movies[index]["id"]}",
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  )*/
              );
            }));
  }
}
