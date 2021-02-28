import 'dart:async';

import 'package:bots_no_tdd/data/Passenger.dart';
import 'package:bots_no_tdd/network/API.dart';
import 'package:bots_no_tdd/network/Network.dart';
import 'package:bots_no_tdd/network/response/PassengerResponse.dart';
import 'package:bots_no_tdd/network/response/PassengersPage.dart';
import 'package:bots_no_tdd/resources/Strings.dart';
import 'package:flutter/material.dart';

class StreamPage extends StatefulWidget {
  @override
  _StreamPageState createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {

  List<Passenger> data = [];
  int page = -1;
  int totalPages = 0;
  int totalPassengers = 0;

  final stream = StreamController<PassengersPage>();
  final List<StreamSubscription> obs = [];

  bool get isLoading => data == null;

  void initState() {
    super.initState();
    obs.add(stream.stream.listen(update));
  }

  void dispose() {
    obs.forEach((it) { it.cancel(); });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [list, info,],
    );
  }

  Widget get list => ListView.builder(
      itemCount: data.length+1,
      itemBuilder: (context, idx) => itemForIdx(idx)
    );
  
  Widget get info => Container(
    height: 100,
    width: 200,
    decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.black), color: Colors.lightBlue.withAlpha(128)),
    child: Center(child: Text("Page: $page/$totalPages\n" +
      "Shown: 1-${data.length}\n" +
      "Total: $totalPassengers"),),
  );



  void update(PassengersPage pageData) {
    setState(() {
      if (data == null) data = [];
      page = pageData.page;
      totalPages = pageData.totalPages;
      totalPassengers = pageData.totalPassengers;
      data.addAll(pageData.list);
    });
  }

  Widget itemForIdx(int idx) {
    if (idx < data.length) return item(idx, data[idx]);
    return nextPageDownloader();
  }

  Widget item(int idx, Passenger p) => Card(child: ListTile(
    leading: Column(
      children: [
        Text("#${idx+1}"),
        Text("[${p.trips}]"),
      ],
    ),
    title: Text(p.name), 
    trailing: Image.network(p.logo, width: 100, height: 40,),
  ));

  Widget nextPageDownloader() {
    if (page < totalPages) {
      loadOneMorePage();
      return Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()));
    }
    return Center(child: Text(Strings.end_of_list));
  }

  void loadOneMorePage() {
    final nextPage = page+1;
    API.callStream(nextPage,
      onSuccess: (pageData) { 
        pageData.page = nextPage;
        stream.add(pageData);
      },
      onError: (e) { Network.showError(context, e); },
      converter: PassengersPage.fromJson,
    );
  }

}