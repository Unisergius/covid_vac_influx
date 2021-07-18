//import 'dart:html';

import 'package:covid_vac_influx/influx.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
//import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

const GDIRPATH = "/dir/?api=1";
const GMAPSURL = "https://www.google.com/maps";
const GSEARCHPATH = "/search/?api=1";

var logger = Logger(
  printer: PrettyPrinter(),
);

class CenterInfo extends StatefulWidget {
  CenterInfo({Key? key, required this.center}) : super(key: key);

  final Datum center;

  @override
  _CenterInfoState createState() => _CenterInfoState();
}

class _CenterInfoState extends State<CenterInfo> {
  late Datum center;

  @override
  void initState() {
    super.initState();
    center = widget.center;
  }

  _browseGoogle() {
    Geolocator.isLocationServiceEnabled()
        .then((gpsEnabled) => {
              GeolocatorPlatform.instance
                  .getCurrentPosition()
                  .then((position) => {
                        launch(
                            "$GMAPSURL$GDIRPATH&origin=${position.latitude}%2C${position.longitude}&destination=${this.center.latitude}%2C${this.center.longitude}")
                      })
            })
        .catchError((e) {
      logger.wtf(e.error);
      launch(
          "$GMAPSURL$GSEARCHPATH&query=${this.center.latitude}%2C${this.center.longitude}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = this.center.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        // widget safe from OS interfaces
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(10.0), //
          child: Column(children: [
            SizedBox(
              height: 338.0,
              width: 800.0,
              child: Card(
                  clipBehavior: Clip.none,
                  child: Column(
                    children: [
                      Container(
                          width: double.infinity,
                          height: 330.0,
                          child: FlutterMap(
                            options: MapOptions(
                              center: LatLng(double.parse(this.center.latitude),
                                  double.parse(this.center.longitude)),
                              zoom: 16.0,
                            ),
                            layers: [
                              TileLayerOptions(
                                  urlTemplate:
                                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  subdomains: ['a', 'b', 'c']),
                              MarkerLayerOptions(
                                markers: [
                                  Marker(
                                    width: 20.0,
                                    height: 20.0,
                                    point: LatLng(
                                        double.parse(this.center.latitude),
                                        double.parse(this.center.longitude)),
                                    builder: (ctx) => Container(
                                      child: CircleAvatar(
                                        backgroundColor: this.center.getColor(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                  )),
            ),
            // Divider(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(backgroundColor: this.center.getColor()),
                      Text(
                          "Estimated waiting time: ${this.center.getEstimationQueueTime()}")
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Address:"),
                        Container(
                            width: 300,
                            child: Text(
                              this.center.address,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ))
                      ]),
                  SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("GPS Latitude:"),
                        Text(this.center.latitude)
                      ]),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("GPS Longitude:"),
                      Text(this.center.longitude)
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                      "Open from ${this.center.scheduleStart} to ${this.center.scheduleEnd}"),
                  //Html(data: this.center.nameLink),
                  //Html(data: this.center.waitTime),
                  SizedBox(height: 10),
                  Center(
                      child: TextButton(
                          child: Text("Browse for directions on Google"),
                          onPressed: () => {_browseGoogle()}))
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
