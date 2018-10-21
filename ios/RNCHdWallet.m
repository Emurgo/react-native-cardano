//
//  HdWallet.m
//  RNCardano
//
//  Created by Yehor Popovych on 10/21/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import "RNCHdWallet.h"
#import "RNCConvert.h"
#import "RNCNative.h"

@implementation RNCHdWallet

RCT_EXPORT_MODULE(CardanoHdWallet)

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(fromEnhancedEntropy:(NSString *)entropy withPassword:(NSString *)password resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    
    NSData* entropyBytes = [RNCConvert dataFromHexString:entropy];
    const char* cstr = [password cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData* output = [NSMutableData dataWithLength:XPRV_SIZE];
    
    uintptr_t res = wallet_from_enhanced_entropy(
        [entropyBytes bytes], [entropyBytes length],
        (const unsigned char* )cstr, strlen(cstr),
        [output mutableBytes]
    );
    
    if (res == 0) {
        resolve([RNCConvert hexStringFromData:output]);
    } else {
        reject([NSString stringWithFormat:@"%u", (uint)res], @"Rust error", nil);
    }
}

@end
