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

    @ReactMethod
    fun generateAddresses(
            account: ReadableMap, type: String, indicies: ReadableArray, promise: Promise
    ) {
        try {
            val params = JSONObject()
            params.put("account", Convert.json(account))
            params.put("address_type", type)
            params.put("indices", Convert.json(indicies))
            promise.resolve(Convert.array(Native.walletGenerateAddresses(params)))
        } catch (err: Throwable) {
            promise.reject(err)
        }

    }

    @ReactMethod
    fun checkAddress(address: String, promise: Promise) {
        try {
            promise.resolve(Native.walletCheckAddress('"' + address + '"'))
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }

    @ReactMethod
    fun spend(
            wallet: ReadableMap, inputs: ReadableArray,
            outputs: ReadableArray, changeAddress: String, promise: Promise
    ) {
        try {
            val params = JSONObject()
            params.put("wallet", Convert.json(wallet))
            params.put("inputs", Convert.json(inputs))
            params.put("outputs", Convert.json(outputs))
            params.put("change_addr", changeAddress)
            promise.resolve(Convert.map(Native.walletSpend(params, inputs.size(), outputs.size())))
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }

    @ReactMethod
    fun move(
            wallet: ReadableMap, inputs: ReadableArray,
            output: String, promise: Promise
    ) {
        try {
            val params = JSONObject()
            params.put("wallet", Convert.json(wallet))
            params.put("inputs", Convert.json(inputs))
            params.put("output", output)
            promise.resolve(Convert.map(Native.walletMove(params, inputs.size())))
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }
}