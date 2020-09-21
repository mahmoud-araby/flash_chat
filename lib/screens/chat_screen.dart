import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/component/message_bubble.dart';
import 'package:flashchat/modules/messages.dart';
import 'package:flashchat/modules/user_auth.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import '../constants.dart';

class ChatScreen extends StatefulWidget {
  static String id = '/chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textEditingController = TextEditingController();

  /*channel name*/
  final String channelName = 'mahmoudaraby36@gmail.com';
  ClientRole role;

  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  /*end of agorora*/

  String text;
  @override
  void initState() {
    userAuth.getUser();
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _users.clear();
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  Future<void> initialize() async {
    await Future.delayed(Duration(seconds: 3));
    print(userAuth.loggedUser.email);
    if (userAuth.loggedUser.email == channelName) {
      role = ClientRole.Broadcaster;
    } else {
      role = ClientRole.Audience;
    }
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = Size(1920, 1080);
    await AgoraRtcEngine.setVideoEncoderConfiguration(configuration);
    await AgoraRtcEngine.joinChannel(null, channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableAudio();
    await AgoraRtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await AgoraRtcEngine.setClientRole(role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
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
