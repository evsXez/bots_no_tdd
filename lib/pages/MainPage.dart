import 'package:bots_no_tdd/resources/Strings.dart';
import 'package:flutter/material.dart';

import 'CreatePage.dart';
import 'ReadPage.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int currentPageIdx = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(child: page),
        bottomNavigationBar: bottomNavigation,
      ),
    );
  }

  Widget get bottomNavigation => BottomNavigationBar(
    onTap: pageSelected,
    fixedColor: Colors.deepOrange,
    unselectedItemColor: Colors.blue,
    currentIndex: currentPageIdx,
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.add), label: Strings.label_create),
      BottomNavigationBarItem(icon: Icon(Icons.list), label: Strings.label_read),
      BottomNavigationBarItem(icon: Icon(Icons.edit), label: Strings.label_update),
      BottomNavigationBarItem(icon: Icon(Icons.delete), label: Strings.label_delete),
      BottomNavigationBarItem(icon: Icon(Icons.arrow_circle_down), label: Strings.label_stream),
    ]
  );

  void pageSelected(int idx) { setState(() { currentPageIdx = idx; }); }

  Widget get page {
    switch (currentPageIdx) {
      case 0: return CreatePage();
      case 1: return ReadPage();
    }
    return Container(color: Colors.orange,);
  }

  
}

