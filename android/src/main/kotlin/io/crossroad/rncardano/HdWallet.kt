package io.crossroad.rncardano

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.Promise

class HdWallet(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "CardanoHdWallet"

    @ReactMethod
    fun fromEnhancedEntropy(entropy: ReadableArray, password: String, promise: Promise) {
        try {
            val res = Convert.array(
                    Native.hdWalletFromEnhancedEntropy(Convert.bytes(entropy), password)
            )
            promise.resolve(res)
        } catch (err: Throwable) {
            promise.reject(err)
        }

    }
}