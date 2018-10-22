package io.crossroad.rncardano

import com.facebook.react.bridge.*
import org.json.JSONArray
import org.json.JSONObject

class RandomAddressChecker(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "CardanoRandomAddressChecker"

    @ReactMethod
    fun newChecker(pkey: String, promise: Promise) {
        Native.randomAddressCheckerNewChecker('"'+pkey + '"')
                .map { Convert.map(it as JSONObject) }
                .finish(promise)
    }

    @ReactMethod
    fun checkAddresses(checker: ReadableMap, addresses: ReadableArray, promise: Promise) {
        val params = JSONObject()
        params.put("checker", Convert.json(checker))
        params.put("addresses", Convert.json(addresses))
        Native.randomAddressCheckerCheckAddresses(params)
                .map { Convert.array(it as JSONArray) }
                .finish(promise)
    }
}