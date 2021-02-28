import 'package:bots_no_tdd/data/User.dart';
import 'package:bots_no_tdd/network/API.dart';
import 'package:bots_no_tdd/resources/Strings.dart';
import 'package:bots_no_tdd/widgets/Space.dart';
import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {

  final User user;
  final Function updated;

  UpdatePage({this.user, this.updated});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {

  final nameController = TextEditingController();
  final commentController = TextEditingController();

  User user;
  bool get isUserSelected => user != null;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    if (widget.user != null) {
      nameController.text = widget.user.name;
      commentController.text = widget.user.comment;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isUserSelected) return Center(child: Text(Strings.hint_select_user));

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          nameField,
          spacev(16),
          commentField,
          spacev(16),
          updateButton,
        ],
      ),
    );
  }

  Widget get nameField => TextField(controller: nameController, decoration: InputDecoration(hintText: Strings.hint_name),);
  Widget get commentField => TextField(controller: commentController, decoration: InputDecoration(hintText: Strings.hint_comment), maxLines: 3,);
  Widget get updateButton => RaisedButton(onPressed: updatePressed, child: Text(Strings.label_update), color: Colors.blue, textColor: Colors.white,);
   

  void updatePressed() {
    API.callUpdateUser(widget.user.id, nameController.text, commentController.text,
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
    widget.updated();
    setState(() {
      nameController.text = "";
      commentController.text = "";
      user = null;;
      FocusScope.of(context).unfocus();
    });
  }


}