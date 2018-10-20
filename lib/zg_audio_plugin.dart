import 'dart:convert' show jsonDecode;

import 'package:flutter/services.dart';
import 'package:zg_audio_plugin/room_message.dart';

class ZgAudioPlugin {
  static const MethodChannel _channel = const MethodChannel('zg_audio_plugin');
  static const EventChannel _eventChannel =
      const EventChannel("audioRoomStatus");
  static const EventChannel _roomEventChannel =
      const EventChannel("roomMessage");

  static ZgAudioPlugin _instance = ZgAudioPlugin._internal();

  factory ZgAudioPlugin() {
    return _instance;
  }

  ZgAudioPlugin._internal();

  initSDK(String userId, String userName) async {
    _eventChannel.receiveBroadcastStream().listen(_audioRoomStatusEvent);
    _roomEventChannel.receiveBroadcastStream().listen(_roomMessageEvent);
    return await _channel
        .invokeMethod("initSDK", {"userId": userId, "userName": userName});
  }

  _audioRoomStatusEvent(Object event) {
    var jsonResult = jsonDecode(event);
    String methodName = jsonResult["methodName"];
    print(methodName);
    switch (methodName) {
      case "onLoginSuc":
        if (_loginCallback != null) {
          _loginCallback.onLoginSuc();
        }
        break;
      case "onLoginFailure":
        if (_loginCallback != null) {
          _loginCallback.onLoginFailure();
        }
        break;
      case "onAddUser":
        if (roomCallback != null) {
          var resultData = jsonResult["resultData"];
          roomCallback.onAddUser(resultData["userId"], resultData["userName"],
              resultData["enableMic"]);
        }
        break;
      case "onRemoveUser":
        if (roomCallback != null) {
          var resultData = jsonResult["resultData"];
          roomCallback.onRemoveUser(resultData["userId"]);
        }
        break;
      case "onDisconnect":
        if (_loginCallback != null) {
          _loginCallback.onDisconnect();
        }
        break;
      case "onUpdateUser":
        if (roomCallback != null) {
          var resultData = jsonResult["resultData"];
          String userId = resultData["userId"];
          bool enableMic = resultData["enableMic"];
          roomCallback.onUpdateUser(userId, enableMic);
        }
        break;
    }
  }

  _roomMessageEvent(Object event) {
    var jsonResult = jsonDecode(event);
    String methodName = jsonResult["methodName"];
    print(methodName);
    switch (methodName) {
      case "onSendMessageSuc":
        if (roomCallback != null) {
          var resultData = jsonResult["resultData"];
          roomCallback.onSendMessageSuc(
              resultData["roomId"], resultData["sessionId"]);
        }
        break;
      case "onSendMessageError":
        if (roomCallback != null) {
          var resultData = jsonResult["resultData"];
          roomCallback.onSendMessageError(resultData["errorCode"],
              resultData["roomId"], resultData["sessionId"]);
        }
        break;
      case "onRecvMessage":
        if (roomCallback != null) {
          List resultData = jsonResult["resultData"];
          List<RoomMessage> roomMessages = List();
          resultData.forEach((item) {
            roomMessages.add(RoomMessage(
                fromUserID: item["fromUserID"],
                fromUserName: item["fromUserName"],
                messageID: item["messageID"],
                content: item["content"],
                messageType: item["messageType"],
                messageCategory: item["messageCategory"],
                messagePriority: item["messagePriority"]));
          });
          roomCallback.onRecvMessage(roomMessages);
        }
        break;
    }
  }

  ILoginCallback _loginCallback;
  IRoomCallback roomCallback;

  login(String roomId, String roomName, ILoginCallback loginCallback) async {
    _loginCallback = loginCallback;
    return await _channel
        .invokeMethod("login", {"roomId": roomId, "roomName": roomName});
  }

  logout() async {
    return await _channel.invokeMethod("logout");
  }

  sendMessage(int messageType, int messageCategory, String content) async {
    return await _channel.invokeMethod("sendMessage", {
      "messageType": messageType,
      "messageCategory": messageCategory,
      "content": content
    });
  }

  openSpeaker(bool enable) async {
    return await _channel.invokeMethod("openSpeaker", {"openSpeaker": enable});
  }

  openMic(bool enable) async {
    return await _channel.invokeMethod("openMic", {"openMic": enable});
  }
}

abstract class ILoginCallback {
  onDisconnect();

  onLoginSuc();

  onLoginFailure();
}

abstract class IRoomCallback {
  onSendMessageError(int errorCode, String roomId, String sessionId);

  onSendMessageSuc(String roomId, String sessionId);

  onRecvMessage(List<RoomMessage> roomMessages);

  onAddUser(String userId, String userName, bool enableMic);

  onRemoveUser(String userId);

  onUpdateUser(String userId, bool enableMic);
}
