import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:zg_audio_plugin/room_message.dart';
import 'package:zg_audio_plugin/zg_audio_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with ILoginCallback,IRoomCallback {
  ZgAudioPlugin zgAudioPlugin;
  StringBuffer textBuffer;

  @override
  void initState() {
    super.initState();
    zgAudioPlugin = ZgAudioPlugin();
    zgAudioPlugin.roomCallback = this;
    textBuffer = new StringBuffer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                zgAudioPlugin.initSDK("1001", "用户1001");
              },
              child: new Text("初始化版本"),
            ),
            RaisedButton(
              onPressed: () {
                zgAudioPlugin.login("10", "房间10", this);
              },
              child: new Text("登录"),
            ),
            RaisedButton(
              onPressed: () {
                zgAudioPlugin.logout();
              },
              child: new Text("注销"),
            ),
            RaisedButton(
              onPressed: () {

              },
              child: new Text("登录房间"),
            ),
            RaisedButton(
              onPressed: () {
              },
              child: new Text(""),
            ),
            new Text(textBuffer.toString())
          ],
        ),
      ),
    );
  }

  @override
  onAddUser(String userId, String userName, bool enableMic) {
    textBuffer.write(
        "onAddUser userId($userId) userName($userName) enableMic($enableMic)\n");
    this.setState((){});
  }

  @override
  onDisconnect() {
    textBuffer.write("onDisconnect\n");
    this.setState((){});
  }

  @override
  onLoginFailure() {
    textBuffer.write("onLoginFailure\n");
    this.setState((){});
  }

  @override
  onLoginSuc() {
    textBuffer.write("onLoginSuc\n");
    this.setState((){});
  }

  @override
  onRemoveUser(String userId) {
    textBuffer.write("onRemoveUser userId($userId)\n");
    this.setState((){});
  }

  @override
  onUpdateUser(String userId, bool enableMic) {
    textBuffer.write("onUpdateUser userId($userId) enableMic($enableMic)");
    this.setState((){});
  }

  @override
  void onRecvMessage(List<RoomMessage> roomMessages) {
    textBuffer.write("onRecvMessage len(${roomMessages.length}) ");
    this.setState((){});
  }

  @override
  void onSendMessageError(int errorCode, String roomId, String sessionId) {
    textBuffer.write("onSendMessageError errorCode($errorCode) roomId($roomId) sessionId($sessionId)");
    this.setState((){});
  }

  @override
  void onSendMessageSuc(String roomId, String sessionId) {
    textBuffer.write("onSendMessageSuc roomId($roomId) sessionId($sessionId)");
    this.setState((){});
  }
}
