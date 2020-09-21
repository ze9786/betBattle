import 'package:bet_battle/Bet.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String dropdownValueZ = 'Yes';
  String dropdownValueS = 'Yes';
  String dropdownValue = '?';
  String title = '';
  List<Bet> bets = [];

  TextEditingController controller;
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    const color = const Color(0xff3BBEFF);
    const color1 = const Color(0xff3E80FB);
    const color2 = const Color(0xff316FE5);
    return Scaffold(
      appBar: AppBar(
        title: Text("Bet details"),
        // leading: FlatButton(
        //   child: Icon(Icons.add),
        // )
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    height: 500,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Title'),
                            SizedBox(
                              width: 5,
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
                          child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => Divider(),
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(bets[index].title),
                                  Text(bets[index].zelina ? "Yes" : "No"),
                                  Text(bets[index].stephen ? "Yes" : "No"),
                                  DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: color1),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownValue = newValue;
                                      });
                                    },
                                    items: <String>['?', 'Zelina', 'Stephen']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              );
                            },
                            itemCount: bets == null ? 0 : bets.length,
                          ),
                        )
                      ],
                    )),
                Divider(),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: color,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text('Bet Title'),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'What do you wanna bet?',
                                hintStyle: TextStyle(color: Colors.grey),
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
                            bets.add(Bet(
                              title: title,
                              zelina: dropdownValueZ == "Yes" ? true : false,
                              stephen: dropdownValueS == "Yes" ? true : false,
                            ));
                            title = '';
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
}
