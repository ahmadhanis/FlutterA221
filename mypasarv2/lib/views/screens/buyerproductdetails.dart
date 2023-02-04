// ignore_for_file: unused_import, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mypasarv2/serverconfig.dart';
import 'package:mypasarv2/models/product.dart';
import 'package:mypasarv2/models/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BuyerProductDetails extends StatefulWidget {
  final Product product;
  final User user;
  final User seller;
  const BuyerProductDetails(
      {super.key,
      required this.product,
      required this.user,
      required this.seller});

  @override
  State<BuyerProductDetails> createState() => _BuyerProductDetailsState();
}

class _BuyerProductDetailsState extends State<BuyerProductDetails> {
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.90;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Details")),
      body: Column(children: [
        Card(
          elevation: 8,
          child: SizedBox(
              height: screenHeight / 3,
              width: resWidth,
              child: CachedNetworkImage(
                width: resWidth,
                fit: BoxFit.cover,
                imageUrl:
                    "${ServerConfig.SERVER}/assets/productimages/${widget.product.productId}.png",
                placeholder: (context, url) => const LinearProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.product.productName.toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: screenWidth - 16,
          child: Table(
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.none, width: 1),
              columnWidths: const {
                0: FixedColumnWidth(70),
                1: FixedColumnWidth(200),
              },
              children: [
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Description', style: TextStyle(fontSize: 20.0))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product.productDesc.toString(),
                            style: const TextStyle(fontSize: 20.0))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Price', style: TextStyle(fontSize: 20.0))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("RM ${widget.product.productPrice}",
                            style: const TextStyle(fontSize: 20.0))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Quantity', style: TextStyle(fontSize: 20.0))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.product.productQty}",
                            style: const TextStyle(fontSize: 20.0))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Locality', style: TextStyle(fontSize: 20.0))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.product.productLocal}",
                            style: const TextStyle(fontSize: 20.0))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('State', style: TextStyle(fontSize: 20.0))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.product.productState}",
                            style: const TextStyle(fontSize: 20.0))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Seller', style: TextStyle(fontSize: 20.0))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.seller.name}",
                            style: const TextStyle(fontSize: 20.0))
                      ]),
                ])
              ]),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Card(
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        iconSize: 32,
                        onPressed: _makePhoneCall,
                        icon: const Icon(Icons.call)),
                    IconButton(
                        iconSize: 32,
                        onPressed: _makeSmS,
                        icon: const Icon(Icons.message)),
                    IconButton(
                        iconSize: 32,
                        onPressed: openwhatsapp,
                        icon: const Icon(Icons.whatsapp)),
                    IconButton(
                        iconSize: 32,
                        onPressed: _onRoute,
                        icon: const Icon(Icons.map)),
                    IconButton(
                        iconSize: 32,
                        onPressed: _onShowMap,
                        icon: const Icon(Icons.maps_home_work))
                  ],
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: widget.seller.phone,
    );
    await launchUrl(launchUri);
  }

  Future<void> _makeSmS() async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: widget.seller.phone,
    );
    await launchUrl(launchUri);
  }

  Future<void> _onRoute() async {
    final Uri launchUri = Uri(
        scheme: 'https',
        // ignore: prefer_interpolation_to_compose_strings
        path: "www.google.com/maps/@" +
            widget.product.productLat.toString() +
            "," +
            widget.product.productLng.toString() +
            "20z");
    await launchUrl(launchUri);
  }

  openwhatsapp() async {
    var whatsapp = widget.seller.phone;
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=hello";
    var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURLIos)) {
        await launch(whatappURLIos, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp not installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURlAndroid)) {
        await launch(whatsappURlAndroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp not installed")));
      }
    }
  }

  int generateIds() {
    var rng = Random();
    int randomInt;
    randomInt = rng.nextInt(100);
    return randomInt;
  }

  void _onShowMap() {
    double lat = double.parse(widget.product.productLat.toString());
    double lng = double.parse(widget.product.productLng.toString());
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    int markerIdVal = generateIds();
    MarkerId markerId = MarkerId(markerIdVal.toString());
    final Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(
        lat,
        lng,
      ),
    );
    markers[markerId] = marker;

    CameraPosition campos = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16.4746,
    );
    Completer<GoogleMapController> ncontroller =
        Completer<GoogleMapController>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Location",
            style: TextStyle(),
          ),
          content: SizedBox(
            //color: Colors.red,
            height: screenHeight,
            width: screenWidth,
            child: GoogleMap(
              mapType: MapType.satellite,
              initialCameraPosition: campos,
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                ncontroller.complete(controller);
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
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
}
