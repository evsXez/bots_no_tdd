import 'package:bots_no_tdd/network/API.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          nameField,
          spacev(16),
          commentField,
          spacev(16),
          createButton,
        ],
      ),
    );
  }

  Widget get nameField => TextField(controller: nameController, decoration: InputDecoration(hintText: Strings.hint_name),);
  Widget get commentField => TextField(controller: commentController, decoration: InputDecoration(hintText: Strings.hint_comment), maxLines: 3,);
  Widget get createButton => RaisedButton(onPressed: createPressed, child: Text(Strings.label_create), color: Colors.blue, textColor: Colors.white,);
   

  void createPressed() {
    API.callAddUser(nameController.text, commentController.text,
      onSuccess: showMessage,
      onError: showError,
    );
  }

  void showMessage(data) {
    print("Message: $data");
    clearFields();
  }
  void showError(error) {
    print("Error: $error");
  }
  void clearFields() {
    setState(() {
      nameController.text = "";
      commentController.text = "";
      FocusScope.of(context).unfocus();
    });
  }


}