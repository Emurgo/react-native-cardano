package io.crossroad.rncardano

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise

class HdWallet(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "CardanoHdWallet"

    @ReactMethod
    fun fromEnhancedEntropy(entropy: String, password: String, promise: Promise) {
        Native.hdWalletFromEnhancedEntropy(Convert.bytes(entropy), password)
                .map { Convert.string(it) }
                .finish(promise)
    }
}