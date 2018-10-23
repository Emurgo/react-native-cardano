package io.crossroad.rncardano

import com.facebook.react.bridge.*

class PasswordProtect(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "CardanoPasswordProtect"

    @ReactMethod
    fun encryptWithPassword(
            password: String, salt: String, nonce: String,
            data: String, promise: Promise
    ) {
        try {
            Native.passwordProtectEncryptWithPassword(
                    password,
                    Convert.bytes(salt),
                    Convert.bytes(nonce),
                    Convert.bytes(data)
            )
                    .map { Convert.string(it) }
                    .pour(promise)
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }

    @ReactMethod
    fun decryptWithPassword(password: String, data: String, promise: Promise) {
        try {
            Native.passwordProtectDecryptWithPassword(
                    password, Convert.bytes(data)
            )
                    .map { Convert.string(it) }
                    .pour(promise)
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }
}