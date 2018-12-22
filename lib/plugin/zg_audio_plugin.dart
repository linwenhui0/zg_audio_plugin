import 'dart:convert' show jsonDecode;

import 'package:flutter/services.dart';
import 'package:zg_audio_plugin/model/room_message.dart';
import 'package:zg_audio_plugin/constants/constants.dart';
import 'package:zg_audio_plugin/model/user.dart';

class ZgAudioPlugin {
  static const MethodChannel _channel = const MethodChannel(Constants.CHANNEL);

  static const EventChannel _loginStatusChannel =
      const EventChannel(Constants.LOGIN_STATUS_CHANNEL); //用户在线渠道
  static const EventChannel _roomMemberChannel =
      const EventChannel(Constants.ROOM_MEMBER_CHANNEL); //房间内成员变动渠道
  static const EventChannel _roomMessageChannel =
      const EventChannel(Constants.ROOM_MESSAGE_CHANNEL); //房间内消息渠道

  static ZgAudioPlugin _instance = ZgAudioPlugin._internal();

  factory ZgAudioPlugin() {
    return _instance;
  }

  ZgAudioPlugin._internal();

  initSDK(String userId, String userName) async {
    _loginStatusChannel.receiveBroadcastStream().listen(_loginStatusEvent);
    _roomMemberChannel.receiveBroadcastStream().listen(_roomMemberEvent);
    _roomMessageChannel.receiveBroadcastStream().listen(_roomMessageEvent);
    return await _channel.invokeMethod(Constants.INIT_SDK,
        {Constants.USER_ID: userId, Constants.USER_NAME: userName});
  }

  //用户登录状态
  _loginStatusEvent(Object event) {
    print("_loginStatusEvent event($event)");
    var jsonResult = jsonDecode(event);
    String methodName = jsonResult[Constants.METHOD_NAME];
    switch (methodName) {
      case Constants.LOGIN_SUC:
        if (_loginCallbacks != null) {
          _loginCallbacks
              .forEach((_loginCallback) => _loginCallback.onLoginSuc());
        }
        break;
      case Constants.LOGIN_FAILURE:
        if (_loginCallbacks != null) {
          _loginCallbacks
              .forEach((_loginCallback) => _loginCallback.onLoginFailure());
        }
        break;
    }
  }

