package io.crossroad.rncardano

import com.facebook.react.bridge.*

class PasswordProtect(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "CardanoPasswordProtect"

    @ReactMethod
    fun encryptWithPassword(
            password: String, salt: ReadableArray, nonce: ReadableArray,
            data: ReadableArray, promise: Promise
    ) {
        try {
            val encrypted = Native.passwordProtectEncryptWithPassword(
                    password,
                    Convert.bytes(salt),
                    Convert.bytes(nonce),
                    Convert.bytes(data)
            )
            promise.resolve(Convert.array(encrypted))
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }

    @ReactMethod
    fun decryptWithPassword(password: String, data: ReadableArray, promise: Promise) {
        try {
            val decrypted = Native.passwordProtectDecryptWithPassword(
                    password, Convert.bytes(data)
            )
            promise.resolve(Convert.array(decrypted))
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }
}