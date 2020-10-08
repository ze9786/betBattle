import 'package:bet_battle/MyDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  Widget buildItem(DocumentSnapshot document) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(width: 100, child: Text(document.get('title'))),
        Text(document.get('zelina') ? "Yes" : "No"),
        Text(document.get('stephen') ? "Yes" : "No"),
        Text(document.get('winner')),
        Checkbox(
            value: document.get('paid'),
            onChanged: (bool newValue) {
              setState(() {
                _updateRecord(document, newValue);
              });
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Bet Records"),
        // leading: FlatButton(
        //   child: Icon(Icons.add),
        // )
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: ListView(
          children: [
            // Container(
            //   height: 30,
            //   color: Colors.green[100],
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       //TODO: counter for the bet wins
            //       Text('Zelina: ' + countWin('Zelina').toString()),
            //       Text('Stephen: ' + countWin('Stephen').toString())
            //     ],
            //   ),
            // ),
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
            StreamBuilder(
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
          ],
        ),
      )),
    );
  }
}
