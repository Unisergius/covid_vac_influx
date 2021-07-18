import 'package:flutter/material.dart';
import 'package:covid_vac_influx/influx.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CenterInfo extends StatelessWidget {
  final Datum center;
  CenterInfo(this.center);

  @override
  Widget build(BuildContext context) {
    final title = 'Center Information';

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
          child: Center(
            child: Column(
              children: [
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
                                  center: LatLng(
                                      double.parse(this.center.latitude),
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
                                            double.parse(
                                                this.center.longitude)),
                                        builder: (ctx) => Container(
                                          child: CircleAvatar(
                                            backgroundColor:
                                                this.center.getColor(),
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
                  child: Text(center.address),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
