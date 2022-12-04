import 'package:flutter/material.dart';
import '../screens/mainscreen.dart';
import '../screens/profilescreen.dart';
import '../screens/sellerscreen.dart';
import 'EnterExitRoute.dart';

class MainMenuWidget extends StatefulWidget {
  const MainMenuWidget({super.key});

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 10,
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountEmail: Text("Unregistered"),
            accountName: Text("Unregistered"),
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
            ),
          ),
          ListTile(
            title: const Text('Buyer'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (content) => MainScreen()));
              Navigator.push(context,
                  EnterExitRoute(exitPage: MainScreen(), enterPage: MainScreen()));
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
                      exitPage: MainScreen(), enterPage: SellerScreen()));
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
              Navigator.push(context,
                  EnterExitRoute(exitPage: MainScreen(), enterPage: ProfileScreen()));
            },
          ),
        ],
      ),
    );
  }
}
