import 'dart:convert';

import 'package:flutter/material.dart';

Influx influxFromJson(String str) => Influx.fromJson(json.decode(str));

String influxToJson(Influx data) => json.encode(data.toJson());

class Influx {
  Influx(
      {required this.draw,
      required this.recordsTotal,
      required this.recordsFiltered,
      required this.data});

  final int draw;
  final int recordsTotal;
  final int recordsFiltered;
  final List<Datum> data;

  factory Influx.fromJson(Map<String, dynamic> json) => Influx(
        draw: json["draw"],
        recordsTotal: json["recordsTotal"],
        recordsFiltered: json["recordsFiltered"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "draw": draw,
        "recordsTotal": recordsTotal,
        "recordsFiltered": recordsFiltered,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.cvcId,
    required this.siteType,
    required this.lightColor,
    required this.active,
    required this.name,
    required this.shortName,
    required this.location,
    required this.ars,
    required this.aces,
    required this.district,
    required this.county,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.scheduleStart,
    required this.scheduleEnd,
    required this.lunchScheduleStart,
    required this.lunchScheduleEnd,
    required this.updatedAt,
    required this.clientMax,
    required this.yellowWarning,
    required this.clientN,
    required this.peopleInRecobro,
    required this.lastLightLogCreatedAt,
    required this.lastLightLogUsername,
    required this.nameLink,
    required this.waitTime,
  });

  final int id;
  final int cvcId;
  final String siteType;
  final String? lightColor;
  final int active;
  final String name;
  final String shortName;
  final String location;
  final String ars;
  final String aces;
  final String district;
  final String county;
  final String address;
  final String latitude;
  final String longitude;
  final String scheduleStart;
  final String scheduleEnd;
  final dynamic lunchScheduleStart;
  final dynamic lunchScheduleEnd;
  final String updatedAt;
  final int clientMax;
  final int yellowWarning;
  final int clientN;
  final int peopleInRecobro;
  final DateTime lastLightLogCreatedAt;
  final String lastLightLogUsername;
  final String nameLink;
  final String waitTime;

  getColor() {
    var bgColor = Colors.grey;
    switch (this.lightColor) {
      case "green":
        bgColor = Colors.green;
        break;
      case "yellow":
        bgColor = Colors.yellow;
        break;
      case "red":
        bgColor = Colors.red;
        break;
    }
    return bgColor;
  }

  getState() {
    var state = "Closed";
    switch (this.lightColor) {
      case "green":
        state = "short queue";
        break;
      case "yellow":
        state = "long queue";
        break;
      case "red":
        state = "very long queue";
        break;
    }
    return state;
  }

  getEstimationQueueTime() {
    var state = "";
    switch (this.lightColor) {
      case "green":
        state = "less than thirty minutes";
        break;
      case "yellow":
        state = "less than one hour";
        break;
      case "red":
        state = "more than one hour";
        break;
    }
    return state;
  }

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        cvcId: json["cvc_id"],
        siteType: json["site_type"],
        lightColor: json["lightColor"],
        active: json["active"],
        name: json["name"],
        shortName: json["short_name"],
        location: json["location"],
        ars: json["ars"],
        aces: json["aces"],
        district: json["district"],
        county: json["county"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        scheduleStart: json["schedule_start"],
        scheduleEnd: json["schedule_end"],
        lunchScheduleStart: json["lunch_schedule_start"],
        lunchScheduleEnd: json["lunch_schedule_end"],
        updatedAt: json["updated_at"],
        clientMax: json["client_max"],
        yellowWarning: json["yellow_warning"],
        clientN: json["client_n"],
        peopleInRecobro: json["people_in_recobro"],
        lastLightLogCreatedAt:
            DateTime.parse(json["last_light_log_created_at"]),
        lastLightLogUsername: json["last_light_log_username"],
        nameLink: json["name_link"],
        waitTime: json["waitTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cvc_id": cvcId,
        "site_type": siteType,
        "lightColor": lightColor,
        "active": active,
        "name": name,
        "short_name": shortName,
        "location": location,
        "ars": ars,
        "aces": aces,
        "district": district,
        "county": county,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "schedule_start": scheduleStart,
        "schedule_end": scheduleEnd,
        "lunch_schedule_start": lunchScheduleStart,
        "lunch_schedule_end": lunchScheduleEnd,
        "updated_at": updatedAt,
        "client_max": clientMax,
        "yellow_warning": yellowWarning,
        "client_n": clientN,
        "people_in_recobro": peopleInRecobro,
        "last_light_log_created_at": lastLightLogCreatedAt.toIso8601String(),
        "last_light_log_username": lastLightLogUsername,
        "name_link": nameLink,
        "waitTime": waitTime,
      };
}
