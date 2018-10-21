package io.crossroad.rncardano

import com.facebook.react.bridge.*
import org.json.JSONArray
import org.json.JSONObject

class Wallet(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "CardanoWallet"

    @ReactMethod
    fun fromMasterKey(pkey: String, promise: Promise) {
        Native.walletFromMasterKey(Convert.bytes(pkey))
                .map { Convert.map(it as JSONObject) }
                .finish(promise)
    }

    @ReactMethod
    fun newAccount(wallet: ReadableMap, accountIndex: Int, promise: Promise) {
        val params = JSONObject()
        params.put("wallet", Convert.json(wallet))
        params.put("account", accountIndex)
        Native.walletNewAccount(params)
                .map { Convert.map(it as JSONObject) }
                .finish(promise)
    }

    @ReactMethod
    fun generateAddresses(
            account: ReadableMap, type: String, indicies: ReadableArray, promise: Promise
    ) {
        val params = JSONObject()
        params.put("account", Convert.json(account))
        params.put("address_type", type)
        params.put("indices", Convert.json(indicies))
        Native.walletGenerateAddresses(params)
                .map { Convert.array(it as JSONArray) }
                .finish(promise)
    }

    @ReactMethod
    fun checkAddress(address: String, promise: Promise) {
        Native.walletCheckAddress('"' + address + '"')
                .finish(promise)
    }

    @ReactMethod
    fun spend(
            wallet: ReadableMap, inputs: ReadableArray,
            outputs: ReadableArray, changeAddress: String, promise: Promise
    ) {
        val params = JSONObject()
        params.put("wallet", Convert.json(wallet))
        params.put("inputs", Convert.json(inputs))
        params.put("outputs", Convert.json(outputs))
        params.put("change_addr", changeAddress)
        Native.walletSpend(params, inputs.size(), outputs.size())
                .map { Convert.map(it as JSONObject) }
                .finish(promise)
    }

    @ReactMethod
    fun move(
            wallet: ReadableMap, inputs: ReadableArray,
            output: String, promise: Promise
    ) {
        val params = JSONObject()
        params.put("wallet", Convert.json(wallet))
        params.put("inputs", Convert.json(inputs))
        params.put("output", output)
        Native.walletMove(params, inputs.size())
                .map { Convert.map(it as JSONObject) }
                .finish(promise)
    }
}