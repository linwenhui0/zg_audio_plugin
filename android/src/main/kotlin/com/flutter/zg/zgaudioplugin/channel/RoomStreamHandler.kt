package com.flutter.zg.zgaudioplugin.channel

import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_RECEIVE_MESSAGE
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_SEND_MESSAGE_ERROR
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_SEND_MESSAGE_SUC
import com.flutter.zg.contants.Constants.Companion.Method.Companion.ERROR_CODE
import com.flutter.zg.contants.Constants.Companion.Method.Companion.FROM_USER_ID
import com.flutter.zg.contants.Constants.Companion.Method.Companion.FROM_USER_NAME
import com.flutter.zg.contants.Constants.Companion.Method.Companion.MESSAGES
import com.flutter.zg.contants.Constants.Companion.Method.Companion.MESSAGE_CATEGORY
import com.flutter.zg.contants.Constants.Companion.Method.Companion.MESSAGE_CONTENT
import com.flutter.zg.contants.Constants.Companion.Method.Companion.MESSAGE_ID
import com.flutter.zg.contants.Constants.Companion.Method.Companion.MESSAGE_PRIORITY
import com.flutter.zg.contants.Constants.Companion.Method.Companion.MESSAGE_TYPE
import com.flutter.zg.contants.Constants.Companion.Method.Companion.ROOM_ID
import com.flutter.zg.contants.Constants.Companion.Method.Companion.SESSION_ID
import com.hlibrary.util.Logger
import com.yfwl.voice.model.RoomMessage
import com.yfwl.voice.model.User
import com.yfwl.voice.voicelistener.IRoomMessageCallback
import com.yfwl.voice.voicelistener.IStreamCallback
import org.json.JSONArray
import org.json.JSONObject

/**
 * 房间内消息互动
 */
class RoomStreamHandler : DefaultStreamHandler(), IRoomMessageCallback {

    override fun onSendMessageError(errorCode: Int, roomId: String?, sessionId: Long) {
        Logger.getInstance().defaultTagD("onSendMessageError errorCode($errorCode) roomId($roomId) sessionId($sessionId)")
        val jsonObject = JSONObject()
        jsonObject.put(ERROR_CODE, errorCode)
        jsonObject.put(ROOM_ID, roomId)
        jsonObject.put(SESSION_ID, sessionId.toString())
        setResultData(ROOM_SEND_MESSAGE_ERROR, jsonObject)
    }

    override fun onRecvMessage(roomId: String?, messages: Array<out RoomMessage>?) {
        Logger.getInstance().defaultTagD("onRecvMessage roomId($roomId) messages($messages)")
        if (messages != null) {
            val len = messages.size
            if (len > 0) {
                val resultObj = JSONObject()
                resultObj.put(ROOM_ID, roomId)
                val jsonArray = JSONArray()
                for (roomMessage in messages) {
                    val jsonObject = JSONObject()
                    jsonObject.put(FROM_USER_ID, roomMessage.fromUserID)
                    jsonObject.put(FROM_USER_NAME, roomMessage.fromUserName)
                    jsonObject.put(MESSAGE_ID, roomMessage.messageID.toString())
                    jsonObject.put(MESSAGE_CONTENT, roomMessage.content)
                    jsonObject.put(MESSAGE_TYPE, roomMessage.messageType)
                    jsonObject.put(MESSAGE_CATEGORY, roomMessage.messageCategory)
                    jsonObject.put(MESSAGE_PRIORITY, roomMessage.messagePriority)
                    jsonArray.put(jsonObject)
                }
                resultObj.put(MESSAGES, jsonArray)
                setResultData(ROOM_RECEIVE_MESSAGE, resultObj)
            }
        }
    }

    override fun onSendMessageSuc(roomId: String?, sessionId: Long) {
        Logger.getInstance().defaultTagD("onSendMessageError roomId($roomId) sessionId($sessionId)")
        val jsonObject = JSONObject()
        jsonObject.put(ROOM_ID, roomId)
        jsonObject.put(SESSION_ID, sessionId.toString())
        setResultData(ROOM_SEND_MESSAGE_SUC, jsonObject)
    }

}