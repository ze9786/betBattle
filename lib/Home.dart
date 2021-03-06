import 'package:bet_battle/About.dart';
import 'package:bet_battle/Bet.dart';
import 'package:bet_battle/MyDrawer.dart';
import 'package:bet_battle/Records.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String dropdownValueZ = 'Yes';
  String dropdownValueS = 'Yes';
  List<String> dropdownValue = List<String>();
  String title = '';
  List<Bet> bets = [];
  get wantKeepAlive => true;
  static const color = const Color(0xff3BBEFF);
  static const color1 = const Color(0xff3E80FB);
  static const color2 = const Color(0xff316FE5);
  int counterZ = 0;
  int counterS = 0;

  Future _setData(Bet bet) async {
    FirebaseFirestore.instance
        .collection('bets')
        .doc(DateTime.now().toString())
        .set({
      'title': bet.title,
      'zelina': bet.zelina,
      'stephen': bet.stephen,
      'winner': '?',
    });
  }

  Future _setRecord(Bet bet) async {
    FirebaseFirestore.instance
        .collection('records')
        .doc(DateTime.now().toString())
        .set({
      'title': bet.title,
      'zelina': bet.zelina,
      'stephen': bet.stephen,
      'winner': bet.winner,
      'paid': false
    });
  }

  Future _updateData(
      DocumentSnapshot documentSnapshot, int index, String winner) async {
    FirebaseFirestore.instance.collection('bets').doc(documentSnapshot.id).set({
      'title': documentSnapshot.get('title'),
      'zelina': documentSnapshot.get('zelina'),
      'stephen': documentSnapshot.get('stephen'),
      'winner': winner,
    });
  }

  Future _deleteData(DocumentSnapshot documentSnapshot) async {
    FirebaseFirestore.instance
        .collection('bets')
        .doc(documentSnapshot.id)
        .delete();
  }

  // @override
  // void initState() {
  //   for (int i = 0; i < dropdownValue.length; i++) {
  //     dropdownValue[i] = ;
  //   }
  // }

  TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document, int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Move',
          color: color1,
          icon: Icons.move_to_inbox,
          onTap: () {
            _deleteData(document);
            _setRecord(Bet(
                title: document.get('title'),
                zelina: document.get('zelina'),
                stephen: document.get('stephen'),
                winner: document.get('winner')));
          },
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteData(document),
        ),
      ],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(width: 100, child: Text(document.get('title'))),
          Text(document.get('zelina') ? "Yes" : "No"),
          Text(document.get('stephen') ? "Yes" : "No"),
          DropdownButton(
            value: dropdownValue[index].toString() ?? '?',
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: color1),
            underline: Container(
              height: 2,
              color: color1,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue[index] = newValue;
                _updateData(document, index, newValue);
              });
            },
            items: <String>['?', 'Zelina', 'Stephen']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  int selectedIndex = 0;
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
        title: Text("Bet details"),
        automaticallyImplyLeading: false,
        // leading: FlatButton(
        //   child: Icon(Icons.add),
        // )
      ),
      body: SafeArea(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    height: 400,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 80,
                              child: Text('Title'),
                            ),
                            Text('Zelina'),
                            Text('Stephen'),
                            Text('Winner'),
                          ],
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Expanded(
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('bets')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context).primaryColor),
                                      ),
                                    );
                                  } else {
                                    if (dropdownValue != null)
                                      dropdownValue.clear();
                                    for (int i = 0;
                                        i < snapshot.data.documents.length;
                                        i++) {
                                      dropdownValue.add(snapshot
                                              .data.documents[i]
                                              .get('winner') ??
                                          '?');
                                      print(snapshot.data.documents[i]
                                          .get('winner'));
                                    }
                                    return ListView.separated(
                                      separatorBuilder: (context, int) =>
                                          Divider(),
                                      itemBuilder: (context, index) =>
                                          buildItem(
                                              context,
                                              snapshot.data.documents[index],
                                              index),
                                      itemCount:
                                          snapshot.data.documents.length ?? 0,
                                    );
                                  }
                                }))
                      ],
                    )),
                Divider(
                  thickness: 2,
                  height: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: color,
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                        child: Column(
                          children: [
                            Text('Bet Title'),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'What do you wanna bet?',
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              controller: controller,
                              onChanged: (value) {
                                title = value;
                              },
                              focusNode: focusNode,
                            ),
                            SizedBox(height: 5),
                            Text('Zelina Bet'),
                            DropdownButton<String>(
                              value: dropdownValueZ,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: color2),
                              underline: Container(
                                height: 2,
                                color: color1,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValueZ = newValue;
                                });
                              },
                              items: <String>[
                                'Yes',
                                'No'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            Text('Stephen Bet'),
                            DropdownButton<String>(
                              value: dropdownValueS,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: color2),
                              underline: Container(
                                height: 2,
                                color: color1,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValueS = newValue;
                                });
                              },
                              items: <String>[
                                'Yes',
                                'No'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            if (title == '')
                              _showDialog();
                            else if (dropdownValueS == dropdownValueZ)
                              _showSameDialog();
                            else {
                              bets.add(Bet(
                                  title: title,
                                  zelina:
                                      dropdownValueZ == "Yes" ? true : false,
                                  stephen:
                                      dropdownValueS == "Yes" ? true : false,
                                  winner: '?'));
                              //add to cloud firestore
                              _setData(Bet(
                                  title: title,
                                  zelina:
                                      dropdownValueZ == "Yes" ? true : false,
                                  stephen:
                                      dropdownValueS == "Yes" ? true : false,
                                  winner: '?'));
                              controller.clear();
                              title = '';
                            }
                          });
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error🤓"),
          content: new Text("You need to type the title of bet!!!🤪"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSameDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error🤓"),
          content: new Text("Both of you cannot bet the same thing!!😡"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
