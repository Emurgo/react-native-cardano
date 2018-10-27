package io.crossroad.rncardano

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise

class HdWallet(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "CardanoHdWallet"

    @ReactMethod
    fun fromEnhancedEntropy(entropy: String, password: String, promise: Promise) {
        try {
            Native.hdWalletFromEnhancedEntropy(Convert.bytes(entropy), Convert.bytes(password))
                    .map { Convert.string(it) }
                    .pour(promise)
        } catch (err: Throwable) {
            promise.reject(err)
        }

    }

    @ReactMethod
    fun fromSeed(seed: String, promise: Promise) {
        try {
            Native.hdWalletFromSeed(Convert.bytes(seed))
                    .map { Convert.string(it) }
                    .pour(promise)
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }

    @ReactMethod
    fun toPublic(xprv: String, promise: Promise) {
        try {
            Native.hdWalletToPublic(Convert.bytes(xprv))
                    .map { Convert.string(it) }
                    .pour(promise)
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }

    @ReactMethod
    fun derivePrivate(xprv: String, index: Int, promise: Promise) {
        try {
            Native.hdWalletDerivePrivate(Convert.bytes(xprv), index)
                    .map { Convert.string(it) }
                    .pour(promise)
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }

    @ReactMethod
    fun derivePublic(xpub: String, index: Int, promise: Promise) {
        try {
            Native.hdWalletDerivePublic(Convert.bytes(xpub), index)
                    .map { Convert.string(it) }
                    .pour(promise)
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }

    @ReactMethod
    fun sign(xprv: String, data: String, promise: Promise) {
        try {
            Native.hdWalletSign(Convert.bytes(xprv), Convert.bytes(data))
                    .map { Convert.string(it) }
                    .pour(promise)
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }
}