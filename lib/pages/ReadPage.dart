import 'package:bots_no_tdd/data/User.dart';
import 'package:bots_no_tdd/network/API.dart';
import 'package:bots_no_tdd/network/response/UserResponse.dart';
import 'package:flutter/material.dart';

class ReadPage extends StatefulWidget {
  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {

  List<User> data = [];

  void initState() {
    super.initState();

    API.callGetUsers<List<User>>(
      onSuccess: (list) { setState(() { data = list; }); },
      onError: showError,
      converter: UserResponse.fromList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: data.map((it) => listItem(it)).toList(),
    );
  }

  Widget listItem(User user) => Card(
    child: ListTile(
      title: Text(user.name), 
      subtitle: Text(user.comment, style: TextStyle(color: Colors.grey), maxLines: 3,),
      trailing: Text("${user.updated}"),
    )
  );

  void showError(error) {
    print("Error: $error");
  }


}