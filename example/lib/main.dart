import 'package:flutter/material.dart';
import 'package:zg_audio_plugin/model/room_message.dart';
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
    zgAudioPlugin.initRoomListener();
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
                zgAudioPlugin.login("4", "4");
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
                zgAudioPlugin.setHouseOwner(true);
              },
              child: new Text("设置为房主"),
            ),
            new Text(textBuffer.toString())
          ],
        ),
      ),
    );
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
  void onReceiveMessage(String roomId, List<RoomMessage> roomMessages) {
    this.setState(() {
      textBuffer.write("onReceiveMessage $roomMessages\n");
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

}
