class Constants {
  static const String CHANNEL = "zg_audio_plugin"; //插件名

  static const String INIT_SDK = "initSDK"; //初始化sdk
  static const String LOGIN = "login"; //登录
  static const String LOGOUT = "logout"; //注销
  static const String SEND_MESSAGE = "sendMessage"; //房间内发送消息
  static const String OPEN_SPEAKER = "openSpeaker"; //打开扬声器
  static const String OPEN_MIC = "openMic"; //打开麦克风
  static const String INIT_ROOM_LISTENER = "initRoomListener"; //初始化房间回调
  static const String DESTROY_ROOM_LISTENER = "destroyRoomListener"; //回收房间回调
  static const String START_PUBLISH = "startPublish"; //开启推流
  static const String STOP_PUBLISH = "stopPublish"; //停止推流
  static const String POINT_USER_START_PUBLISH =
      "pointUserStartPublish"; //指定用户上麦
  static const String GAVE_UP_START_PUBLISH = "gaveUpStartPublish"; //放弃上麦
  static const String POINT_USER_STOP_PUBLISH = "pointUserStopPublish"; //指定用户上麦
  static const String LOCK_POSITION = "lockPosition"; //锁麦位
  static const String UNLOCK_POSITION = "unLockPosition"; //解锁麦位
  static const String LOCK_MIC = "lockMic"; //锁mic
  static const String UNLOCK_MIC = "unLockMic"; //解锁mic
  static const String HOUSE_OWNER = "setHouseOwner"; //角色

  static const String LOGIN_STATUS_CHANNEL = "loginStatusChannel"; //用户在线渠道
  static const String LOGIN_SUC = "onLoginSuc"; //登录成功
  static const String LOGIN_FAILURE = "onLoginFailure"; //登录失败

  static const String ROOM_MEMBER_CHANNEL = "roomMemberChannel"; //房间内成员变动渠道
  static const String ROOM_ADD_USER = "onAddUser"; //房间增加好友
  static const String ROOM_REMOVE_USER = "onRemoveUser"; //删除房间好友
  static const String ROOM_DISCONNECT = "onDisconnect"; //断开连接
  static const String ROOM_KICK_OUT = "onKickOut"; //被踢出房间
  static const String ROOM_STREAM_ADD = "onStreamAdd"; //房间增加流数据
  static const String ROOM_STREAM_REMOVE = "onStreamRemove"; //房间删除流数据
  static const String ROOM_STREAM_UPDATE = "onStreamUpdate"; //更新房间流数据
  static const String ROOM_PULLER_STREAM_UPDATE =
      "onPullerStreamUpdate"; //拉取流数据
  static const String ROOM_SOUND_LEVEL = "onSoundLevel"; //声量回调
  static const String ROOM_LOCK_POSITION = "onLockPosition"; //锁麦位回调
  static const String ROOM_UNLOCK_POSITION = "onUnLockPosition"; //解锁锁麦位回调
  static const String ROOM_LOCK_MIC = "onLockMicPosition"; //锁麦回调
  static const String ROOM_UNLOCK_MIC = "onUnLockMicPosition"; //解锁锁麦回调
  static const String ROOM_REMOTE_START_PUBLISH =
      "onRemoteStartPublish"; //指定用户上麦
  static const String ROOM_GAVE_UP_START_PUBLISH =
      "onRemoteGaveUpPublish"; //用户放弃上麦
  static const String ROOM_REMOTE_STOP_PUBLISH = "onRemoteStopPublish"; //指定用户下麦

  static const String ROOM_MESSAGE_CHANNEL = "roomMessageChannel"; //房间内消息渠道
  static const String ROOM_SEND_MESSAGE_ERROR = "onSendMessageError"; //发送消息出错
  static const String ROOM_SEND_MESSAGE_SUC = "onSendMessageSuc"; //发送消息成功
  static const String ROOM_RECEIVE_MESSAGE = "onReceiveMessage"; //接收消息

  static const String USER_ID = "userId"; //用户id
  static const String USER_NAME = "userName"; //用户
  static const String ENABLE_MIC = "enableMic"; //麦克风
  static const String ROOM_ID = "roomId"; //房间ID
  static const String ROOM_NAME = "roomName"; // 房间名
  static const String STREAM_ID = "streamId"; //流ID
  static const String ENABLE_SPEAKER = "enableSpeaker"; //扬声器
  static const String MIC_LOCATION = "micLocation"; //麦位位置
  static const String SOUND_LEVEL = "soundLevel"; //麦的音量
  static const String SESSION_ID = "sessionId"; //会话id
  static const String ERROR_CODE = "errorCode"; //错误码
  static const String POSITION = "position"; //位置
  static const String ROLE = "role"; //房主

  static const String MESSAGES = "messages"; //消息
  static const String MESSAGE_TYPE = "messageType"; //消息类型
  static const String MESSAGE_CATEGORY = "messageCategory"; //消息种类
  static const String MESSAGE_CONTENT = "messageContent"; //消息内容文本
  static const String FROM_USER_ID = "fromUserID"; //消息发送者ID
  static const String FROM_USER_NAME = "fromUserName"; //消息发送者name
  static const String MESSAGE_ID = "messageID"; //消息ID
  static const String MESSAGE_PRIORITY = "messagePriority"; //消息优化级

  static const String RESULT_DATA = "resultData"; //收到数据
  static const String METHOD_NAME = "methodName"; //方法名
}
