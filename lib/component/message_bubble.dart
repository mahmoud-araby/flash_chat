import 'package:flashchat/modules/user_auth.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String sender;
  final String message;
  final DateTime time;
  @override
  Widget build(BuildContext context) {
    bool isMe = userAuth.getEmail == sender ? true : false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(fontSize: 8),
          ),
          Material(
            elevation: 7,
            borderRadius: isMe
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topLeft: Radius.circular(30))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30)),
            color: isMe ? Colors.lightBlueAccent : Colors.purpleAccent,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15),
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 23, color: Colors.white),
                  ),
                ),
                Text(
                  time.hour.toString() + ':' + time.minute.toString(),
                  style: TextStyle(fontSize: 8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  MessageBubble({this.sender, this.message, this.time});
}
