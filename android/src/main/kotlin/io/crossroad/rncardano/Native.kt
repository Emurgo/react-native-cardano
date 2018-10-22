package io.crossroad.rncardano

import org.json.JSONArray
import org.json.JSONObject

object Native {
    init {
        System.loadLibrary("rust_native_cardano")
        this.initLibrary()
    }

    private external fun initLibrary()

    // HDWallet
    external fun hdWalletFromEnhancedEntropy(entropy: ByteArray, password: String): Result<ByteArray>
    external fun hdWalletFromSeed(seed: ByteArray): Result<ByteArray>
    external fun hdWalletToPublic(pkey: ByteArray): Result<ByteArray>
    external fun hdWalletDerivePrivate(pkey: ByteArray, index: Int): Result<ByteArray>
    external fun hdWalletDerivePublic(pubKey: ByteArray, index: Int): Result<ByteArray>
    external fun hdWalletSign(pkey: ByteArray, data: ByteArray): Result<ByteArray>

    // Wallet
    external fun walletFromMasterKey(pkey: ByteArray): Result<JSONObject>
    external fun walletNewAccount(params: JSONObject): Result<JSONObject>
    external fun walletGenerateAddresses(params: JSONObject): Result<JSONArray>
    external fun walletCheckAddress(address: String): Result<Boolean>
    external fun walletSpend(params: JSONObject, ilen: Int, olen: Int): Result<JSONObject>
    external fun walletMove(params: JSONObject, ilen: Int): Result<JSONObject>

    // RandomAddressChecker
    external fun randomAddressCheckerNewChecker(pkey: String): Result<JSONObject>
    external fun randomAddressCheckerCheckAddresses(params: JSONObject): Result<JSONArray>

    // PasswordProtect
    external fun passwordProtectEncryptWithPassword(
            password: String, salt: ByteArray, nonce: ByteArray, data: ByteArray
    ): Result<ByteArray>
    external fun passwordProtectDecryptWithPassword(
            password: String, data: ByteArray
    ): Result<ByteArray>
}