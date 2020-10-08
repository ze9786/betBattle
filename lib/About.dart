import 'package:bet_battle/MyDrawer.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Text("Bet with your friends"),
      ),
    );
  }
}
