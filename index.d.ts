declare namespace RNCardano {
  export type HexString = string;
  
  export namespace HdWallet {
    export type XPrv = HexString;
    export type XPub = HexString;
    
    // Generate an eXtended private key from the given entropy and the given password.
    export function fromEnhancedEntropy(entropy: HexString, password: string): Promise<XPrv>;
    
    // Create a private key from the given seed.
    export function fromSeed(seed: HexString): Promise<XPrv>;
    
    // Get a public key for the private one.
    export function toPublic(xprv: XPrv): Promise<XPub>;
    
    // Create a derived private key with an index.
    export function derivePrivate(xprv: XPrv, index: number): Promise<XPrv>;
    
    // Create a derived public key with an index.
    export function derivePublic(xpub: XPub, index: number): Promise<XPub>;
    
    // Sign the given message with the private key.
    export function sign(xprv: XPrv, msg: HexString): Promise<HexString>;
  }
    
  export namespace Wallet {
    export type WalletObj = {
      root_cached_key: HdWallet.XPrv;
      derivation_scheme: string;
      selection_policy: string;
      config: { protocol_magic: number };
    };
    export type DaedalusWalletObj = WalletObj;
    export type AccountObj = {
      root_cached_key: HdWallet.XPrv;
      derivation_scheme: string;
    };
    export type Address = string;
    export type AddressType = "Internal" | "External";
    export type SpendInputObj = {
      ptr: { id: string; index: number };
      value: OutputObj;
      addressing: { account: number; change: number; index: number };
    };
    export type MoveInputObj = {
      ptr: { id: string; index: number };
      value: string;
      addressing: [number, number];
    }
    export type OutputObj = { address: string; value: string };
    export type TransactionObj = {
      cbor_encoded_tx: HexString;
      change_used: boolean;
      fee: string;
    };
    
    // Create a wallet object from the given seed.
    export function fromMasterKey(xprv: HdWallet.XPrv): Promise<WalletObj>;
    
    // Create a daedalus wallet object from the given seed.
    export function fromDaedalusMnemonic(mnemonics: string): Promise<DaedalusWalletObj>;
    
    // Create an account, for public key derivation (using bip44 model).
    export function newAccount(wallet: WalletObj, account: number): Promise<AccountObj>;
    
    // Generate addresses for the given wallet.
    export function generateAddresses(
      account: AccountObj, type: AddressType, indices: Array<number>
    ): Promise<Array<Address>>;

    // Check if the given hexadecimal string is a valid Cardano Extended Address.
    export function checkAddress(address: HexString): Promise<boolean>;
    
    // Generate a ready to send, signed, transaction.
    export function spend(
      wallet: WalletObj, inputs: Array<SpendInputObj>, outputs: Array<OutputObj>, change_addr: Address
    ): Promise<TransactionObj>;
    
    // Move all UTxO to a single address.
    export function move(
      wallet: DaedalusWalletObj, inputs: Array<MoveInputObj>, output: Address
    ): Promise<TransactionObj>;
  }
    
  export namespace RandomAddressChecker {
    export type AddressCheckerObj = object;
    
    // Create a random address checker, this will allow validating.
    export function newChecker(xprv: HdWallet.XPrv): Promise<AddressCheckerObj>;
    
    // Create a random address checker from daedalus mnemonics.
    export function newCheckerFromMnemonics(mnemonics: string): Promise<AddressCheckerObj>;
    
    // Check if the given addresses are valid.
    export function checkAddresses(
      checker: AddressCheckerObj, addresses: Array<Wallet.Address>
    ): Promise<Array<{ address: Wallet.Address; addressing: [number, number] }>>;
  }
    
  export namespace PasswordProtect {
    // Encrypt the given data with the password, salt and nonce.
    export function encryptWithPassword(
      password: string, salt: HexString, nonce: HexString, data: HexString
    ): Promise<HexString>;
    
    // Decrypt the given data with the password.
    export function decryptWithPassword(password: string, data: HexString): Promise<HexString>;
  }
}
export = RNCardano;