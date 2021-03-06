package io.crossroad.rncardano

import org.json.JSONObject

object Native {
    init {
        System.loadLibrary("rust_native_cardano")
        this.initLibrary()
    }

    private external fun initLibrary()

    // HDWallet
    external fun hdWalletFromEnhancedEntropy(
            entropy: ByteArray, password: ByteArray
    ): Result<ByteArray>
    external fun hdWalletFromSeed(seed: ByteArray): Result<ByteArray>
    external fun hdWalletToPublic(pkey: ByteArray): Result<ByteArray>
    external fun hdWalletDerivePrivate(pkey: ByteArray, index: Int): Result<ByteArray>
    external fun hdWalletDerivePublic(pubKey: ByteArray, index: Int): Result<ByteArray>
    external fun hdWalletSign(pkey: ByteArray, data: ByteArray): Result<ByteArray>

    // Wallet
    external fun walletFromMasterKey(pkey: ByteArray): Result<JSONObject>
    external fun walletFromDaedalusMnemonic(mnemonics: String): Result<JSONObject>
    external fun walletNewAccount(params: JSONObject): Result<JSONObject>
    external fun walletGenerateAddresses(params: JSONObject, alen: Int): Result<JSONObject>
    external fun walletCheckAddress(address: String): Result<JSONObject>
    external fun walletSpend(params: JSONObject, ilen: Int, olen: Int): Result<JSONObject>
    external fun walletMove(params: JSONObject, ilen: Int): Result<JSONObject>

    // RandomAddressChecker
    external fun randomAddressCheckerNewChecker(pkey: String): Result<JSONObject>
    external fun randomAddressCheckerNewCheckerFromMnemonics(mnemonics: String): Result<JSONObject>
    external fun randomAddressCheckerCheckAddresses(params: JSONObject): Result<JSONObject>

    // PasswordProtect
    external fun passwordProtectEncryptWithPassword(
            password: ByteArray, salt: ByteArray, nonce: ByteArray, data: ByteArray
    ): Result<ByteArray>
    external fun passwordProtectDecryptWithPassword(
            password: ByteArray, data: ByteArray
    ): Result<ByteArray>
}