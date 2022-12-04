import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Weather V2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectLoc = "Changlun";
  List<String> locList = [
    "Changlun",
    "Jitra",
    "Alor Setar",
  ];
  String desc = "No Data";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Simple Weather",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            DropdownButton(
              itemHeight: 60,
              value: selectLoc,
              onChanged: (newValue) {
                setState(() {
                  selectLoc = newValue.toString();
                });
              },
              items: locList.map((selectLoc) {
                return DropdownMenuItem(
                  value: selectLoc,
                  child: Text(
                    selectLoc,
                  ),
                );
              }).toList(),
            ),
            ElevatedButton(
                onPressed: _getWeather, child: const Text("Load Weather")),
            Text(desc,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future<void> _getWeather() async {
    var apiid = "15de80e1abffb64ec7d59b4432709513";
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$selectLoc&appid=$apiid&units=metric');
    var response = await http.get(url);
    var responses = await http.put(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        var temp = parsedJson['main']['temp'];
        var hum = parsedJson['main']['humidity'];
        var weather = parsedJson['weather'][0]['main'];
        desc =
            "The current weather in $selectLoc is $weather. The current temperature is $temp Celcius and humidity is $hum percent. ";
      });
    }else {
      setState(() {
        desc = "No record";
      });
    }

  }
}
