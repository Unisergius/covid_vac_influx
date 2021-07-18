import 'dart:convert';

Counties countiesFromJson(String str, String? query) =>
    Counties.fromJson(json.decode(str), query);

String countiesToJson(Counties data) => json.encode(data.toJson());

class Counties {
  Counties({required this.countyNames});

  List<String> countyNames;

  factory Counties.fromJson(Map<String, dynamic> json, String? query) =>
      Counties(
        countyNames: List<String>.from(json["county"]
            .where((x) => (query != null
                ? x.toString().toLowerCase().contains(query.toLowerCase())
                : true))
            .toList()),
      );

  Map<String, dynamic> toJson() => {
        "county": List<dynamic>.from(countyNames.map((x) => x)),
      };
}
