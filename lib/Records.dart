import 'package:bet_battle/MyDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'About.dart';
import 'Home.dart';

class RecordScreen extends StatefulWidget {
  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  Future _updateRecord(DocumentSnapshot doc, bool value) async {
    FirebaseFirestore.instance.collection('records').doc(doc.id).set({
      'title': doc.get('title'),
      'zelina': doc.get('zelina'),
      'stephen': doc.get('stephen'),
      'winner': doc.get('winner'),
      'paid': value
    });
  }

  @override
  void initState() {
    print(countWin('Zelina'));
    _pageController = PageController();
  }

  int countWin(String name) {
    var snapshots =
        FirebaseFirestore.instance.collection('records').snapshots();
    List<String> counter = new List();
    snapshots.forEach((snapshot) {
      for (int i = 0; i < snapshot.docs.length; i++) {
        // snapshot.docs.forEach((element) {
        if (snapshot.docs[i].data().values.elementAt(1) == name)
          counter.add(name);
        // if (i == snapshot.docs.length - 1) {
        //   // print(counter);
        //   return counter;
        // }
      }
    });
    print(counter.length);
    return counter.length;
  }

  Future _deleteData(DocumentSnapshot documentSnapshot) async {
    FirebaseFirestore.instance
        .collection('records')
        .doc(documentSnapshot.id)
        .delete();
  }

  Widget buildItem(DocumentSnapshot document) {
    bool _isEnabled = !document.get('paid');
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteData(document),
        )
      ],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(width: 100, child: Text(document.get('title'))),
          Text(document.get('zelina') ? "Yes" : "No"),
          Text(document.get('stephen') ? "Yes" : "No"),
          Text(document.get('winner')),
          Checkbox(
              value: document.get('paid'),
              onChanged: _isEnabled
                  ? (bool newValue) {
                      setState(() {
                        _updateRecord(document, newValue);
                        _isEnabled = false;
                      });
                    }
                  : null)
        ],
      ),
    );
  }

  int selectedIndex = 1;
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
        title: Text("Bet Records"),
        automaticallyImplyLeading: false,
        // leading: FlatButton(
        //   child: Icon(Icons.add),
        // )
      ),
      body: SafeArea(
          child: Column(children: [
        Stack(
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 60,
                        child: Text('Title'),
                      ),
                      SizedBox(width: 10),
                      Text('Zelina'),
                      Text('Stephen'),
                      Text('Winner'),
                      Text('Paid?')
                    ],
                  ),
                  Divider(
                    thickness: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('records').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                );
              } else {
                return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        buildItem(snapshot.data.documents[index]),
                    separatorBuilder: (context, int) => Divider(),
                    itemCount: snapshot.data.documents.length ?? 0);
              }
            },
          ),
        ),
        SizedBox(height: 3)
      ])),
    );
  }
}