  //房间内成员
  _roomMemberEvent(Object event) {
    var jsonResult = jsonDecode(event);
    String methodName = jsonResult[Constants.METHOD_NAME];
    switch (methodName) {
      case Constants.ROOM_SOUND_LEVEL:
        if (_roomCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          String streamId = resultData[Constants.STREAM_ID];
          int soundLevel = resultData[Constants.SOUND_LEVEL];
          _roomCallbacks.forEach((_roomCallback) =>
              _roomCallback.onSoundLevel(streamId, soundLevel));
        }
        break;
      case Constants.ROOM_PULLER_STREAM_UPDATE:
        if (_roomCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          String userId = resultData[Constants.USER_ID];
          String streamId = resultData[Constants.STREAM_ID];
          bool mic = resultData[Constants.ENABLE_MIC];
          bool spreak = resultData[Constants.ENABLE_SPEAKER];
          int micLocation = resultData[Constants.MIC_LOCATION];
          _roomCallbacks.forEach((_roomCallback) =>
              _roomCallback.onPullerStreamUpdate(
                  userId, streamId, mic, spreak, micLocation));
        }
        break;
      case Constants.ROOM_STREAM_UPDATE:
        if (_roomCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          String userId = resultData[Constants.USER_ID];
          bool mic = resultData[Constants.ENABLE_MIC];
          bool speak = resultData[Constants.ENABLE_SPEAKER];
          int micLocation = resultData[Constants.MIC_LOCATION];
          _roomCallbacks.forEach((_roomCallback) =>
              _roomCallback.onStreamUpdate(userId, mic, speak, micLocation));
        }
        break;
      case Constants.ROOM_STREAM_ADD:
        if (_roomCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          User user = User(
              userId: resultData[Constants.USER_ID],
              userName: resultData[Constants.USER_NAME],
              mic: resultData[Constants.ENABLE_MIC],
              streamId: resultData[Constants.STREAM_ID],
              speaker: resultData[Constants.ENABLE_SPEAKER],
              micLocation: resultData[Constants.MIC_LOCATION]);
          _roomCallbacks
              .forEach((_roomCallback) => _roomCallback.onStreamAdd(user));
        }
        break;
      case Constants.ROOM_STREAM_REMOVE:
        if (_roomCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          String userId = resultData[Constants.USER_ID];
          _roomCallbacks
              .forEach((_roomCallback) => _roomCallback.onStreamRemove(userId));
        }
        break;
      case Constants.ROOM_ADD_USER:
        if (_roomCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          User user = User(
              userId: resultData[Constants.USER_ID],
              userName: resultData[Constants.USER_NAME],
              mic: resultData[Constants.ENABLE_MIC],
              streamId: resultData[Constants.STREAM_ID],
              speaker: resultData[Constants.ENABLE_SPEAKER],
              micLocation: resultData[Constants.MIC_LOCATION]);
          _roomCallbacks
              .forEach((_roomCallback) => _roomCallback.onAddUser(user));
        }
        break;
      case Constants.ROOM_REMOVE_USER:
        if (_roomCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          String userId = resultData[Constants.USER_ID];
          _roomCallbacks
              .forEach((_roomCallback) => _roomCallback.onRemoveUser(userId));
        }
        break;
      case Constants.ROOM_DISCONNECT:
        if (_roomCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          int errorCode = resultData[Constants.ERROR_CODE];
          String roomId = resultData[Constants.ROOM_ID];
          _roomCallbacks.forEach(
              (_roomCallback) => _roomCallback.onDisconnect(errorCode, roomId));
        }
        break;
      case Constants.ROOM_KICK_OUT:
        if (_roomCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          int errorCode = resultData[Constants.ERROR_CODE];
          String roomId = resultData[Constants.ROOM_ID];
          _roomCallbacks.forEach(
              (_roomCallback) => _roomCallback.onKickOut(errorCode, roomId));
        }
        break;
    }
  }

  // 房间内消息
  _roomMessageEvent(Object event) {
    var jsonResult = jsonDecode(event);
    String methodName = jsonResult[Constants.METHOD_NAME];
    switch (methodName) {
      case Constants.ROOM_SEND_MESSAGE_ERROR:
        if (_roomMessageCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          int errorCode = resultData[Constants.ERROR_CODE];
          String roomId = resultData[Constants.ROOM_ID];
          String sessionId = resultData[Constants.SESSION_ID];
          _roomMessageCallbacks.forEach((_roomMessageCallback) =>
              _roomMessageCallback.onSendMessageError(
                  errorCode, roomId, sessionId));
        }
        break;
      case Constants.ROOM_RECEIVE_MESSAGE:
        if (_roomMessageCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          var roomId = resultData[Constants.ROOM_ID];
          List messageData = jsonResult[Constants.MESSAGES];
          List<RoomMessage> roomMessages = List();
          messageData.forEach((item) {
            roomMessages.add(RoomMessage(
                fromUserID: item[Constants.FROM_USER_ID],
                fromUserName: item[Constants.FROM_USER_NAME],
                messageID: item[Constants.MESSAGE_ID],
                content: item[Constants.MESSAGE_CONTENT],
                messageType: item[Constants.MESSAGE_TYPE],
                messageCategory: item[Constants.MESSAGE_CATEGORY],
                messagePriority: item[Constants.MESSAGE_PRIORITY]));
          });
          _roomMessageCallbacks.forEach((_roomMessageCallback) =>
              _roomMessageCallback.onReceiveMessage(roomId, roomMessages));
        }
        break;
      case Constants.ROOM_SEND_MESSAGE_SUC:
        if (_roomMessageCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          String roomId = resultData[Constants.ROOM_ID];
          String sessionId = resultData[Constants.SESSION_ID];
          _roomMessageCallbacks.forEach((_roomMessageCallback) =>
              _roomMessageCallback.onSendMessageSuc(roomId, sessionId));
        }
        break;
    }
  }

