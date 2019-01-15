package com.flutter.zg.zgaudioplugin.channel

import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_ADD_USER
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_DISCONNECT
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_GAVE_UP_START_PUBLISH
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_KICK_OUT
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_LOCK_MIC
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_LOCK_POSITION
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_PULLER_STREAM_UPDATE
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_REMOTE_START_PUBLISH
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_REMOTE_STOP_PUBLISH
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_REMOVE_USER
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_SOUND_LEVEL
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_STREAM_ADD
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_STREAM_REMOVE
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_STREAM_UPDATE
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_UNLOCK_MIC
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.ROOM_UNLOCK_POSITION
import com.flutter.zg.contants.Constants.Companion.Method.Companion.ENABLE_MIC
import com.flutter.zg.contants.Constants.Companion.Method.Companion.ENABLE_SPEAKER
import com.flutter.zg.contants.Constants.Companion.Method.Companion.ERROR_CODE
import com.flutter.zg.contants.Constants.Companion.Method.Companion.MIC_LOCATION
import com.flutter.zg.contants.Constants.Companion.Method.Companion.POSITION
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


    override fun onRemoteStartPublish(userId: String?, location: Int) {
        Logger.getInstance().defaultTagW("onRemoteStartPublish userId($userId) location($location)")
        val resultData = JSONObject()
        resultData.put(POSITION, location)
        resultData.put(USER_ID,userId)
        setResultData(ROOM_REMOTE_START_PUBLISH, resultData)
    }

    override fun onRemoteStopPublish(userId: String?) {
        Logger.getInstance().defaultTagW("onRemoteStopPublish userId($userId)")
        val resultData = JSONObject()
        resultData.put(USER_ID,userId)
        setResultData(ROOM_REMOTE_STOP_PUBLISH, resultData)
    }

    override fun onRemoteGaveUpPublish(userId: String?) {
        Logger.getInstance().defaultTagW("onRemoteGaveUpPublish userId($userId)")
        val resultData = JSONObject()
        resultData.put(USER_ID,userId)
        setResultData(ROOM_GAVE_UP_START_PUBLISH, resultData)
    }

    override fun onMicLockPosition(location: Int) {
        Logger.getInstance().defaultTagW("onMicLockPosition location($location)")
        val resultData = JSONObject()
        resultData.put(POSITION, location)
        setResultData(ROOM_LOCK_MIC, resultData)
    }

    override fun onMicUnLockPosition(location: Int) {
        Logger.getInstance().defaultTagW("onMicUnLockPosition location($location)")
        val resultData = JSONObject()
        resultData.put(POSITION, location)
        setResultData(ROOM_UNLOCK_MIC, resultData)
    }

    override fun onLockPosition(location: Int) {
        Logger.getInstance().defaultTagW("onLockPosition location($location)")
        val resultData = JSONObject()
        resultData.put(POSITION, location)
        setResultData(ROOM_LOCK_POSITION, resultData)
    }

    override fun onUnLockPostion(location: Int) {
        Logger.getInstance().defaultTagW("onUnLockPosition location($location)")
        val resultData = JSONObject()
        resultData.put(POSITION, location)
        setResultData(ROOM_UNLOCK_POSITION, resultData)
    }

    override fun onRecvCustomCommand(p0: String?, p1: String?, p2: String?, p3: Int, p4: String?) {
    }

    override fun onSoundLevel(streamId: String?, soundLevel: Float) {
        Logger.getInstance().defaultTagD("onSoundLevel streamId($streamId) soundLevel($soundLevel)")
        val resultData = JSONObject()
        resultData.put(STREAM_ID, streamId)
        resultData.put(SOUND_LEVEL, soundLevel.toInt())
        setResultData(ROOM_SOUND_LEVEL, resultData)
    }

    override fun onPullerStreamUpdate(userId: String?, streamId: String?, mic: Boolean, speaker: Boolean, micLocation: Int) {
        Logger.getInstance().defaultTagW("onPullerStreamUpdate userId($userId) streamId($streamId) mic($mic) speaker($speaker) micLocation($micLocation)")
        val resultData = JSONObject()
        resultData.put(USER_ID, userId)
        resultData.put(STREAM_ID, streamId)
        resultData.put(ENABLE_MIC, mic)
        resultData.put(ENABLE_SPEAKER, speaker)
        resultData.put(MIC_LOCATION, micLocation)
        setResultData(ROOM_PULLER_STREAM_UPDATE, resultData)
    }

    override fun onStreamUpdate(userId: String?, mic: Boolean, speaker: Boolean, micLocation: Int) {
        Logger.getInstance().defaultTagW("onStreamUpdate userId($userId) mic($mic) speaker($speaker) micLocation($micLocation)")
        val resultData = JSONObject()
        resultData.put(USER_ID, userId)
        resultData.put(ENABLE_MIC, mic)
        resultData.put(ENABLE_SPEAKER, speaker)
        resultData.put(MIC_LOCATION, micLocation)
        setResultData(ROOM_STREAM_UPDATE, resultData)
    }

    override fun onStreamAdd(user: User) {
        Logger.getInstance().defaultTagW("onStreamAdd = user(", user, ")")
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
        Logger.getInstance().defaultTagW("onStreamRemove = userId(", userId, ")")
        val resultData = JSONObject()
        resultData.put(USER_ID, userId)
        setResultData(ROOM_STREAM_REMOVE, resultData)
    }


    override fun onAddUser(user: User) {
        Logger.getInstance().defaultTagW("onAddUser = user(", user, ")")
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
        Logger.getInstance().defaultTagW("onRemoveUser userId($userId)")
        val resultData = JSONObject()
        resultData.put(USER_ID, userId)
        setResultData(ROOM_REMOVE_USER, resultData)
    }


    override fun onExtraCallback(code: Int, msg: String?) {
        Logger.getInstance().defaultTagD("onExtraCallback code($code) msg($msg)")
    }

    override fun onDisconnect(errorCode: Int, roomId: String?) {
        Logger.getInstance().defaultTagW("onDisconnect errorCode($errorCode) roomId($roomId)")
        val resultData = JSONObject()
        resultData.put(ERROR_CODE, errorCode)
        resultData.put(ROOM_ID, roomId)
        setResultData(ROOM_DISCONNECT, resultData)
    }

    override fun onKickOut(errorCode: Int, roomId: String?) {
        Logger.getInstance().defaultTagW("onKickOut errorCode($errorCode) roomId($roomId)")
        val resultData = JSONObject()
        resultData.put(ERROR_CODE, errorCode)
        resultData.put(ROOM_ID, roomId)
        setResultData(ROOM_KICK_OUT, resultData)
    }
}