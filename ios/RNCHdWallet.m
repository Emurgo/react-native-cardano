//
//  HdWallet.m
//  RNCardano
//
//  Created by Yehor Popovych on 10/21/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import "RNCHdWallet.h"
#import "RNCConvert.h"
#import <rust_native_cardano.h>
#import "RNCSafeOperation.h"

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
    
    RNCSafeOperation *operation = [RNCCSafeOperation new:^id (id param, char ** error) {
        uintptr_t res = wallet_from_enhanced_entropy_safe([entropyBytes bytes], [entropyBytes length],
                                                          (const unsigned char* )cstr, strlen(cstr),
                                                          [output mutableBytes], error);
        return [NSNumber numberWithUnsignedLong:res];
    }];
    
    operation = [operation andThen:[RNCSafeOperation new:^id(id res, NSError ** error) {
        if ([res unsignedIntegerValue] == 0) {
            return [RNCConvert hexStringFromData:output];
        } else {
            *error = [NSError rustError:@"Unknown rust error"];
            return nil;
        }
    }]];
    
    [operation execAndResolve:resolve orReject:reject];
}

@end
