package com.flutter.zg.zgaudioplugin.channel

import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_ADD_USER
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_DISCONNECT
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_KICK_OUT
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_PULLER_STREAM_UPDATE
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_REMOVE_USER
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_SOUND_LEVEL
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_STREAM_ADD
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_STREAM_REMOVE
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_STREAM_UPDATE
import com.flutter.zg.contants.Constants.Companion.Method.Companion.ENABLE_MIC
import com.flutter.zg.contants.Constants.Companion.Method.Companion.ENABLE_SPEAKER
import com.flutter.zg.contants.Constants.Companion.Method.Companion.ERROR_CODE
import com.flutter.zg.contants.Constants.Companion.Method.Companion.MIC_LOCATION
import com.flutter.zg.contants.Constants.Companion.Method.Companion.ROOM_ID
import com.flutter.zg.contants.Constants.Companion.Method.Companion.SOUND_LEVEL
import com.flutter.zg.contants.Constants.Companion.Method.Companion.STREAM_ID
import com.flutter.zg.contants.Constants.Companion.Method.Companion.USER_ID
import com.flutter.zg.contants.Constants.Companion.Method.Companion.USER_NAME
import com.hlibrary.util.Logger
import com.yfwl.voice.model.User
import com.yfwl.voice.voicelistener.IPullerCallback
import com.yfwl.voice.voicelistener.IRoomCallback
import com.yfwl.voice.voicelistener.ISoundLevelCallback
import com.yfwl.voice.voicelistener.IStreamCallback
import org.json.JSONObject

/**
 * 房间内成员变动
 */
class RoomHandler : DefaultStreamHandler(), IRoomCallback, IStreamCallback, IPullerCallback, ISoundLevelCallback {



    override fun onSoundLevel(streamId: String?, soundLevel: Float) {
        Logger.getInstance().defaultTagD("onSoundLevel streamId($streamId) soundLevel($soundLevel)")
        val resultData = JSONObject()
        resultData.put(STREAM_ID, streamId)
        resultData.put(SOUND_LEVEL, soundLevel.toInt())
        setResultData(ROOM_SOUND_LEVEL, resultData)
    }

    override fun onPullerStreamUpdate(userId: String?, streamId: String?, mic: Boolean, speaker: Boolean, micLocation: Int) {
        Logger.getInstance().defaultTagD("onPullerStreamUpdate userId($userId) streamId($streamId) mic($mic) speaker($speaker) micLocation($micLocation)")
        val resultData = JSONObject()
        resultData.put(USER_ID, userId)
        resultData.put(STREAM_ID, streamId)
        resultData.put(ENABLE_MIC, mic)
        resultData.put(ENABLE_SPEAKER, speaker)
        resultData.put(MIC_LOCATION, micLocation)
        setResultData(ROOM_PULLER_STREAM_UPDATE, resultData)
    }

    override fun onStreamUpdate(userId: String?, mic: Boolean, speaker: Boolean, micLocation: Int) {
        Logger.getInstance().defaultTagD("onStreamUpdate userId($userId) mic($mic) speaker($speaker) micLocation($micLocation)")
        val resultData = JSONObject()
        resultData.put(USER_ID, userId)
        resultData.put(ENABLE_MIC, mic)
        resultData.put(ENABLE_SPEAKER, speaker)
        resultData.put(MIC_LOCATION, micLocation)
        setResultData(ROOM_STREAM_UPDATE, resultData)
    }

    override fun onStreamAdd(user: User) {
        Logger.getInstance().defaultTagD("onStreamAdd = user(", user, ")")
        val resultData = JSONObject()
        resultData.put(USER_ID, user.userId)
        resultData.put(USER_NAME, user.userName)
        resultData.put(ENABLE_MIC, user.isMic)
        resultData.put(STREAM_ID, user.streamId)
        resultData.put(ENABLE_SPEAKER, user.isSpeaker)
        resultData.put(MIC_LOCATION, user.micLocation)
        setResultData(ROOM_STREAM_ADD, resultData)
    }

    override fun onStreamRemove(userId: String?) {
        Logger.getInstance().defaultTagD("onStreamRemove = userId(", userId, ")")
        val resultData = JSONObject()
        resultData.put(USER_ID, userId)
        setResultData(ROOM_STREAM_REMOVE, resultData)
    }


    override fun onAddUser(user: User) {
        Logger.getInstance().defaultTagD("onAddUser = user(", user, ")")
        val resultData = JSONObject()
        resultData.put(USER_ID, user.userId)
        resultData.put(USER_NAME, user.userName)
        resultData.put(ENABLE_MIC, user.isMic)
        resultData.put(STREAM_ID, user.streamId)
        resultData.put(ENABLE_SPEAKER, user.isSpeaker)
        resultData.put(MIC_LOCATION, user.micLocation)
        setResultData(ROOM_ADD_USER, resultData)
    }

    override fun onRemoveUser(userId: String?) {
        Logger.getInstance().defaultTagD("onRemoveUser userId($userId)")
        val resultData = JSONObject()
        resultData.put(USER_ID, userId)
        setResultData(ROOM_REMOVE_USER, resultData)
    }


    override fun onExtraCallback(code: Int, msg: String?) {
        Logger.getInstance().defaultTagD("onExtraCallback code($code) msg($msg)")
    }

    override fun onDisconnect(errorCode: Int, roomId: String?) {
        Logger.getInstance().defaultTagD("onDisconnect errorCode($errorCode) roomId($roomId)")
        val resultData = JSONObject()
        resultData.put(ERROR_CODE,errorCode)
        resultData.put(ROOM_ID, roomId)
        setResultData(ROOM_DISCONNECT, resultData)
    }

    override fun onKickOut(errorCode: Int, roomId: String?) {
        Logger.getInstance().defaultTagD("onKickOut errorCode($errorCode) roomId($roomId)")
        val resultData = JSONObject()
        resultData.put(ERROR_CODE,errorCode)
        resultData.put(ROOM_ID, roomId)
        setResultData(ROOM_KICK_OUT, resultData)
    }
}