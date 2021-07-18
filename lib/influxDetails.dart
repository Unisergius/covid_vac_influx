import 'package:flutter/material.dart';
import 'package:covid_vac_influx/influx.dart';
import 'package:covid_vac_influx/centerInfo.dart';
import 'package:http/http.dart' as http;

const SNSURL = 'https://sns.afluencia.io/centros/search';
const SNSBASEURL = "sns.afluencia.io";
const SNSAPIPATH = "centros/search";
const CORSPROXY = "api.allorigins.win";
const CORSPROXYPATH = "/raw";

Future<String> _loadRemoteData(String countyString) async {
  Map<String, dynamic> queryParameters = {};
  if (!(countyString == "")) {
    queryParameters = {'url': "$SNSURL?county=$countyString"};
  }
  final response =
      await (http.get(Uri.https(CORSPROXY, CORSPROXYPATH, queryParameters)));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    print('Http Error: ${response.statusCode}!');
    throw Exception('Invalid data source.');
  }
}

class InfluxPage extends StatefulWidget {
  InfluxPage({Key? key, required this.title, required this.countyName})
      : super(key: key);

  final String title;
  final String countyName;

  @override
  _InfluxPageState createState() => _InfluxPageState();
}

class _InfluxPageState extends State<InfluxPage> {
  Future<Influx> fetchQuests(String countySelected) async {
    String jsonString = await _loadRemoteData(countySelected);
    return influxFromJson(jsonString);
  }

  late Future<Influx> influx;

  @override
  void initState() {
    super.initState();
    influx = fetchQuests(widget.countyName);
  }

  void _refreshAPI() async {
    setState(() {
      influx = fetchQuests(widget.countyName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Center List"),
      ),
      body: FutureBuilder<Influx>(
          future: influx,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return VacCenterListTile(
                      vacCenter: snapshot.data!.data[index]);
                },
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            return CircularProgressIndicator();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshAPI,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class VacCenterListTile extends StatelessWidget {
  late Datum vacCenter;
  VacCenterListTile({required Datum vacCenter}) {
    this.vacCenter = vacCenter;
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${this.vacCenter.name}"),
      subtitle: Text(
          "${this.vacCenter.aces} - (${this.vacCenter.getState()} - ${this.vacCenter.getEstimationQueueTime()})"),
      trailing: CircleAvatar(backgroundColor: vacCenter.getColor()),
      //trailing: Icon(Icons.arrow_right),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CenterInfo(center: this.vacCenter)));
      },
    );
  }
}
