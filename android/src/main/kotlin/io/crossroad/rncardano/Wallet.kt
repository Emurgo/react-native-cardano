package io.crossroad.rncardano

import com.facebook.react.bridge.*
import org.json.JSONObject

class Wallet(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "CardanoWallet"

    @ReactMethod
    fun fromMasterKey(pkey: ReadableArray, promise: Promise) {
        try {
            promise.resolve(Convert.map(Native.walletFromEnhancedEntropy(Convert.bytes(pkey))))
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }

    @ReactMethod
    fun newAccount(wallet: ReadableMap, accountIndex: Int, promise: Promise) {
        try {
            val params = JSONObject()
            params.put("wallet", Convert.json(wallet))
            params.put("account", accountIndex)
            promise.resolve(Convert.map(Native.walletNewAccount(params)))
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }
}