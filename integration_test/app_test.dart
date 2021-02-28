import 'package:bots_no_tdd/resources/Strings.dart';
import 'package:bots_no_tdd/utils/UpdatedTime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bots_no_tdd/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final delay = Duration(seconds: 7);

  testWidgets("C-R-U-D", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    String userName = "Dmitry Skvortcov";
    String userComment = "some quote from the book";
    
    //create
    Finder name = find.widgetWithText(TextField, Strings.hint_name);
    Finder comment = find.widgetWithText(TextField, Strings.hint_comment);
    Finder button = find.widgetWithText(RaisedButton, Strings.label_create);
    await tester.enterText(name, userName);
    await tester.enterText(comment, userComment);
    await tester.tap(button);
    await tester.pumpAndSettle(delay);
    await tester.tap(find.text(Strings.close));
    await tester.pumpAndSettle();
    
    //read
    await tester.tap(find.byIcon(Icons.list));
    await tester.pumpAndSettle(delay);
    expect(find.text(userName), findsOneWidget);
    expect(find.text(userComment), findsOneWidget);

    //update
    await tester.longPress(find.text(userName));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(PopupMenuItem, Strings.label_update));
    await tester.pumpAndSettle();
    Finder nameUpdate = find.widgetWithText(TextField, userName);
    Finder commentUpdate = find.widgetWithText(TextField, userComment);
    Finder buttonUpdate = find.widgetWithText(RaisedButton, Strings.label_update);
    userName += " (upd.)";
    userComment += " (upd.)";
    await tester.enterText(nameUpdate, userName);
    await tester.enterText(commentUpdate, userComment);
    await tester.tap(buttonUpdate);
    await tester.pumpAndSettle(delay);
    await tester.tapAt(Offset(100,100));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.list));
    await tester.pumpAndSettle(delay);
    expect(find.text(userName), findsOneWidget);
    expect(find.text(userComment), findsOneWidget);

    //delete
    await tester.longPress(find.text(userName));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(PopupMenuItem, Strings.label_delete));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Strings.label_delete));
    await tester.pumpAndSettle(Duration(seconds: 3));
    expect(find.text(userName), findsNothing);
    expect(find.text(userComment), findsNothing);
  });
}