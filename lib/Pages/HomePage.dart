import 'package:flutter/material.dart';
import 'package:simple_todo/Pages/PageListing.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      PageListing(setting: "Deadline"),
      PageListing(setting: "No deadline"),
      PageListing(setting: "Done"),
    ];
    final _kTabs = <Tab>[
      Tab(icon: Icon(Icons.shutter_speed), text: 'Deadlines'),
      Tab(icon: Icon(Icons.timer_off), text: 'No deadline'),
      Tab(icon: Icon(Icons.done), text: 'Done'),
    ];

    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            backgroundColor: Colors.blueAccent,
            bottom: TabBar(
              tabs: _kTabs,
            ),
          ),
        ),
        body: TabBarView(
          children: _kTabPages,
        ),
      ),
    );
  }
}
