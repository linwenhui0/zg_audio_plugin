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
      case Constants.ROOM_UNLOCK_MIC:
        if (_roomUserCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          int position = resultData[Constants.POSITION];
          _roomStreamCallbacks.forEach((_roomStreamCallback) =>
              _roomStreamCallback.onUnLockMicPosition(position));
        }
        break;
      case Constants.ROOM_LOCK_MIC:
        if (_roomUserCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          int position = resultData[Constants.POSITION];
          _roomStreamCallbacks.forEach((_roomStreamCallback) =>
              _roomStreamCallback.onLockMicPosition(position));
        }
        break;
      case Constants.ROOM_UNLOCK_POSITION:
        if (_roomUserCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          int position = resultData[Constants.POSITION];
          _roomStreamCallbacks.forEach((_roomStreamCallback) =>
              _roomStreamCallback.onUnLockPosition(position));
        }
        break;
      case Constants.ROOM_LOCK_POSITION:
        if (_roomUserCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          int position = resultData[Constants.POSITION];
          _roomStreamCallbacks.forEach((_roomStreamCallback) =>
              _roomStreamCallback.onLockPosition(position));
        }
        break;
      case Constants.ROOM_SOUND_LEVEL:
        if (_roomCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          String streamId = resultData[Constants.STREAM_ID];
          int soundLevel = resultData[Constants.SOUND_LEVEL];
          _roomStreamCallbacks.forEach((_roomStreamCallback) =>
              _roomStreamCallback.onSoundLevel(streamId, soundLevel));
        }
        break;
      case Constants.ROOM_PULLER_STREAM_UPDATE:
        if (_roomCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          String userId = resultData[Constants.USER_ID];
          String streamId = resultData[Constants.STREAM_ID];
          bool mic = resultData[Constants.ENABLE_MIC];
          bool speaker = resultData[Constants.ENABLE_SPEAKER];
          int micLocation = resultData[Constants.MIC_LOCATION];
          _roomStreamCallbacks.forEach((_roomStreamCallback) =>
              _roomStreamCallback.onPullerStreamUpdate(
                  userId, streamId, mic, speaker, micLocation));
        }
        break;
      case Constants.ROOM_STREAM_UPDATE:
        if (_roomCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          String userId = resultData[Constants.USER_ID];
          bool mic = resultData[Constants.ENABLE_MIC];
          bool speaker = resultData[Constants.ENABLE_SPEAKER];
          int micLocation = resultData[Constants.MIC_LOCATION];
          _roomStreamCallbacks.forEach((_roomStreamCallback) =>
              _roomStreamCallback.onStreamUpdate(
                  userId, mic, speaker, micLocation));
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
          _roomStreamCallbacks.forEach(
              (_roomStreamCallback) => _roomStreamCallback.onStreamAdd(user));
        }
        break;
      case Constants.ROOM_STREAM_REMOVE:
        if (_roomCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          String userId = resultData[Constants.USER_ID];
          _roomStreamCallbacks.forEach((_roomStreamCallback) =>
              _roomStreamCallback.onStreamRemove(userId));
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
          _roomUserCallbacks.forEach(
              (_roomUserCallback) => _roomUserCallback.onAddUser(user));
        }
        break;
      case Constants.ROOM_REMOVE_USER:
        if (_roomCallbacks != null) {
          var resultData = jsonResult[Constants.RESULT_DATA];
          String userId = resultData[Constants.USER_ID];
          _roomUserCallbacks.forEach(
              (_roomUserCallback) => _roomUserCallback.onRemoveUser(userId));
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
  List<IRoomUserCallback> _roomUserCallbacks = List();
  List<IRoomStreamCallback> _roomStreamCallbacks = List();
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

  Future<void> registerRoomUserCallback(IRoomUserCallback userCallback) async {
    if (userCallback != null && !_roomUserCallbacks.contains(userCallback)) {
      _roomUserCallbacks.add(userCallback);
    }
  }

  Future<void> unRegisterRoomUserCallback(
      IRoomUserCallback userCallback) async {
    if (userCallback != null && _roomUserCallbacks.contains(userCallback)) {
      _roomUserCallbacks.remove(userCallback);
    }
  }

  Future<void> registerRoomStreamCallback(
      IRoomStreamCallback roomStreamCallback) async {
    if (roomStreamCallback != null &&
        !_roomStreamCallbacks.contains(roomStreamCallback)) {
      _roomStreamCallbacks.add(roomStreamCallback);
    }
  }

  Future<void> unRegisterRoomStreamCallback(
      IRoomStreamCallback roomStreamCallback) async {
    if (roomStreamCallback != null &&
        _roomStreamCallbacks.contains(roomStreamCallback)) {
      _roomStreamCallbacks.remove(roomStreamCallback);
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
    await _channel.invokeMethod(Constants.LOGIN,
        {Constants.ROOM_ID: roomId, Constants.ROOM_NAME: roomName});
  }

  Future<bool> logout() async {
    return await _channel.invokeMethod(Constants.LOGOUT);
  }

  Future<bool> sendMessage(
      int messageType, int messageCategory, String content) async {
    return await _channel.invokeMethod(Constants.SEND_MESSAGE, {
      Constants.MESSAGE_TYPE: messageType,
      Constants.MESSAGE_CATEGORY: messageCategory,
      Constants.MESSAGE_CONTENT: content
    });
  }

  openSpeaker(bool enable) async {
    await _channel
        .invokeMethod(Constants.OPEN_SPEAKER, {Constants.OPEN_SPEAKER: enable});
  }

  openMic(bool enable) async {
    await _channel
        .invokeMethod(Constants.OPEN_MIC, {Constants.OPEN_MIC: enable});
  }

  initRoomListener() async {
    await _channel.invokeMethod(Constants.INIT_ROOM_LISTENER);
  }

  destroyRoomListener() async {
    await _channel.invokeMethod(Constants.DESTROY_ROOM_LISTENER);
  }

  Future<bool> startPublish(int position) async {
    return await _channel
        .invokeMethod(Constants.START_PUBLISH, {Constants.POSITION: position});
  }

  Future<bool> stopPublish() async {
    return await _channel.invokeMethod(Constants.STOP_PUBLISH);
  }

  Future<bool> pointUserStartPublish(
      String userId, String userName, int position) async {
    return await _channel.invokeMethod(Constants.POINT_USER_START_PUBLISH, {
      Constants.POSITION: position,
      Constants.USER_ID: userId,
      Constants.USER_NAME: userName
    });
  }

  Future<bool> gaveUpStartPublish(
      String userId, String userName, int position) async {
    return await _channel.invokeMethod(Constants.GAVE_UP_START_PUBLISH, {
      Constants.POSITION: position,
      Constants.USER_ID: userId,
      Constants.USER_NAME: userName
    });
  }

  Future<bool> pointUserStopPublish(String userId, String userName) async {
    return await _channel.invokeMethod(Constants.POINT_USER_STOP_PUBLISH,
        {Constants.USER_ID: userId, Constants.USER_NAME: userName});
  }

  lockPosition(int position) async {
    await _channel
        .invokeMethod(Constants.LOCK_POSITION, {Constants.POSITION: position});
  }

  unLockPosition(int position) async {
    await _channel.invokeMethod(
        Constants.UNLOCK_POSITION, {Constants.POSITION: position});
  }

  lockMic(int position) async {
    await _channel
        .invokeMethod(Constants.LOCK_MIC, {Constants.POSITION: position});
  }

  unLockMic(int position) async {
    await _channel
        .invokeMethod(Constants.UNLOCK_MIC, {Constants.POSITION: position});
  }
}

abstract class ILoginCallback {
  void onLoginSuc();

  void onLoginFailure();
}

abstract class IRoomCallback {
  void onDisconnect(int errorCode, String roomId);

  void onKickOut(int errorCode, String roomId);
}

abstract class IRoomUserCallback {
  void onAddUser(User user);

  void onRemoveUser(String userId);
}

abstract class IRoomStreamCallback {
  void onLockPosition(int position);

  void onUnLockPosition(int position);

  void onLockMicPosition(int position);

  void onUnLockMicPosition(int position);

  void onSoundLevel(String streamId, int soundLevel);

  void onPullerStreamUpdate(
      String userId, String streamId, bool mic, bool speaker, int micLocation);

  void onStreamUpdate(String userId, bool mic, bool speaker, int micLocation);

  void onStreamAdd(User user);

  void onStreamRemove(String userId);
}

abstract class IRoomMessageCallback {
  void onSendMessageError(int errorCode, String roomId, String sessionId);

  void onSendMessageSuc(String roomId, String sessionId);

  void onReceiveMessage(String roomId, List<RoomMessage> roomMessages);
}
