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

  Widget buildItem(DocumentSnapshot document) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(width: 70, child: Text(document.get('title'))),
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
      drawer: Drawer(
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => RecordScreen()));
                }),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Bet Records"),
        // leading: FlatButton(
        //   child: Icon(Icons.add),
        // )
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 50,
                  child: Text('Title'),
                ),
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
            )
          ],
        ),
      )),
    );
  }
}
