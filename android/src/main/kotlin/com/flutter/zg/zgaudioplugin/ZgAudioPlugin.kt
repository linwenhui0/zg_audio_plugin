package com.flutter.zg.zgaudioplugin

import com.hlibrary.util.Logger
import com.yfwl.voice.model.RoomMessage
import com.yfwl.voice.voicelistener.DefaultVoiceAccessor
import com.yfwl.voice.voicelistener.IRoomCallback
import com.yfwl.voice.voicelistener.IRoomMessageCallback
import com.yfwl.zego.sdk.ZegoVoiceAccessor
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import org.json.JSONArray
import org.json.JSONObject

class ZgAudioPlugin : MethodCallHandler {


    companion object {
        const val INIT_SDK = "initSDK"
        const val LOGIN = "login"
        const val LOGOUT = "logout"
        const val SEND_MESSAGE = "sendMessage"
        const val OPEN_SPEAKER = "openSpeaker"
        const val OPEN_MIC = "openMic"

        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {

            var plugin = ZgAudioPlugin(registrar)

            val channel = MethodChannel(registrar.messenger(), "zg_audio_plugin")
            channel.setMethodCallHandler(plugin)

            val loginChannel = EventChannel(registrar.messenger(), "audioRoomStatus")
            loginChannel.setStreamHandler(plugin.loginEventHandler)

            val roomMessageChannel = EventChannel(registrar.messenger(), "roomMessage")
            roomMessageChannel.setStreamHandler(plugin.roomStreamHandler)
        }
    }

    val registrar: Registrar

    val zegoVoiceAccessor: DefaultVoiceAccessor<ZegoVoiceAccessor>

    var result: Result? = null

    var loginEventHandler: LoginStreamHandler? = null
    var roomStreamHandler: RoomStreamHandler? = null

