package io.crossroad.rncardano

import com.facebook.react.bridge.*
import org.json.JSONObject

class RandomAddressChecker(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "CardanoRandomAddressChecker"

    @ReactMethod
    fun newChecker(pkey: ReadableArray, promise: Promise) {
        try {
            val param = Convert.json(pkey)
            promise.resolve(Convert.map(Native.randomAddressCheckerNewChecker(param)))
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
            promise.resolve(Convert.array(Native.randomAddressCheckerCheckAddresses(params)))
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }
}