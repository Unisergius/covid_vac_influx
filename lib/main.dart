import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:covid_vac_influx/counties.dart';
import 'package:covid_vac_influx/influxDetails.dart';
import 'package:logger/logger.dart';
import 'dart:async' show Future;

var logger = Logger(
  printer: PrettyPrinter(),
);

//import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid Vac Influx',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Select your County'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<String> _loadLocalData(String jsonFile) async {
  return await rootBundle.loadString('$jsonFile');
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Counties> fetchQuests({String? query}) async {
    String jsonString = await _loadLocalData("counties.json");
    return countiesFromJson(jsonString, query);
  }

  late Future<Counties> counties;

  @override
  void initState() {
    super.initState();
    counties = fetchQuests();
  }

  void _repopulate(String? text) async {
    if (text != null && text.length > 1) {
      setState(() {
        counties = fetchQuests(query: text);
      });
    } else {
      setState(() {
        counties = fetchQuests();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder<Counties>(
            future: counties,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.countyNames.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: Text(snapshot.data!.countyNames[index]),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InfluxPage(
                                        title: "Centros",
                                        countyName: snapshot
                                            .data!.countyNames[index])));
                          });
                    });
              } else if (snapshot.hasError) {
                return Text("Error: $snapshot.error}");
              }
              return CircularProgressIndicator();
            }),
        bottomNavigationBar: ListTile(
          tileColor: Colors.green[50],
          title: TextField(onChanged: _repopulate),
          trailing: Icon(Icons.search),
        ));
  }
}
