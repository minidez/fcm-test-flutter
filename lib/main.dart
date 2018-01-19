import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

const String webApiKey = ""; // TODO: YOUR WEB API KEY HERE
HttpClient httpClient = new HttpClient();

void main() {
  runApp(new MaterialApp(
      home: new FcmTest()
  ));
}

class FcmTest extends StatefulWidget {
  @override
  FcmTestState createState() => new FcmTestState();
}

class FcmTestState extends State<FcmTest> {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  String _text = "FCM Test";
  String _fcmToken;
  final TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");
        _receiveMessage(message.remove("message"));
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
      },
    );

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print('FCM Token: $token');
      _fcmToken = token;
      setState(() {
        _text = 'FCM token: $token';
      });
    });
  }

  void _receiveMessage(String message) {
    print('received message: $message');
    setState(() {
      _text = _text + "\n\nMessage received: $message";
    });
  }

  Future<String> _sendMessage() async {
    final String _messageText = controller.text;
    setState(() {
      _text = _text + "\n\nSending Message: " + _messageText;
    });

    final Map<String, String> message = {'message': _messageText};
    final Map<String, Object> jsonMap = {
      'to': _fcmToken,
      'data': message
    };
    final String jsonString = JSON.encode(jsonMap);

    final http.Response response = await http.post(
        Uri.encodeFull("http://fcm.googleapis.com/fcm/send"),
        headers: {
          "Authorization": "key=$webApiKey",
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonString
    );
    controller.text = "";

    print('Response: ' + response.body);
    return response.body.toString();
  }

  @override
  Widget build(BuildContext context) =>
      new Scaffold(
          appBar: new AppBar(
            title: new Text("FCM Test"),
          ),
          body: new Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Flexible(
                      child: new SingleChildScrollView(
                          reverse: true,
                          child: new Text(_text)
                      )
                  ),
                  new Row(
                      children: <Widget>[
                        new Flexible(
                          child: new TextField(
                              decoration: new InputDecoration(
                                  hintText: "Enter message here"
                              ),
                              controller: controller,
                              onSubmitted: (String str) {
                                _sendMessage();
                              }
                          ),
                        ),
                        new IconButton(
                          icon: new Icon(Icons.send),
                          onPressed: _sendMessage,
                          tooltip: 'Send message',),
                      ]
                  ),
                ],
              )
          )
      );
}
