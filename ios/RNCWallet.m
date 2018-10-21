//
//  Wallet.m
//  RNCardano
//
//  Created by Yehor Popovych on 10/21/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import "RNCWallet.h"
#import "RNCNative.h"
#import "RNCConvert.h"

@implementation RNCWallet

RCT_EXPORT_MODULE(CardanoWallet)

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(fromMasterKey:(NSArray<NSNumber *>*)pkey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    
    NSData* pkeyBytes = [RNCConvert dataFromArray:pkey];
    NSMutableData* output = [NSMutableData dataWithLength:MAX_OUTPUT_SIZE];
    
    int32_t rsz = xwallet_from_master_key(
        [pkeyBytes bytes],
        [output mutableBytes]
    );
    
    if (rsz > 0) {
        NSError* error = nil;
        NSDictionary* response = [RNCConvert dictionaryFromJsonData:[output subdataWithRange:NSMakeRange(0, rsz)] error:&error];
        if (error == nil) {
            resolve(response);
        } else {
            reject([NSString stringWithFormat:@"%i", rsz], @"JSON parsin error", error);
        }
    } else {
        reject([NSString stringWithFormat:@"%i", rsz], @"Rust error", nil);
    }
}

@end
