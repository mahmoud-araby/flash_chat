import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/component/message_bubble.dart';
import 'package:flashchat/modules/messages.dart';
import 'package:flashchat/modules/user_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ChatScreen extends StatefulWidget {
  static String id = '/chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textEditingController = TextEditingController();
  String text;
  @override
  void initState() {
    userAuth.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.close), onPressed: () {}),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: messageModule.messageStream(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final List<DocumentSnapshot> myMessages =
                        snapshot.data.documents;
                    myMessages.sort((a, b) => b['time'].compareTo(a['time']));
                    print(myMessages.first['time']);
                    return Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: myMessages.length,
                        itemBuilder: (BuildContext context, index) {
                          return MessageBubble(
                            message: myMessages[index]['text'],
                            sender: myMessages[index]['sender'],
                            time: DateTime.fromMicrosecondsSinceEpoch(
                                myMessages[index]['time']
                                    .microsecondsSinceEpoch),
                          );
                        },
                      ),
                    );
                  } else {
                    return Text('No Messages');
                  }
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      onChanged: (value) {
                        text = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageModule.sendMessage(text);
                      _textEditingController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
