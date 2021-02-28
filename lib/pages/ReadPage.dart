import 'package:bots_no_tdd/data/User.dart';
import 'package:bots_no_tdd/network/API.dart';
import 'package:bots_no_tdd/network/response/UserResponse.dart';
import 'package:bots_no_tdd/resources/Strings.dart';
import 'package:flutter/material.dart';

class ReadPage extends StatefulWidget {

  final Function(User) updateRequest;

  ReadPage(this.updateRequest);

  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {

  List<User> data;

  bool get isLoading => data == null;

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
    if (isLoading) return Center(child: CircularProgressIndicator());
    return ListView(
      children: data.map((it) => listItem(it)).toList(),
    );
  }

  Widget listItem(User user) => Card(
    child: GestureDetector(
      onLongPressStart: (details) { showContextMenu(user, details); },
      child: ListTile(
        onTap: showHint,
        title: Text(user.name), 
        subtitle: Text(user.comment, style: TextStyle(color: Colors.grey), maxLines: 3,),
        trailing: Text("${user.updated}"),
      ),
    )
  );

  void showError(error) {
    print("Error: $error");
  }

  void showHint() {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(Strings.hint_press_long_for_menu), duration: Duration(milliseconds: 250),));
  }

  void showContextMenu(User user, LongPressStartDetails details) {
    // if (true) {
    //   widget.updateRequest(user);
    //   return;
    // }

    final x = details.globalPosition.dx;
    final y = details.globalPosition.dy;

    const OPTION_UPDATE = "update";
    const OPTION_DELETE = "delete";

    final List<PopupMenuEntry> items = [
        PopupMenuItem(child: Text(Strings.label_update), value: OPTION_UPDATE,),
        PopupMenuItem(child: Text(Strings.label_delete), value: OPTION_DELETE,),
    ];
    showMenu(context: context, 
              captureInheritedThemes: false,
              position: RelativeRect.fromLTRB(x,y,x,y), 
              items: items)
      .then((value) { 
        switch (value) {
          case OPTION_UPDATE: { actionUpdate(user); break; }
          case OPTION_DELETE: { actionDelete(user); break; }
        }
      });

  }

  void actionUpdate(User user) {
    widget.updateRequest(user);
  }

  void actionDelete(User user) {

  }


}