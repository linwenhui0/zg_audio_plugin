package com.flutter.zg.contants

class Constants {

    companion object {

        const val PLUGIN = "zg_audio_plugin"

        class Method {
            companion object {
                const val INIT_SDK = "initSDK"//初始化sdk
                const val LOGIN = "login"//登录
                const val LOGOUT = "logout"//注销
                const val SEND_MESSAGE = "sendMessage"//房间内发送消息
                const val OPEN_SPEAKER = "openSpeaker"//打开扬声器
                const val OPEN_MIC = "openMic"//打开麦克风
                const val INIT_ROOM_LISTENER = "initRoomListener"//初始化房间回调
                const val DESTROY_ROOM_LISTENER = "destroyRoomListener"//回收房间回调
                const val START_PUBLISH = "startPublish"//开启推流
                const val STOP_PUBLISH = "stopPublish"//停止推流
                const val POINT_USER_START_PUBLISH = "pointUserStartPublish"//指定用户上麦
                const val GAVE_UP_START_PUBLISH = "gaveUpStartPublish"//放弃上麦
                const val POINT_USER_STOP_PUBLISH = "pointUserStopPublish"//指定用户上麦
                const val LOCK_POSITION = "lockPosition"//锁麦位
                const val UNLOCK_POSITION = "unLockPosition"//解锁麦位
                const val LOCK_MIC = "lockMic"//锁mic
                const val UNLOCK_MIC = "unLockMic"//解锁mic

                const val USER_ID = "userId"//用户id
                const val USER_NAME = "userName"//用户
                const val ENABLE_MIC = "enableMic"//麦克风
                const val ROOM_ID = "roomId"//房间ID
                const val ROOM_NAME = "roomName"// 房间名
                const val STREAM_ID = "streamId"//流ID
                const val ENABLE_SPEAKER = "enableSpeaker"//扬声器
                const val MIC_LOCATION = "micLocation"//麦位位置
                const val SOUND_LEVEL = "soundLevel"//麦的音量
                const val SESSION_ID = "sessionId"//会话id
                const val ERROR_CODE = "errorCode"//错误码
                const val POSITION = "position"//位置

                const val MESSAGES = "messages"//消息
                const val MESSAGE_TYPE = "messageType"//消息类型
                const val MESSAGE_CATEGORY = "messageCategory"//消息种类
                const val MESSAGE_CONTENT = "messageContent"//消息内容文本
                const val FROM_USER_ID = "fromUserID"//消息发送者ID
                const val FROM_USER_NAME = "fromUserName"//消息发送者name
                const val MESSAGE_ID = "messageID"//消息ID
                const val MESSAGE_PRIORITY = "messagePriority"//消息优化级

            }
        }


        class Channel {
            companion object {
                const val LOGIN_CHANNEL = "loginStatusChannel"//用户在线渠道
                const val LOGIN_SUC = "onLoginSuc"//登录成功
                const val LOGIN_FAILURE = "onLoginFailure"//登录失败


                const val ROOM_MEMBER_CHANNEL = "roomMemberChannel"//房间内成员变动渠道
                const val ROOM_ADD_USER = "onAddUser"//房间增加好友
                const val ROOM_REMOVE_USER = "onRemoveUser"//删除房间好友
                const val ROOM_DISCONNECT = "onDisconnect"//断开连接
                const val ROOM_KICK_OUT = "onKickOut"//被踢出房间
                const val ROOM_STREAM_ADD = "onStreamAdd"//房间增加流数据
                const val ROOM_STREAM_REMOVE = "onStreamRemove"//房间删除流数据
                const val ROOM_STREAM_UPDATE = "onStreamUpdate"//更新房间流数据
                const val ROOM_PULLER_STREAM_UPDATE = "onPullerStreamUpdate"//拉取流数据
                const val ROOM_SOUND_LEVEL = "onSoundLevel"//声量回调
                const val ROOM_LOCK_POSITION = "onLockPosition"//锁麦位回调
                const val ROOM_UNLOCK_POSITION = "onUnLockPosition"//解锁锁麦位回调
                const val ROOM_LOCK_MIC = "onLockMicPosition"//锁麦回调
                const val ROOM_UNLOCK_MIC = "onUnLockMicPosition"//解锁锁麦回调
                const val ROOM_REMOTE_START_PUBLISH = "onRemoteStartPublish"//指定用户上麦
                const val ROOM_GAVE_UP_START_PUBLISH = "onRemoteGaveUpPublish"//用户放弃上麦
                const val ROOM_REMOTE_STOP_PUBLISH = "onRemoteStopPublish"//指定用户下麦

                const val ROOM_MESSAGE_CHANNEL = "roomMessageChannel"//房间内消息渠道
                const val ROOM_SEND_MESSAGE_ERROR = "onSendMessageError"//发送消息出错
                const val ROOM_SEND_MESSAGE_SUC = "onSendMessageSuc"//发送消息成功
                const val ROOM_RECEIVE_MESSAGE = "onReceiveMessage"//接收消息
            }
        }


    }

}