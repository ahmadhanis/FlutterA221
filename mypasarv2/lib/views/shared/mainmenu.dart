import 'package:flutter/material.dart';
import 'package:mypasarv2/serverconfig.dart';
import '../../models/user.dart';
import '../screens/buyerscreen.dart';
import '../screens/profilescreen.dart';
import '../screens/sellerscreen.dart';
import 'EnterExitRoute.dart';

class MainMenuWidget extends StatefulWidget {
  final User user;
  const MainMenuWidget({super.key, required this.user});

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  late double screenHeight;
  var pathAsset = "assets/images/profile.png";
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      width: 250,
      elevation: 10,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(widget.user.email.toString()),
            accountName: Text(widget.user.name.toString()),
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
              child: ClipOval(
                child: Image.network(
                  "${ServerConfig.SERVER}/assets/profileimages/${widget.user.id}.png",
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(pathAsset);
                  },
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Buyer'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (content) => BuyerScreen()));
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: BuyerScreen(user: widget.user),
                      enterPage: BuyerScreen(user: widget.user)));
            },
          ),
          ListTile(
            title: const Text('Seller'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (content) => const SellerScreen()));
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: BuyerScreen(user: widget.user),
                      enterPage: SellerScreen(user: widget.user)));
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (content) => const ProfileScreen()));
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: BuyerScreen(user: widget.user),
                      enterPage: ProfileScreen(
                        user: widget.user,
                      )));
            },
          ),
          const Divider(
            color: Colors.blue,
          ),
          SizedBox(
            height: screenHeight / 2.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [Text("Version 0.1b")],
            ),
          )
        ],
      ),
    );
  }
}
