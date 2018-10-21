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

RCT_EXPORT_METHOD(fromMasterKey:(NSString *)pkey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    
    NSData* pkeyBytes = [RNCConvert dataFromHexString:pkey];
    NSMutableData* output = [NSMutableData dataWithLength:MAX_OUTPUT_SIZE];
    
    char* error = NULL;
    int32_t rsz = xwallet_from_master_key_safe(
        [pkeyBytes bytes],
        [output mutableBytes],
        &error
    );
    
    if (error != NULL) {
        reject([NSString stringWithFormat:@"%i", rsz],
               [NSString stringWithFormat:@"Rust error: %s", error],
               nil);
        dealloc_string(error);
    } else {
        if (rsz > 0) {
            NSError* error = nil;
            NSDictionary* response = [RNCConvert dictionaryFromJsonData:[output subdataWithRange:NSMakeRange(0, rsz)] error:&error];
            if (error == nil) {
                resolve(response);
            } else {
                reject([NSString stringWithFormat:@"%i", rsz], @"JSON parsing error", error);
            }
        } else {
            reject([NSString stringWithFormat:@"%i", rsz], @"Unknown rust error", nil);
        }
    }
}

@end
