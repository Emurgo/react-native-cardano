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
    
    RNCBaseSafeOperation<NSDictionary*, NSDictionary*> *op1 = [RNCCSafeOperation new:^NSDictionary*(NSDictionary* params, char ** error) {
        NSData* entropy = params[@"entropy"];
        const char* cstr = [params[@"password"] UTF8String];
        NSMutableData* output = [NSMutableData dataWithLength:XPRV_SIZE];
        uintptr_t res = wallet_from_enhanced_entropy_safe([entropy bytes], [entropy length],
                                                          (const unsigned char*)cstr, strlen(cstr),
                                                          [output mutableBytes], error);
        return @{@"res": [NSNumber numberWithUnsignedLong:res], @"output": output};
    }];
    
    RNCBaseSafeOperation<NSDictionary*, NSString*> *op2 = [RNCSafeOperation new:^NSString*(NSDictionary* res, NSError ** error) {
        if ([res[@"res"] unsignedIntegerValue] == 0) {
            return [RNCConvert hexStringFromData:res[@"output"]];
        } else {
            *error = [NSError rustError:@"Unknown rust error"];
            return nil;
        }
    }];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:[RNCConvert dataFromHexString:entropy] forKey:@"entropy"];
    [params setObject:password forKey:@"password"];
    
    [[RNCSafeOperationCombined combine:op1 with:op2] exec:params andResolve:resolve orReject:reject];
}

@end
