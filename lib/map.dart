import 'dart:ffi';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'actor.dart';
import 'movie.dart';
import 'menu.dart';

class Carte {
  String nom;
  double lat;
  double lng;
  late Marker mq;

  Carte(this.nom, this.lat, this.lng) {
    mq = Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(lat, lng),
      builder: (ctx) => Icon(Icons.location_pin, color: Colors.red, size: 40),
    );
  }

  factory Carte.fromJson(Map<String, dynamic> json) {
    return Carte(
        json['nom'], double.parse(json['lat']), double.parse(json['lng']));
  }
}

class CartePage extends StatefulWidget {
  @override
  CarteState createState() => CarteState();
}

class CarteState extends State<CartePage> {
  List<Carte> stations = [];
  List<Marker> marqueurs = [];

  Future<void> getData() async {
    var response = await http.get(Uri.parse(
        'https://workshop.neotechweb.net/ws/skimap/1.0.0/stations.php?massif=2'));
    if (response.statusCode == 200) {
      setState(() {
        List j = json.decode(response.body);
        stations = j
            .where((e) => e["lat"] != null)
            .map((obj) => Carte.fromJson(obj))
            .toList();
        marqueurs = stations.map((e) => e.mq).toList();
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Carte"),
        ),
        drawer: Menu(context),
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(48, 6.9),
            zoom: 10.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
              attributionBuilder: (_) {
                return Text("© OpenStreetMap contributors");
              },
            ),
            MarkerLayerOptions(
              markers: marqueurs,
            ),
          ],
        ));
  }
}
