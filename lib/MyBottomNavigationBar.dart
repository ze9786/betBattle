import 'package:bet_battle/Home.dart';
import 'package:flutter/material.dart';

import 'About.dart';
import 'Records.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int selectedIndex = 0;
  final List<Widget> _children = [Home(), RecordScreen(), AboutScreen()];

  PageController _pageController;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    // switch (index) {
    //   case 0:
    //     Navigator.push(context, MaterialPageRoute(builder: (_) => Home()));
    //     break;
    //   case 1:
    //     Navigator.push(
    //         context, MaterialPageRoute(builder: (_) => RecordScreen()));
    //     break;
    //   case 2:
    //     Navigator.push(
    //         context, MaterialPageRoute(builder: (_) => AboutScreen()));
    //     break;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.move_to_inbox), label: "Records"),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
          ],
          currentIndex: selectedIndex,
          fixedColor: Theme.of(context).primaryColor,
          onTap: onItemTapped,
        ));
  }
}
