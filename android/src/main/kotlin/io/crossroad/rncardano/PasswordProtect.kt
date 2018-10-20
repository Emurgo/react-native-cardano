package io.crossroad.rncardano

import com.facebook.react.bridge.*

class PasswordProtect(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "CardanoPasswordProtect"

    @ReactMethod
    fun encryptWithPassword(
            password: String, salt: ReadableArray, nonce: ReadableArray, data: ReadableArray
    ): ReadableArray? {
        val encrypted = Native.passwordProtectEncryptWithPassword(
                password,
                Convert.bytes(salt),
                Convert.bytes(nonce),
                Convert.bytes(data)
        )
        return encrypted?.let { Convert.array(it) }
    }

    @ReactMethod
    fun decryptWithPassword(password: String, data: ReadableArray): ReadableArray? {
        val decrypted = Native.passwordProtectDecryptWithPassword(password, Convert.bytes(data))
        return decrypted?.let { Convert.array(it) }
    }
}