#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_REMAP_MODULE(CardanoWallet, Wallet, NSObject)

RCT_EXTERN_METHOD(fromMasterKey:(NSArray*)pkey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

@end
