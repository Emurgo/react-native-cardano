package io.crossroad.rncardano

import org.json.JSONArray
import org.json.JSONObject

object Native {
    init {
        System.loadLibrary("rust_native_cardano")
    }

    // HDWallet
    external fun hdWalletFromEnhancedEntropy(bytes: ByteArray, password: String): ByteArrayResult

    // Wallet
    external fun walletFromMasterKey(pkey: ByteArray): Result
    external fun walletNewAccount(params: JSONObject): Result
    external fun walletGenerateAddresses(params: JSONObject): Result
    external fun walletCheckAddress(address: String): Result
    external fun walletSpend(params: JSONObject, ilen: Int, olen: Int): Result
    external fun walletMove(params: JSONObject, ilen: Int): Result

    // RandomAddressChecker
    external fun randomAddressCheckerNewChecker(pkey: String): Result
    external fun randomAddressCheckerCheckAddresses(params: JSONObject): Result

    // PasswordProtect
    external fun passwordProtectEncryptWithPassword(
            password: String, salt: ByteArray, nonce: ByteArray, data: ByteArray
    ): ByteArrayResult
    external fun passwordProtectDecryptWithPassword(
            password: String, data: ByteArray
    ): ByteArrayResult
}