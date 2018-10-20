
import { NativeModules } from 'react-native';

const { CardanoWallet, CardanoHdWallet, CardanoPasswordProtect, CardanoRandomAddressChecker } = NativeModules;

export {
  CardanoWallet as Wallet,
  CardanoHdWallet as HdWallet,
  CardanoRandomAddressChecker as RandomAddressChecker,
  CardanoPasswordProtect as PasswordProtect
};
