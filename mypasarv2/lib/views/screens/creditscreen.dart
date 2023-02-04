import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypasarv2/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mypasarv2/serverconfig.dart';

import 'billscreen.dart';

class CreditScreen extends StatefulWidget {
  final User user;

  const CreditScreen({super.key, required this.user});

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy');
  int val = -1;
  List<String> creditType = ["5", "10", "15", "20", "25", "50", "100", "1000"];
  String selectedValue = "5";
  double price = 0.0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Card(
            elevation: 10,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: screenHeight * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.user.name.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 8),
                    child: Divider(
                      color: Colors.blueGrey,
                      height: 2,
                      thickness: 2.0,
                    ),
                  ),
                  Table(
                    columnWidths: const {
                      0: FractionColumnWidth(0.3),
                      1: FractionColumnWidth(0.7)
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        const Icon(Icons.email),
                        Text(widget.user.email.toString()),
                      ]),
                      TableRow(children: [
                        const Icon(Icons.phone),
                        Text(widget.user.phone.toString()),
                      ]),
                      TableRow(children: [
                        const Icon(Icons.credit_score),
                        Text(widget.user.credit.toString()),
                      ]),
                      widget.user.regdate.toString() == ""
                          ? TableRow(children: [
                              const Icon(Icons.date_range),
                              Text(df.format(DateTime.parse(
                                  widget.user.regdate.toString())))
                            ])
                          : TableRow(children: [
                              const Icon(Icons.date_range),
                              Text(widget.user.regdate.toString())
                            ]),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
            child: Card(
              elevation: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                width: screenWidth,
                height: screenHeight * 0.35,
                child: Column(
                  children: [
                    const Text("BUY CREDIT",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    const Text("Select Credit Value "),
                    SizedBox(
                      height: 60,
                      width: 100,
                      child: DropdownButton(
                        isExpanded: true,
                        //sorting dropdownoption
                        hint: const Text(
                          'Please select credit value',
                          style: TextStyle(
                            color: Color.fromRGBO(101, 255, 218, 50),
                          ),
                        ), // Not necessary for Option 1
                        value: selectedValue,
                        onChanged: (newValue) {
                          setState(() {
                            selectedValue = newValue.toString();

                            // print(selectedValue);
                          });
                        },
                        items: creditType.map((selectedValue) {
                          return DropdownMenuItem(
                            value: selectedValue,
                            child:
                                Text(selectedValue, style: const TextStyle()),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("RM ${double.parse(selectedValue).toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _buycreditDialog,
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(screenWidth / 2, 50)),
                      child: const Text("BUY"),
                    ),
                  ],
                ),
              ),
            ))
      ]),
    );
  }

  void _buycreditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Buy Credit RM ${double.parse(selectedValue).toStringAsFixed(2)}?",
            style: const TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => BillScreen(
                              user: widget.user,
                              credit: int.parse(selectedValue),
                            )));
                _loadNewCredit();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _loadNewCredit() {
    http.post(Uri.parse("${ServerConfig.SERVER}/php/load_user.php"),
        body: {"userid": widget.user.id}).then((response) {
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        final jsonResponse = json.decode(response.body);
       // print(response.body);
        User newuser = User.fromJson(jsonResponse['data']);
        widget.user.credit = newuser.credit;
        setState(() {});
      }
    });
  }
}
