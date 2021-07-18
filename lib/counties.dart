import 'dart:convert';

Counties countiesFromJson(String str) => Counties.fromJson(json.decode(str));

String countiesToJson(Counties data) => json.encode(data.toJson());

class Counties {
  Counties({required this.countyNames});

  List<String> countyNames;

  factory Counties.fromJson(Map<String, dynamic> json) => Counties(
        countyNames: List<String>.from(json["county"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "county": List<dynamic>.from(countyNames.map((x) => x)),
      };
}
