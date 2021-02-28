import 'package:bots_no_tdd/data/User.dart';
import 'package:bots_no_tdd/resources/Strings.dart';
import 'package:flutter/material.dart';

import 'CreatePage.dart';
import 'ReadPage.dart';
import 'StreamPage.dart';
import 'UpdatePage.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {

  static const int PAGE_CREATE = 0;
  static const int PAGE_READ = 1;
  static const int PAGE_UPDATE = 2;
  static const int PAGE_STREAM = 3;

  int currentPageIdx = 0;
  User userToUpdate;

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
      BottomNavigationBarItem(icon: Icon(Icons.arrow_circle_down), label: Strings.label_stream),
    ]
  );

  void pageSelected(int idx) { setState(() { currentPageIdx = idx; }); }

  Widget get page {
    switch (currentPageIdx) {
      case PAGE_CREATE: return CreatePage();
      case PAGE_READ: return ReadPage(onUserUpdateRequest);
      case PAGE_UPDATE: return UpdatePage(user: userToUpdate, updated: resetUser);
      case PAGE_STREAM: return StreamPage();
    }
    return Container(color: Colors.orange,);
  }

  void onUserUpdateRequest(User user) {
    setState(() { 
      userToUpdate = user;
      currentPageIdx = PAGE_UPDATE; 
    });
  }

  void resetUser() { setState(() { userToUpdate = null; }); }

  
}

