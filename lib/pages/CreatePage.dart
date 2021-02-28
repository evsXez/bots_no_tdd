import 'package:bots_no_tdd/network/API.dart';
import 'package:bots_no_tdd/network/Network.dart';
import 'package:bots_no_tdd/network/response/HelloResponse.dart';
import 'package:bots_no_tdd/resources/Strings.dart';
import 'package:bots_no_tdd/widgets/Space.dart';
import 'package:flutter/material.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {

  final nameController = TextEditingController();
  final commentController = TextEditingController();

  String hello = "";

  void initState() {
    super.initState();
    if (Strings.hello != null) {
      hello = Strings.hello;
    } else {
      API.callHello(
        onSuccess: (s) { setHello(s); },
        onError: (e) { Network.showError(context, e); },
        converter: HelloResponse.fromJson,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          greetingLabel,
          spacev(8),
          nameField,
          spacev(16),
          commentField,
          spacev(16),
          createButton,
        ],
      ),
    );
  }

  Widget get greetingLabel => Center(child: Text(hello, style: TextStyle(color: Colors.deepOrange, fontSize: 18)));
  Widget get nameField => TextField(controller: nameController, decoration: InputDecoration(hintText: Strings.hint_name),);
  Widget get commentField => TextField(controller: commentController, decoration: InputDecoration(hintText: Strings.hint_comment), maxLines: 3,);
  Widget get createButton => RaisedButton(onPressed: createPressed, child: Text(Strings.label_create), color: Colors.blue, textColor: Colors.white,);
   

  void createPressed() {
    String name = nameController.text;
    if (name.isEmpty) name = Strings.anonym;
    API.callAddUser(name, commentController.text,
      onSuccess: showMessage,
      onError: (e) { Network.showError(context, e); },
    );
  }

  void showMessage(data) {
    showDialog(context: context, child: AlertDialog(
      content: Text(data),
      actions: [FlatButton(onPressed: () { Navigator.of(context).pop(); }, child: Text(Strings.close))],
    ));
    clearFields();
  }
  void clearFields() {
    setState(() {
      nameController.text = "";
      commentController.text = "";
      FocusScope.of(context).unfocus();
    });
  }

  void setHello(String s) {
    Strings.hello = s;
    setState(() { hello = s; });
  }

}