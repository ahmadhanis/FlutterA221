import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController numacontroller = TextEditingController();
  TextEditingController numbcontroller = TextEditingController();
  int result = 0;
  // AudioCache audioCache = AudioCache();
  // AudioPlayer audioPlayer = AudioPlayer();
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.amber,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/calculator.png', scale: 1.5),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: numacontroller,
                      decoration: InputDecoration(
                          hintText: 'First number',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      keyboardType: const TextInputType.numberWithOptions(),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: numbcontroller,
                      decoration: InputDecoration(
                          hintText: 'Second number',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      keyboardType: const TextInputType.numberWithOptions(),
                    ),
                    ElevatedButton(
                        onPressed: _pressMe, child: const Text("Press ME")),
                    Text(
                      "Result :$result",
                      style: const TextStyle(fontSize: 32),
                    ),
                     ElevatedButton(
                        onPressed: _loadOk, child: const Text("Play")),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void _pressMe() {
    int a = int.parse(numacontroller.text);
    int b = int.parse(numbcontroller.text);
    result = a + b;
    setState(() {});
  }

  Future _loadOk() async {
    await player.play(AssetSource('sounds/bell.wav'));
  }

  Future loadFail() async {}
}
