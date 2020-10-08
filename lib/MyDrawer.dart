import 'package:bet_battle/About.dart';
import 'package:flutter/material.dart';

import 'Home.dart';
import 'Records.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text("hihi")),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Home()));
            },
          ),
          ListTile(
              leading: Icon(Icons.move_to_inbox),
              title: Text('Records'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => RecordScreen()));
              }),
          ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AboutScreen()));
              }),
        ],
      ),
    );
  }
}
