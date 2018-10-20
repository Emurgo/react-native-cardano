package io.crossroad.rncardano

import com.facebook.react.bridge.*
import org.json.JSONObject

class WalletModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "CardanoWallet"

    @ReactMethod
    fun fromMasterKey(pkey: ReadableArray): ReadableMap {
        return Convert.map(Native.wallet_fromEnhancedEntropy(Convert.bytes(pkey)))
    }

    @ReactMethod
    fun newAccount(wallet: ReadableMap, accountIndex: Int): ReadableMap {
        val params = JSONObject()
        params.put("wallet", Convert.json(wallet))
        params.put("account", accountIndex)
        return Convert.map(Native.wallet_newAccount(params))
    }
}