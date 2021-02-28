import 'package:bots_no_tdd/data/Passenger.dart';
import 'package:bots_no_tdd/network/API.dart';
import 'package:bots_no_tdd/network/Network.dart';
import 'package:bots_no_tdd/network/response/PassengerResponse.dart';
import 'package:flutter/material.dart';

class StreamPage extends StatefulWidget {
  @override
  _StreamPageState createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {

  List<Passenger> data;
  int page = 0;

  bool get isLoading => data == null;

  void initState() {
    super.initState();

    API.callStream(page, 
      onSuccess: update,
      onError: (e) { Network.showError(context, e); },
      converter: PassengerResponse.fromList,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, idx) => item(data[idx])
    );
  }

  Widget item(Passenger p) => Card(child: ListTile(
    leading: Text("[${p.trips}]"),
    title: Text(p.name), 
    trailing: Image.network(p.logo, width: 100, height: 40,),
  ));

  void update(List<Passenger> newPage) {
    setState(() {
      if (data == null) data = [];
      data.addAll(newPage);
    });
  }

}