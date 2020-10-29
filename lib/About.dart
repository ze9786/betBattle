import 'package:bet_battle/Home.dart';
import 'package:bet_battle/MyDrawer.dart';
import 'package:bet_battle/Records.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int selectedIndex = 2;
  PageController _pageController;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (_) => Home()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => RecordScreen()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => AboutScreen()));
        break;
    }
  }

  @override
  void initState() {
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: MyDrawer(),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.move_to_inbox), label: "Records"),
      //     BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
      //   ],
      //   currentIndex: selectedIndex,
      //   fixedColor: Theme.of(context).primaryColor,
      //   onTap: onItemTapped,
      // ),
      appBar: AppBar(
        title: Text("About"),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bet with your friends"),
            Text("2020, Product of Zelina To"),
            Text("Version number: v1.4.1"),
          ],
        )),
      ),
    );
  }
}
