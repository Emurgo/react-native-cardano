package io.crossroad.rncardano

import com.facebook.react.bridge.*
import org.json.JSONObject

class RandomAddressChecker(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "CardanoRandomAddressChecker"

    @ReactMethod
    fun newChecker(pkey: ReadableArray): ReadableMap {
        val param = Convert.json(pkey)
        return Convert.map(Native.randomAddressCheckerNewChecker(param))
    }

    @ReactMethod
    fun checkAddresses(checker: ReadableMap, addresses: ReadableArray): ReadableArray {
        val params = JSONObject()
        params.put("checker", Convert.json(checker))
        params.put("addresses", Convert.json(addresses))
        return Convert.array(Native.randomAddressCheckerCheckAddresses(params))
    }
}