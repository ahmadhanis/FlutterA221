import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mypasarv2/models/user.dart';
import 'package:mypasarv2/serverconfig.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BillScreen extends StatefulWidget {
  final User user;
  final int credit;

  const BillScreen({super.key, required this.user, required this.credit});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  double prg = 1.0;
  late double screenHeight, screenWidth, resWidth;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isLoading = true;
    return Scaffold(
      appBar: AppBar(title: const Text("Billing")),
      body: Center(
        child: Stack(children: [
          WebView(
            initialUrl:
                '${ServerConfig.SERVER}/php/payment.php?userid=${widget.user.id}&email=${widget.user.email}&phone=${widget.user.phone}&name=${widget.user.name}&curcredit=${widget.user.credit}&amount=${widget.credit}',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onProgress: (int progress) {
              // prg = progress as double;
              // setState(() {});
              // print('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              // print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              //print('Page finished loading: $url');
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? const Center(
                  // child: LinearProgressIndicator(
                  //   value: prg,
                  // ),
                )
              : Stack(),
        ]),
      ),
    );
  }
}
