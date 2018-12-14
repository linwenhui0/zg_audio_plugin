package com.flutter.zg.zgaudioplugin.channel

import com.flutter.zg.contants.Constants.Companion.Channel.Companion.LOGIN_FAILURE
import com.flutter.zg.contants.Constants.Companion.Channel.Companion.LOGIN_SUC
import com.yfwl.voice.voicelistener.ILoginCallback

/**
 * 登录状态
 */
class LoginStreamHandler : DefaultStreamHandler(), ILoginCallback {

    /**
     * 登录成功
     */
    override fun onLoginSuc() {
        setResultData(LOGIN_SUC)
    }

    /**
     * 登录失败
     */
    override fun onLoginFailure() {
        setResultData(LOGIN_FAILURE)
    }

}