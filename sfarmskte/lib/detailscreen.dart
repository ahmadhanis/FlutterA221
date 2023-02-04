// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:sfarmskte/mydevice.dart';

import 'mytime.dart';
import 'timerscreen.dart';

class DetailScreen extends StatefulWidget {
  final MyDevice myDevice;
  const DetailScreen({super.key, required this.myDevice});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String dtupdate = "",
      mode = "1",
      ctime = "",
      time1 = "08:00",
      time2 = "11:00",
      time3 = "18:00",
      time4 = "23:00",
      time5 = "04:00",
      temp = "",
      humidity = "",
      auto = "",
      relay = "",
      motor = "",
      timeupdate = "";
  final df = DateFormat('DD-MM-yyyy hh:mm a');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Farming")),
      body: RefreshIndicator(
        onRefresh: () async {
          loadData();
        },
        child: ListView(children: [
          Card(
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.lock_clock),
                title: const Text('Last Update'),
                subtitle: Text("$dtupdate  ${time24to12Format(timeupdate)}"),
              ),
            ]),
          ),
          Card(
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.thermostat),
                title: const Text('Temperature'),
                subtitle: Text("$temp C"),
              ),
            ]),
          ),
          Card(
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.sunny),
                title: const Text('Humidity'),
                subtitle: Text("$humidity %"),
              ),
            ]),
          ),
          Card(
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.adb),
                title: const Text('Mode'),
                subtitle: Text(auto),
              ),
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () {
                        setAuto(true);
                      },
                      child: const Text("Auto")),
                  TextButton(
                      onPressed: () {
                        setAuto(false);
                      },
                      child: const Text("Manual"))
                ],
              )
            ]),
          ),
          Card(
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.switch_access_shortcut),
                title: const Text('Motor'),
                subtitle: Text(motor),
              ),
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () {
                        updateMotor(true);
                      },
                      child: const Text("On")),
                  TextButton(
                      onPressed: () {
                        updateMotor(false);
                      },
                      child: const Text("Off"))
                ],
              )
            ]),
          ),
          Card(
            child: InkWell(
              onTap: setTimer,
              child: Column(children: const [
                ListTile(
                  leading: Icon(Icons.timer),
                  title: Text('Set Timer'),
                ),
              ]),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadData,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  loadData() async {
    String devicename = widget.myDevice.devicename.toString();
    DatabaseReference ref = FirebaseDatabase.instance.ref('$devicename/');
    var event = await ref.once(DatabaseEventType.value);
    var data = event.snapshot.value;
    if (data is Map) {
      //print(data);
      data.forEach((key, value) {
        if (key.toString() == "dtupdate") {
          dtupdate = value.toString();
        }
        if (key.toString() == "mode") {
          mode = value.toString();
          if (mode == "1") {
            auto = "Automatic";
          } else {
            auto = "Manual";
          }
        }
        if (key.toString() == "temp") {
          temp = value.toString();
        }
        if (key.toString() == "relay") {
          relay = value.toString();
          if (relay == "1") {
            motor = "On";
          } else {
            motor = "Off";
          }
        }
        if (key.toString() == "timeupdate") {
          timeupdate = value.toString();
        }
        if (key.toString() == "humidity") {
          humidity = value.toString();
        }
        if (key.toString() == "time1") {
          time1 = value.toString();
        }
        if (key.toString() == "time2") {
          time2 = value.toString();
        }
        if (key.toString() == "time3") {
          time3 = value.toString();
        }
        if (key.toString() == "time4") {
          time4 = value.toString();
        }
        if (key.toString() == "time5") {
          time5 = value.toString();
        }
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Update Success")));
      //String t = time24to12Format(timeupdate);
      // print(t);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Update Failed")));
    }
  }

  void setTimer() {
    MyTime mytime = MyTime(
        time1: time1, time2: time2, time3: time3, time4: time4, time5: time5);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => TimerScreen(
                  mytime: mytime,
                )));
  }

  updateMotor(bool status) async {
    String devicename = widget.myDevice.devicename.toString();
    DatabaseReference ref = FirebaseDatabase.instance.ref("$devicename/");
    if (auto == "Automatic") {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Only in manual mode")));
      return;
    }
    if (status) {
      await ref.update({
        "relay": 1,
      });
    } else {
      await ref.update({
        "relay": 0,
      });
    }
    loadData();
  }

  Future<void> setAuto(bool status) async {
    String devicename = widget.myDevice.devicename.toString();
    DatabaseReference ref = FirebaseDatabase.instance.ref("$devicename/");
    if (status) {
      await ref.update({
        "mode": 1,
      });
    } else {
      await ref.update({
        "mode": 0,
      });
    }
    loadData();
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
    // print(newTime);

    return newTime;
  }
}
