package io.crossroad.rncardano

import com.facebook.react.bridge.*
import org.json.JSONObject

class RandomAddressChecker(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "CardanoRandomAddressChecker"

    @ReactMethod
    fun newChecker(pkey: String, promise: Promise) {
        try {
            Native.randomAddressCheckerNewChecker("\"$pkey\"")
                    .map { Convert.result(it) }
                    .pour(promise)
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }

    @ReactMethod
    fun newCheckerFromMnemonics(mnemonics: String, promise: Promise) {
        try {
            Native.randomAddressCheckerNewCheckerFromMnemonics("\"$mnemonics\"")
                    .map { Convert.result(it) }
                    .pour(promise)
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }

    @ReactMethod
    fun checkAddresses(checker: ReadableMap, addresses: ReadableArray, promise: Promise) {
        try {
            val params = JSONObject()
            params.put("checker", Convert.json(checker))
            params.put("addresses", Convert.json(addresses))
            Native.randomAddressCheckerCheckAddresses(params)
                    .map { Convert.arrayResult(it) }
                    .pour(promise)
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }
}