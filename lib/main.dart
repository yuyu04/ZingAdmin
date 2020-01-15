import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zing_admin/model/waiting.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'i18n/localizations.dart';
import 'i18n/messages.dart';

void main() => runApp(ZingAdmin());

final msg = Messages();

class ZingAdmin extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zing Admin',
      localizationsDelegates: [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdminPage(title: 'Zing Admin Page'),
    );
  }
}

class AdminPage extends StatefulWidget {
  AdminPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Waiting> waitings;
  int waitingTimePerTeam = 5;

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull('http://jsonplaceholder.typicode.com/posts'),
        headers: {"Accept": "application/json"});
    this.setState(() {
      List data = jsonDecode(response.body);
      int count = 0;
      for (final i in data) {
        this.waitings.add(Waiting(i, count+1));
        count+=1;
      }
    });
    return "success";
  }

  @override void initState() {
    super.initState();
    this.waitings = List<Waiting>();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {

    ListTile makeListTile(Waiting waiting) => ListTile(
      contentPadding:
      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
            border: Border(
                right: BorderSide(width: 1.0, color: Colors.white24))),
        child: Text(
          waiting.number.toString(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        waiting.title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              child: Text(msg.entrance, style: TextStyle(fontSize: 16)),
              onPressed: null,
            ),
            SizedBox(width: 10),
            RaisedButton(
              child: Text(msg.cancle, style: TextStyle(fontSize: 16)),
              onPressed: null,
            )
        ]),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
    );

    Card makeCard(Waiting waiting) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(waiting),
      ),
    );

    final makeWatingList = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: waitings == null ? 0 : waitings.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(waitings[index]);
        },
      ),
    );

    final TextStyle titleTextStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 28,
      letterSpacing: 0,
      wordSpacing: 0,
      fontFamily: "DejaVuSansCondensed",
      color: Color(0XFF888888),
      decoration: TextDecoration.none,
    );

    final TextStyle bodyTextStyle = const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 36,
      letterSpacing: 0,
      fontFamily: "DejaVuSansCondensed",
      color: Color(0XFFFFFFFF),
      decoration: TextDecoration.none,
    );

    final makeTotalWatingTeam = Container(
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Align(
                alignment: FractionalOffset.topLeft,
                child: Text(msg.waitingTeam, style: titleTextStyle),
              ),
            ),
            Expanded(
              flex: 7,
              child: Align(
                alignment: FractionalOffset.bottomRight,
                child: Container(
                  margin: new EdgeInsets.symmetric(vertical: 30.0),
                  child: Text(waitings.length.toString() + " " + msg.team, style: bodyTextStyle),
                )
              ),
            ),
          ],
    ));

    final makeTotalWatingTime = Container(
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Align(
                alignment: FractionalOffset.topLeft,
                child: Text(msg.waitingTime, style: titleTextStyle),
              ),
            ),
            Expanded(
              flex: 7,
              child: Align(
                  alignment: FractionalOffset.bottomRight,
                  child: Container(
                    margin: new EdgeInsets.symmetric(vertical: 30.0),
                    child: Text('${waitings.length*waitingTimePerTeam} ${msg.minute}', style: bodyTextStyle),
                  )
              ),
            ),
          ],
        ));

    final makeTotalWaitingInfo = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: makeTotalWatingTeam,
        ),
        Expanded(
          flex: 3,
          child: makeTotalWatingTime,
        ),
        Expanded(
          flex: 3,
          child: Container(),
        ),
      ],
    );

    final makeBody = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: makeWatingList,
          ),
          Expanded(
            flex: 4,
            child: makeTotalWaitingInfo,
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: makeBody,
    );
  }
}
