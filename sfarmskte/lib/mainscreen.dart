// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:sfarmskte/detailscreen.dart';
import 'package:sfarmskte/mydevice.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<MyDevice> myDevices = <MyDevice>[];
  String titlecenter = "Loading...";
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
      body: myDevices.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Device/s ${myDevices.length} found",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        children: List.generate(myDevices.length, (index) {
                          return Card(
                            child: InkWell(
                              onTap: () {
                                showDetails(index);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          myDevices[index]
                                              .devicename
                                              .toString()
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "Date ${myDevices[index].dtupdate}",
                                      ),
                                      Text(
                                          "Last update on ${time24to12Format(myDevices[index].timeupdate.toString())}"),
                                      Text(
                                          "Temperature ${myDevices[index].temp} celcius"),
                                      Text(
                                          "Humidity ${myDevices[index].humidity} %"),
                                    ]),
                              ),
                            ),
                          );
                        })))
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadData,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  loadData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('');
    var event = await ref.once(DatabaseEventType.value);
    var data = event.snapshot.value;
    if (data is Map) {
      myDevices = <MyDevice>[];

      data.forEach((key, value) {
        //print(value['devicename']);
        MyDevice mydevice = MyDevice(
          devicename: value['devicename'].toString(),
          dtupdate: value['dtupdate'].toString(),
          humidity: value['humidity'].toString(),
          mode: value['mode'].toString(),
          relay: value['relay'].toString(),
          temp: value['temp'].toString(),
          time1: value['time1'].toString(),
          time2: value['time2'].toString(),
          time3: value['time3'].toString(),
          time4: value['time4'].toString(),
          time5: value['time5'].toString(),
          timeupdate: value['timeupdate'].toString(),
        );
        myDevices.add(mydevice);
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Update Success")));
      //String t = time24to12Format(timeupdate);
      // print(t);
      setState(() {});
    } else {
      titlecenter = "No data";
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Update Failed")));
    }
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

  showDetails(int index) {
    MyDevice mydevice = MyDevice.fromJson(myDevices[index].toJson());
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => DetailScreen(
                  myDevice: mydevice,
                )));
  }
}