    constructor(registrar: Registrar) : super() {
        this.registrar = registrar
        zegoVoiceAccessor = ZegoVoiceAccessor(registrar.context())
        loginEventHandler = LoginStreamHandler()
        roomStreamHandler = RoomStreamHandler()

    }


    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        when (call.method) {
            INIT_SDK -> {
                val userId: String? = call.argument("userId")
                val userName: String? = call.argument("userName")
                Logger.getInstance().defaultTagD("初始化即构sdk , userId = ", userId, " , userName = ", userName)
                zegoVoiceAccessor.initSDK(userId, userName)
                result.success(true)
            }
            LOGIN -> {
                this.result = result
                val roomId: String? = call.argument("roomId")
                val roomName: String? = call.argument("roomName")
                Logger.getInstance().defaultTagD("即构sdk登录，房间号：", roomId, "房间名：", roomName)
                zegoVoiceAccessor.setRoomMessageCallback(roomStreamHandler)
                zegoVoiceAccessor.login(roomId, roomName, loginEventHandler)
                result.success(true)
            }
            LOGOUT -> {
                Logger.getInstance().defaultTagD("即构sdk注销")
                zegoVoiceAccessor.logout()
                result.success(true)
            }
            SEND_MESSAGE -> {
                val messageType: Int? = call.argument("messageType")
                val messageCategory: Int? = call.argument("messageCategory")
                val content: Int? = call.argument("content")
                Logger.getInstance().defaultTagD("发送消息 ", messageType, " , ", messageCategory, " , ", content)
                zegoVoiceAccessor.sendRoomMessage(messageType!!, messageCategory!!, content as String)
            }
            OPEN_SPEAKER -> {
                val speaker: Boolean? = call.argument("openSpeaker")
                zegoVoiceAccessor.openSpeaker(speaker!!)

            }
            OPEN_MIC -> {
                val mic: Boolean? = call.argument("openMic")
                zegoVoiceAccessor.openMic(mic!!)
            }
            else -> result.notImplemented()
        }

    }

    class LoginStreamHandler : DefaultStreamHandler(), IRoomCallback {


        override fun onAddUser(p0: String?, p1: String?, p2: Boolean) {
            var resultData = JSONObject()
            resultData.put("userId", p0)
            resultData.put("userName", p1)
            resultData.put("enableMic", p2);
            setResultData("onAddUser", resultData);
        }

        override fun onRemoveUser(p0: String?) {
            Logger.getInstance().defaultTagD("onRemoveUser")
            var resultData = JSONObject()
            resultData.put("userId", p0)
            setResultData("onRemoveUser", resultData);
        }

        override fun onLoginSuc() {
            setResultData("onLoginSuc")
        }

        override fun onLoginFailure() {
            setResultData("onLoginFailure")
        }

        override fun onExtraCallback(p0: Int, p1: String?) {
            Logger.getInstance().defaultTagD("onExtraCallback")
        }

        override fun onDisconnect(p0: Int, p1: String?) {
            var resultData = JSONObject()
            resultData.put("roomId", p0)
            setResultData("onDisconnect", resultData)
        }

        override fun onUpdateUser(p0: String?, p1: Boolean) {
            var jsonObject = JSONObject();
            jsonObject.put("userId", p0);
            jsonObject.put("enableMic", p1);
            setResultData("onUpdateUser", jsonObject)
        }


    }

    class RoomStreamHandler : DefaultStreamHandler(), IRoomMessageCallback {

        override fun onSendMessageError(p0: Int, p1: String?, p2: Long) {
            var jsonObject = JSONObject();
            jsonObject.put("errorCode", p0);
            jsonObject.put("roomId", p1);
            jsonObject.put("sessionId", p2.toString());
            setResultData("onSendMessageError", jsonObject)
        }

        override fun onRecvMessage(p0: String?, p1: Array<out RoomMessage>?) {
            if (p1 != null) {
                var len = p1.size;
                if (len > 0) {
                    var jsonArray = JSONArray()
                    for (roomMessage in p1) {
                        var jsonObject = JSONObject()
                        jsonObject.put("fromUserID", roomMessage.fromUserID)
                        jsonObject.put("fromUserName", roomMessage.fromUserName)
                        jsonObject.put("messageID", roomMessage.messageID.toString())
                        jsonObject.put("content", roomMessage.content)
                        jsonObject.put("messageType", roomMessage.messageType)
                        jsonObject.put("messageCategory", roomMessage.messageCategory)
                        jsonObject.put("messagePriority", roomMessage.messagePriority)
                        jsonArray.put(jsonObject)
                    }
                    setResultData("onRecvMessage", jsonArray)
                }
            }
        }

        override fun onSendMessageSuc(p0: String?, p1: Long) {
            var jsonObject = JSONObject();
            jsonObject.put("roomId", p0)
            jsonObject.put("sessionId", p1.toString())
            setResultData("onSendMessageSuc", jsonObject)
        }

    }

    open class DefaultStreamHandler : EventChannel.StreamHandler {

        var result: EventChannel.EventSink? = null


        override fun onListen(p0: Any?, p1: EventChannel.EventSink?) {
            Logger.getInstance().defaultTagD("onListen")
            result = p1
        }

        override fun onCancel(p0: Any?) {
            Logger.getInstance().defaultTagD("onCancel")
            result = null
        }

        open fun setResultData(methodName: String, resultData: Any) {
            Logger.getInstance().defaultTagD("setResultData = $methodName , $resultData")
            var jsonResult = JSONObject()
            jsonResult.put("methodName", methodName)
            if (resultData != null)
                jsonResult.put("resultData", resultData)
            result?.success(jsonResult.toString())
        }

        open fun setResultData(methodName: String) {
            Logger.getInstance().defaultTagD("setResultData = $methodName ")
            var jsonResult = JSONObject()
            jsonResult.put("methodName", methodName)
            result?.success(jsonResult.toString())
        }


    }

}
