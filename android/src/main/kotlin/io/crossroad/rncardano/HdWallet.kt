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
                .pour(promise)
    }

    @ReactMethod
    fun fromSeed(seed: String, promise: Promise) {
        Native.hdWalletFromSeed(Convert.bytes(seed))
                .map { Convert.string(it) }
                .pour(promise)
    }

    @ReactMethod
    fun toPublic(xprv: String, promise: Promise) {
        Native.hdWalletToPublic(Convert.bytes(xprv))
                .map { Convert.string(it) }
                .pour(promise)
    }

    @ReactMethod
    fun derivePrivate(xprv: String, index: Int, promise: Promise) {
        Native.hdWalletDerivePrivate(Convert.bytes(xprv), index)
                .map { Convert.string(it) }
                .pour(promise)
    }

    @ReactMethod
    fun derivePublic(xpub: String, index: Int, promise: Promise) {
        Native.hdWalletDerivePublic(Convert.bytes(xpub), index)
                .map { Convert.string(it) }
                .pour(promise)
    }

    @ReactMethod
    fun sign(xprv: String, data: String, promise: Promise) {
        Native.hdWalletSign(Convert.bytes(xprv), Convert.bytes(data))
                .map { Convert.string(it) }
                .pour(promise)
    }
}