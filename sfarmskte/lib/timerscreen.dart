// ignore_for_file: use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sfarmskte/mytime.dart';

class TimerScreen extends StatefulWidget {
  final MyTime mytime;

  const TimerScreen({super.key, required this.mytime});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  String? time1, time2, time3, time4, time5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Auto Timer")),
        body: ListView(
          children: [
            Card(
              child: Column(children: [
                ListTile(
                  leading: const Icon(Icons.timer),
                  title: const Text('Timer 1'),
                  subtitle:
                      Text(time24to12Format(widget.mytime.time1.toString())),
                ),
                ButtonBar(
                  children: [
                    TextButton(
                        onPressed: () {
                          updateTimeDialog(1);
                        },
                        child: const Text("Set")),
                    TextButton(onPressed: () {}, child: const Text("Reset"))
                  ],
                )
              ]),
            ),
            Card(
              child: Column(children: [
                ListTile(
                  leading: const Icon(Icons.timer),
                  title: const Text('Timer 2'),
                  subtitle:
                      Text(time24to12Format(widget.mytime.time2.toString())),
                ),
                ButtonBar(
                  children: [
                    TextButton(
                        onPressed: () {
                          updateTimeDialog(2);
                        },
                        child: const Text("Set")),
                    TextButton(onPressed: () {}, child: const Text("Reset"))
                  ],
                )
              ]),
            ),
            Card(
              child: Column(children: [
                ListTile(
                  leading: const Icon(Icons.timer),
                  title: const Text('Timer 3'),
                  subtitle:
                      Text(time24to12Format(widget.mytime.time3.toString())),
                ),
                ButtonBar(
                  children: [
                    TextButton(
                        onPressed: () {
                          updateTimeDialog(3);
                        },
                        child: const Text("Set")),
                    TextButton(onPressed: () {}, child: const Text("Reset"))
                  ],
                )
              ]),
            ),
            Card(
              child: Column(children: [
                ListTile(
                  leading: const Icon(Icons.timer),
                  title: const Text('Timer 4'),
                  subtitle:
                      Text(time24to12Format(widget.mytime.time4.toString())),
                ),
                ButtonBar(
                  children: [
                    TextButton(
                        onPressed: () {
                          updateTimeDialog(4);
                        },
                        child: const Text("Set")),
                    TextButton(onPressed: () {}, child: const Text("Reset"))
                  ],
                )
              ]),
            ),
            Card(
              child: Column(children: [
                ListTile(
                  leading: const Icon(Icons.timer),
                  title: const Text('Timer 5'),
                  subtitle:
                      Text(time24to12Format(widget.mytime.time5.toString())),
                ),
                ButtonBar(
                  children: [
                    TextButton(
                        onPressed: () {
                          updateTimeDialog(5);
                        },
                        child: const Text("Set")),
                    TextButton(onPressed: () {}, child: const Text("Reset"))
                  ],
                )
              ]),
            ),
          ],
        ));
  }

  String time24to12Format(String time) {
// var time = "12:01 AM";
    if (time.isEmpty) {
      return "not available";
    }
    String nh, nm;
    String meridium = "";
    int h = int.parse(time.split(":").first);
    int m = int.parse(time.split(":").last.split(" ").first);
    if (h > 12) {
      h = h - 12;
      meridium = "PM";
      if (h < 10) {
        nh = "0$h";
      } else {
        nh = h.toString();
      }
    } else {
      h = h;
      if (h < 10) {
        nh = "0$h";
      } else {
        nh = h.toString();
      }
      //nh = h.toString();
      meridium = "AM";
    }
    if (m < 10) {
      nm = "0$m";
    } else {
      nm = m.toString();
    }
    //String newTime = "${h == 0 ? "00" : h}:${m == 0 ? "00" : m} $meridium";
    String newTime = "$nh:$nm $meridium";
    //print(newTime);

    return newTime;
  }

  Future<void> updateTimeDialog(int i) async {
    final TimeOfDay? time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        if (i == 1) {
          time1 = time.format(context);
          //print(time12to24Format(time1!));
          setAutoTimer("time1", time12to24Format(time1!));
        }
        if (i == 2) {
          time2 = time.format(context);
          //print(time12to24Format(time2!));
          setAutoTimer("time2", time12to24Format(time2!));
        }
        if (i == 3) {
          time3 = time.format(context);
          //print(time12to24Format(time3!));
          setAutoTimer("time3", time12to24Format(time3!));
        }
        if (i == 4) {
          time4 = time.format(context);
          //print(time12to24Format(time4!));
          setAutoTimer("time4", time12to24Format(time4!));
        }
        if (i == 5) {
          time5 = time.format(context);
          //print(time12to24Format(time5!));
          setAutoTimer("time5", time12to24Format(time5!));
        }
      });
    }
  }

  Future<void> setAutoTimer(String timer, String newtime) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("telagamas/");
    await ref.update({
      timer: newtime,
    });
    if (timer == "time1") {
      widget.mytime.time1 = newtime;
    }
    if (timer == "time2") {
      widget.mytime.time2 = newtime;
    }
    if (timer == "time3") {
      widget.mytime.time3 = newtime;
    }
    if (timer == "time4") {
      widget.mytime.time4 = newtime;
    }
    if (timer == "time5") {
      widget.mytime.time5 = newtime;
    }
    setState(() {});
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Update Success")));
  }

  String time12to24Format(String time) {
// var time = "12:01 AM";
    int h = int.parse(time.split(":").first);
    int m = int.parse(time.split(":").last.split(" ").first);
    String meridium = time.split(":").last.split(" ").last.toLowerCase();
    if (meridium == "pm") {
      if (h != 12) {
        h = h + 12;
      }
    }
    if (meridium == "am") {
      if (h == 12) {
        h = 00;
      }
    }
    String newTime = "${h == 0 ? "00" : h}:${m == 0 ? "00" : m}";
    //print(newTime);

    return newTime;
  }
}
