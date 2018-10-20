package io.crossroad.rncardano

import org.json.JSONArray
import org.json.JSONObject

object Native {
    init {
        System.loadLibrary("rust_native_cardano")
    }

    // HDWallet
    external fun hdWalletFromEnhancedEntropy(bytes: ByteArray, password: String): ByteArray

    // Wallet
    external fun walletFromEnhancedEntropy(pkey: ByteArray): JSONObject
    external fun walletNewAccount(params: JSONObject): JSONObject
    external fun walletGenerateAddresses(params: JSONObject): JSONArray
    external fun walletCheckAddress(address: String): Boolean
    external fun walletSpend(params: JSONObject, ilen: Int, olen: Int): JSONObject
    external fun walletMove(params: JSONObject, ilen: Int): JSONObject

    // RandomAddressChecker
    external fun randomAddressCheckerNewChecker(pkey: JSONArray): JSONObject
    external fun randomAddressCheckerCheckAddresses(params: JSONObject): JSONArray

    // PasswordProtect
    external fun passwordProtectEncryptWithPassword(
            password: String, salt: ByteArray, nonce: ByteArray, data: ByteArray
    ): ByteArray
    external fun passwordProtectDecryptWithPassword(password: String, data: ByteArray): ByteArray
}