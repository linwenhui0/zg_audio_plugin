package com.flutter.zg.zgaudioplugin

import com.flutter.zg.contants.Constants.Companion.Channel.Companion.LOGIN_CHANNEL
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_MEMBER_CHANNEL
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_MESSAGE_CHANNEL
import com.flutter.zg.contants.Constants.Companion.Method.Companion.DESTROY_ROOM_LISTENER
import com.flutter.zg.contants.Constants.Companion.Method.Companion.GAVE_UP_START_PUBLISH
import com.flutter.zg.contants.Constants.Companion.Method.Companion.INIT_ROOM_LISTENER
import com.flutter.zg.contants.Constants.Companion.Method.Companion.INIT_SDK
import com.flutter.zg.contants.Constants.Companion.Method.Companion.LOCK_MIC
import com.flutter.zg.contants.Constants.Companion.Method.Companion.LOCK_POSITION
import com.flutter.zg.contants.Constants.Companion.Method.Companion.LOGIN
import com.flutter.zg.contants.Constants.Companion.Method.Companion.LOGOUT
import com.flutter.zg.contants.Constants.Companion.Method.Companion.MESSAGE_CATEGORY
import com.flutter.zg.contants.Constants.Companion.Method.Companion.MESSAGE_CONTENT
import com.flutter.zg.contants.Constants.Companion.Method.Companion.MESSAGE_TYPE
import com.flutter.zg.contants.Constants.Companion.Method.Companion.OPEN_MIC
import com.flutter.zg.contants.Constants.Companion.Method.Companion.OPEN_SPEAKER
import com.flutter.zg.contants.Constants.Companion.Method.Companion.POINT_USER_START_PUBLISH
import com.flutter.zg.contants.Constants.Companion.Method.Companion.POINT_USER_STOP_PUBLISH
import com.flutter.zg.contants.Constants.Companion.Method.Companion.POSITION
import com.flutter.zg.contants.Constants.Companion.Method.Companion.ROOM_ID
import com.flutter.zg.contants.Constants.Companion.Method.Companion.ROOM_NAME
import com.flutter.zg.contants.Constants.Companion.Method.Companion.SEND_MESSAGE
import com.flutter.zg.contants.Constants.Companion.Method.Companion.START_PUBLISH
import com.flutter.zg.contants.Constants.Companion.Method.Companion.STOP_PUBLISH
import com.flutter.zg.contants.Constants.Companion.Method.Companion.UNLOCK_MIC
import com.flutter.zg.contants.Constants.Companion.Method.Companion.UNLOCK_POSITION
import com.flutter.zg.contants.Constants.Companion.Method.Companion.USER_ID
import com.flutter.zg.contants.Constants.Companion.Method.Companion.USER_NAME
import com.flutter.zg.contants.Constants.Companion.PLUGIN
import com.flutter.zg.zgaudioplugin.channel.LoginStreamHandler
import com.flutter.zg.zgaudioplugin.channel.RoomHandler
import com.flutter.zg.zgaudioplugin.channel.RoomStreamHandler
import com.hlibrary.util.Logger
import com.yfwl.voice.voicelistener.DefaultVoiceAccessor
import com.yfwl.zego.sdk.ZegoVoiceAccessor
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class ZgAudioPlugin : MethodCallHandler {


    companion object {

        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {

            var plugin = ZgAudioPlugin(registrar)

            // 方法注册
            val channel = MethodChannel(registrar.messenger(), PLUGIN)
            channel.setMethodCallHandler(plugin)

            // 登录渠道
            val loginChannel = EventChannel(registrar.messenger(), LOGIN_CHANNEL)
            loginChannel.setStreamHandler(plugin.loginEventHandler)

            // 房间内成员变动渠道
            val roomMemberChannel = EventChannel(registrar.messenger(), ROOM_MEMBER_CHANNEL)
            roomMemberChannel.setStreamHandler(plugin.roomHandler)

            // 房间内消息互动渠道
            val roomMessageChannel = EventChannel(registrar.messenger(), ROOM_MESSAGE_CHANNEL)
            roomMessageChannel.setStreamHandler(plugin.roomStreamHandler)
        }
    }

    private val registrar: Registrar

    private val voiceAccessor: DefaultVoiceAccessor<ZegoVoiceAccessor>

    var result: Result? = null

    var loginEventHandler: LoginStreamHandler? = null
    var roomStreamHandler: RoomStreamHandler? = null
    var roomHandler: RoomHandler? = null

    constructor(registrar: Registrar) : super() {
        this.registrar = registrar
        voiceAccessor = ZegoVoiceAccessor(registrar.context())
        loginEventHandler = LoginStreamHandler()
        roomStreamHandler = RoomStreamHandler()
        roomHandler = RoomHandler()
        Logger.getInstance().defaultTagD("生成即构插件")
    }


    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        Logger.getInstance().defaultTagD("onMethodCall( ${call.method} ) arguments( ${call.arguments} )")
        when (call.method) {
            INIT_SDK -> {
                val userId: String? = call.argument(USER_ID)
                val userName: String? = call.argument(USER_NAME)
                Logger.getInstance().defaultTagD(" 初始化即构sdk , userId = ", userId, " , userName = ", userName)
                voiceAccessor.initSDK(userId, userName)
                voiceAccessor.setPullerCallback(roomHandler)
                result.success(true)
            }
            LOGIN -> {
                this.result = result
                val roomId: String? = call.argument(ROOM_ID)
                val roomName: String? = call.argument(ROOM_NAME)
                Logger.getInstance().defaultTagD("即构sdk登录，房间号：", roomId, "房间名：", roomName)
                voiceAccessor.registerLoginCallback(loginEventHandler)
                voiceAccessor.login(roomId, roomName)
                result.success(true)
            }
            LOGOUT -> {
                Logger.getInstance().defaultTagD("即构sdk注销")
                voiceAccessor.unRegisterLoginCallback(loginEventHandler)
                voiceAccessor.logout()
                result.success(true)
            }
            SEND_MESSAGE -> {
                val messageType: Int? = call.argument(MESSAGE_TYPE)
                val messageCategory: Int? = call.argument(MESSAGE_CATEGORY)
                val content: String? = call.argument(MESSAGE_CONTENT)
                Logger.getInstance().defaultTagD("发送消息 $MESSAGE_TYPE(", messageType, ") , $MESSAGE_CATEGORY(", messageCategory, ") , $MESSAGE_CONTENT(", content, ")")
                voiceAccessor.sendRoomMessage(messageType!!, messageCategory!!, content as String)
                result.success(true)
            }
            OPEN_SPEAKER -> {
                val speaker: Boolean? = call.argument(OPEN_SPEAKER)
                voiceAccessor.openSpeaker(speaker!!)
                result.success(true)
            }
            OPEN_MIC -> {
                val mic: Boolean? = call.argument(OPEN_MIC)
                voiceAccessor.openMic(mic!!)
                result.success(true)
            }
            INIT_ROOM_LISTENER -> {
                Logger.getInstance().defaultTagD("$INIT_ROOM_LISTENER")

                voiceAccessor.registerRoomCallbacks(roomHandler)
                voiceAccessor.registerStreamCallback(roomHandler)
                voiceAccessor.registerSoundLevelCallback(roomHandler)
                voiceAccessor.registerRoomMessageCallback(roomStreamHandler)
                result.success(true)
            }
            DESTROY_ROOM_LISTENER -> {
                Logger.getInstance().defaultTagD("$DESTROY_ROOM_LISTENER")
                voiceAccessor.unRegisterRoomCallbacks(roomHandler)
                voiceAccessor.unRegisterStreamCallback(roomHandler)
                voiceAccessor.unRegisterSoundLevelCallback(roomHandler)
                voiceAccessor.unRegisterRoomMessageCallbacks(roomStreamHandler)
                result.success(true)
            }
            START_PUBLISH -> {
                val position: Int? = call.argument(POSITION)
                voiceAccessor.startPublish(position!!)
                result.success(true)
            }
            STOP_PUBLISH -> {
                voiceAccessor.stopPublish()
                result.success(true)
            }
            POINT_USER_START_PUBLISH -> {
                val position: Int? = call.argument(POSITION)
                val userId: String? = call.argument(USER_ID)
                val userName: String? = call.argument(USER_NAME)
                voiceAccessor.startPublish(userId, userName, position!!)
                result.success(true)
            }
            GAVE_UP_START_PUBLISH -> {
                val position: Int? = call.argument(POSITION)
                val userId: String? = call.argument(USER_ID)
                val userName: String? = call.argument(USER_NAME)
                voiceAccessor.gaveUpStartPublish(userId, userName, position!!)
                result.success(true)
            }
            POINT_USER_STOP_PUBLISH -> {
                val userId: String? = call.argument(USER_ID)
                val userName: String? = call.argument(USER_NAME)
                voiceAccessor.stopPublish(userId, userName)
                result.success(true)
            }
            LOCK_POSITION -> {
                val position: Int? = call.argument(POSITION)
                voiceAccessor.lockPosition(position!!)
                result.success(true)
            }
            UNLOCK_POSITION->{
                val position: Int? = call.argument(POSITION)
                voiceAccessor.unLockPosition(position!!)
                result.success(true)
            }
            LOCK_MIC->{
                val position: Int? = call.argument(POSITION)
                voiceAccessor.lockMic(position!!)
                result.success(true)
            }
            UNLOCK_MIC->{
                val position: Int? = call.argument(POSITION)
                voiceAccessor.unLockMic(position!!)
                result.success(true)
            }
            else -> result.notImplemented()
        }

    }


}
