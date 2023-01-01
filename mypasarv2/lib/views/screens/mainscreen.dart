import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypasarv2/config.dart';
import 'package:mypasarv2/models/product.dart';
import '../../models/user.dart';
import '../shared/mainmenu.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Product> productList = <Product>[];
  String titlecenter = "Loading...";
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(title: const Text("Buyers")),
          body: productList.isEmpty
              ? Center(
                  child: Text(titlecenter,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Your current products/services (${productList.length} found)",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: rowcount,
                        children: List.generate(productList.length, (index) {
                          return Card(
                            elevation: 8,
                            child: InkWell(
                              onTap: _showDetails,
                              child: Column(children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Flexible(
                                  flex: 6,
                                  child: CachedNetworkImage(
                                    width: resWidth / 2,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${Config.SERVER}/assets/productimages/${productList[index].productId}.png",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Flexible(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            truncateString(
                                                productList[index]
                                                    .productName
                                                    .toString(),
                                                15),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              "RM ${double.parse(productList[index].productPrice.toString()).toStringAsFixed(2)}"),
                                          Text(df.format(DateTime.parse(
                                              productList[index]
                                                  .productDate
                                                  .toString()))),
                                        ],
                                      ),
                                    ))
                              ]),
                            ),
                          );
                        }),
                      ),
                    )
                  ],
                ),
          drawer: MainMenuWidget(user: widget.user),
        ));
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  void _loadProducts() {
    http
        .get(
      Uri.parse("${Config.SERVER}/php/loadallproducts.php"),
    )
        .then((response) {
      print(response.body);
      // wait for response from the request
      if (response.statusCode == 200) {
        //if statuscode OK
        var jsondata =
            jsonDecode(response.body); //decode response body to jsondata array
        if (jsondata['status'] == 'success') {
          //check if status data array is success
          var extractdata = jsondata['data']; //extract data from jsondata array
          if (extractdata['products'] != null) {
            //check if  array object is not null
            productList = <Product>[]; //complete the array object definition
            extractdata['products'].forEach((v) {
              //traverse products array list and add to the list object array productList
              productList.add(Product.fromJson(
                  v)); //add each product array to the list object array productList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No Product Available"; //if no data returned show title center
            productList.clear();
          }
        }
      } else {
        titlecenter = "No Product Available"; //status code other than 200
        productList.clear(); //clear productList array
      }
      setState(() {}); //refresh UI
    });
  }

  void _showDetails() {}
}
