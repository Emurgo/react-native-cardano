package io.crossroad.rncardano

import org.json.JSONArray
import org.json.JSONObject

object Native {
    init {
        System.loadLibrary("rust_native_cardano")
    }

    // HDWallet
    external fun hdWallet_fromEnhancedEntropy(bytes: ByteArray, password: String): ByteArray

    // Wallet
    external fun wallet_fromEnhancedEntropy(pkey: ByteArray): JSONObject
    external fun wallet_newAccount(params: JSONObject): JSONObject

    // RandomAddressChecker
    external fun randomAddressChecker_newChecker(pkey: JSONArray): JSONObject
    external fun randomAddressChecker_checkAddresses(params: JSONObject): JSONArray

    // PasswordProtect
    external fun passwordProtect_encryptWithPassword(
            password: String, salt: ByteArray, nonce: ByteArray, data: ByteArray
    ): ByteArray?
    external fun passwordProtect_decryptWithPassword(password: String, data: ByteArray): ByteArray?
}