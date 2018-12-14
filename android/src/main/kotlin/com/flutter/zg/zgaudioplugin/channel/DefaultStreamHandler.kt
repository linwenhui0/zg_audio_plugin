package com.flutter.zg.zgaudioplugin.channel

import com.hlibrary.util.Logger
import io.flutter.plugin.common.EventChannel
import org.json.JSONObject

open class DefaultStreamHandler : EventChannel.StreamHandler {

    open var result: EventChannel.EventSink? = null


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
        val jsonResult = JSONObject()
        jsonResult.put("methodName", methodName)
        jsonResult.put("resultData", resultData)
        result?.success(jsonResult.toString())
    }

    open fun setResultData(methodName: String) {
        Logger.getInstance().defaultTagD("setResultData = $methodName ")
        val jsonResult = JSONObject()
        jsonResult.put("methodName", methodName)
        result?.success(jsonResult.toString())
    }

}