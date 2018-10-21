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
    char* error = NULL;
    
    uintptr_t res = wallet_from_enhanced_entropy_safe(
        [entropyBytes bytes], [entropyBytes length],
        (const unsigned char* )cstr, strlen(cstr),
        [output mutableBytes], &error
    );
    
    if (error != NULL) {
        reject([NSString stringWithFormat:@"%u", (uint)res],
               [NSString stringWithFormat:@"Rust error: %s", error],
               nil);
        dealloc_string(error);
    } else {
        if (res == 0) {
            resolve([RNCConvert hexStringFromData:output]);
        } else {
            reject([NSString stringWithFormat:@"%u", (uint)res],
                   @"Unknown rust error", nil);
        }
    }
}

@end