  List<ILoginCallback> _loginCallbacks = List();
  List<IRoomCallback> _roomCallbacks = List();
  List<IRoomMessageCallback> _roomMessageCallbacks = List();

  Future<void> registerLoginCallback(ILoginCallback loginCallback) async {
    if (loginCallback != null && !_loginCallbacks.contains(loginCallback)) {
      _loginCallbacks.add(loginCallback);
    }
  }

  Future<void> unRegisterLoginCallback(ILoginCallback loginCallback) async {
    if (loginCallback != null && _loginCallbacks.contains(loginCallback)) {
      _loginCallbacks.remove(loginCallback);
    }
  }

  Future<void> registerRoomCallback(IRoomCallback roomCallback) async {
    if (roomCallback != null && !_roomCallbacks.contains(roomCallback)) {
      _roomCallbacks.add(roomCallback);
    }
  }

  Future<void> unRegisterRoomCallback(IRoomCallback roomCallback) async {
    if (roomCallback != null && _roomCallbacks.contains(roomCallback)) {
      _roomCallbacks.remove(roomCallback);
    }
  }

  Future<void> registerRoomMessageCallback(
      IRoomMessageCallback roomMessageCallback) async {
    if (roomMessageCallback != null &&
        !_roomMessageCallbacks.contains(roomMessageCallback)) {
      _roomMessageCallbacks.add(roomMessageCallback);
    }
  }

  Future<void> unRegisterRoomMessageCallback(
      IRoomMessageCallback roomMessageCallback) async {
    if (roomMessageCallback != null &&
        _roomMessageCallbacks.contains(roomMessageCallback)) {
      _roomMessageCallbacks.remove(roomMessageCallback);
    }
  }

  login(String roomId, String roomName) async {
    return await _channel.invokeMethod(Constants.LOGIN,
        {Constants.ROOM_ID: roomId, Constants.ROOM_NAME: roomName});
  }

  logout() async {
    return await _channel.invokeMethod(Constants.LOGOUT);
  }

  sendMessage(int messageType, int messageCategory, String content) async {
    return await _channel.invokeMethod(Constants.SEND_MESSAGE, {
      Constants.MESSAGE_TYPE: messageType,
      Constants.MESSAGE_CATEGORY: messageCategory,
      Constants.MESSAGE_CONTENT: content
    });
  }

  openSpeaker(bool enable) async {
    return await _channel
        .invokeMethod(Constants.OPEN_SPEAKER, {Constants.OPEN_SPEAKER: enable});
  }

  openMic(bool enable) async {
    return await _channel
        .invokeMethod(Constants.OPEN_MIC, {Constants.OPEN_MIC: enable});
  }

  initRoomListener() async {
    await _channel.invokeMethod(Constants.INIT_ROOM_LISTENER);
  }

  destroyRoomListener() async{
    await _channel.invokeMethod(Constants.DESTROY_ROOM_LISTENER);
  }


}

abstract class ILoginCallback {

  void onLoginSuc();

  void onLoginFailure();
}

abstract class IRoomCallback {
  void onSoundLevel(String streamId, int soundLevel);

  void onPullerStreamUpdate(
      String userId, String streamId, bool mic, bool speaker, int micLocation);

  void onStreamUpdate(String userId, bool mic, bool speaker, int micLocation);

  void onStreamAdd(User user);

  void onStreamRemove(String userId);

  void onAddUser(User user);

  void onRemoveUser(String userId);

  void onDisconnect(int errorCode, String roomId);

  void onKickOut(int errorCode, String roomId);
}

abstract class IRoomMessageCallback {
  void onSendMessageError(int errorCode, String roomId, String sessionId);

  void onSendMessageSuc(String roomId, String sessionId);

  void onReceiveMessage(String roomId, List<RoomMessage> roomMessages);
}
