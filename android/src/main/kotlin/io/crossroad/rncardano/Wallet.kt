package io.crossroad.rncardano

import com.facebook.react.bridge.*
import org.json.JSONObject

class Wallet(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "CardanoWallet"

    @ReactMethod
    fun fromMasterKey(pkey: String, promise: Promise) {
        try {
            Native.walletFromMasterKey(Convert.bytes(pkey))
                    .map { Convert.map(it) }
                    .pour(promise)
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
            Native.walletNewAccount(params)
                    .map { Convert.map(it) }
                    .pour(promise)
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
            Native.walletGenerateAddresses(params)
                    .map { Convert.array(it) }
                    .pour(promise)
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }

    @ReactMethod
    fun checkAddress(address: String, promise: Promise) {
        try {
            Native.walletCheckAddress('"' + address + '"')
                    .pour(promise)
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
            Native.walletSpend(params, inputs.size(), outputs.size())
                    .map { Convert.map(it) }
                    .pour(promise)
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
            Native.walletMove(params, inputs.size())
                    .map { Convert.map(it) }
                    .pour(promise)
        } catch (err: Throwable) {
            promise.reject(err)
        }
    }
}