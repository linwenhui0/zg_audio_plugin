import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:zg_audio_plugin/model/room_message.dart';
import 'package:zg_audio_plugin/model/user.dart';
import 'package:zg_audio_plugin/plugin/zg_audio_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with ILoginCallback, IRoomCallback, IRoomMessageCallback {
  ZgAudioPlugin zgAudioPlugin;
  StringBuffer textBuffer;

  @override
  void initState() {
    super.initState();
    zgAudioPlugin = ZgAudioPlugin();
    zgAudioPlugin.registerLoginCallback(this);
    zgAudioPlugin.registerRoomCallback(this);
    zgAudioPlugin.registerRoomMessageCallback(this);
    textBuffer = new StringBuffer();
  }

  @override
  void dispose() {
    zgAudioPlugin.unRegisterLoginCallback(this);
    zgAudioPlugin.unRegisterRoomCallback(this);
    zgAudioPlugin.unRegisterRoomMessageCallback(this);
    super.dispose();
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
                zgAudioPlugin.login("10", "房间10");
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
              onPressed: () {},
              child: new Text(""),
            ),
            new Text(textBuffer.toString())
          ],
        ),
      ),
    );
  }

  @override
  void onAddUser(User user) {
    this.setState(() {
      textBuffer.write("onAddUser user($user)");
    });
  }

  @override
  void onDisconnect(int errorCode, String roomId) {
    this.setState(() {
      textBuffer.write("onDisconnect errorCode($errorCode) roomId($roomId)");
    });
  }

  @override
  void onKickOut(int errorCode, String roomId) {
    this.setState(() {
      textBuffer.write("onKickOut errorCode($errorCode) roomId($roomId)");
    });
  }

  @override
  void onLoginFailure() {
    this.setState(() {
      textBuffer.write("onLoginFailure");
    });
  }

  @override
  void onLoginSuc() {
    this.setState(() {
      textBuffer.write("onLoginSuc");
    });
  }

  @override
  void onPullerStreamUpdate(
      String userId, String streamId, bool mic, bool speaker, int micLocation) {
    this.setState(() {
      textBuffer.write("onPullerStreamUpdate userId($userId) streamId($streamId) mic($mic) speaker($speaker) micLocation($micLocation)");
    });
  }

  @override
  void onReceiveMessage(String roomId, List<RoomMessage> roomMessages) {
    this.setState(() {
      textBuffer.write("onReceiveMessage");
    });
  }

  @override
  void onRemoveUser(String userId) {
    this.setState(() {
      textBuffer.write("onRemoveUser userId($userId)");
    });
  }

  @override
  void onSendMessageError(int errorCode, String roomId, String sessionId) {
    this.setState(() {
      textBuffer.write("onRemoveUser");
    });
  }

  @override
  void onSendMessageSuc(String roomId, String sessionId) {
    this.setState(() {
      textBuffer.write("onSendMessageSuc roomId($roomId)");
    });
  }

  @override
  void onSoundLevel(String streamId, double soundLevel) {
    this.setState(() {
      textBuffer.write("onSoundLevel streamId($streamId)");
    });
  }

  @override
  void onStreamAdd(User user) {
    this.setState(() {
      textBuffer.write("onStreamAdd user($user)");
    });
  }

  @override
  void onStreamRemove(String userId) {
    this.setState(() {
      textBuffer.write("onStreamRemove userId($userId)");
    });
  }

  @override
  void onStreamUpdate(String userId, bool mic, bool speaker, int micLocation) {
    this.setState(() {
      textBuffer.write("onStreamUpdate userId($userId)");
    });
  }
}
