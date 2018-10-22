//
//  Wallet.m
//  RNCardano
//
//  Created by Yehor Popovych on 10/21/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import "RNCWallet.h"
#import <rust_native_cardano.h>
#import "RNCConvert.h"
#import "RNCSafeOperation.h"

@implementation RNCWallet

RCT_EXPORT_MODULE(CardanoWallet)

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(fromMasterKey:(NSString *)pkey
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    NSData* pkeyBytes = [RNCConvert dataFromHexString:pkey];
    NSMutableData* output = [NSMutableData dataWithLength:MAX_OUTPUT_SIZE];
    
    RNCSafeOperation* operation = [RNCCSafeOperation new:^id (id param, char **error) {
        int32_t rsz = xwallet_from_master_key_safe([pkeyBytes bytes],
                                                   [output mutableBytes],
                                                   error);
        return [NSNumber numberWithInteger:rsz];
    }];
    
    operation = [operation andThen:[RNCSafeOperation new:^id (id param, NSError ** error) {
        NSInteger rsz = [param integerValue];
        if (rsz > 0) {
            return [RNCConvert dictionaryFromJsonData:[output subdataWithRange:NSMakeRange(0, rsz)] error:error];
        }
        return nil;
    }]];
    
    [operation execAndResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(newAccount:(NSDictionary *)wallet
                  withIndex:(NSNumber *)index
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:wallet forKey:@"wallet"];
    [params setObject:index forKey:@"account"];
    
    NSMutableData* output = [NSMutableData dataWithLength:MAX_OUTPUT_SIZE];
    
    RNCSafeOperation* operation = [RNCSafeOperation new:^id (id param, NSError ** error) {
        return [RNCConvert jsonDataFromDictionary:params error:error];
    }];
    
    operation = [operation andThen:[RNCCSafeOperation new:^id (id param, char **error) {
        int32_t rsz = xwallet_account_safe([param bytes],
                                           [param length],
                                           [output mutableBytes],
                                           error);
        return [NSNumber numberWithInteger:rsz];
    }]];
    
    operation = [operation andThen:[RNCSafeOperation new:^id (id param, NSError ** error) {
        NSInteger rsz = [param integerValue];
        if (rsz > 0) {
            return [RNCConvert dictionaryFromJsonData:[output subdataWithRange:NSMakeRange(0, rsz)] error:error];
        }
        return nil;
    }]];
}

RCT_EXPORT_METHOD(generateAddresses:(NSDictionary *)account
                  withType:(NSString*) type
                  forIndices:(NSArray<NSNumber *> *)indices
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:account forKey:@"account"];
    [params setObject:type forKey:@"address_type"];
    [params setObject:indices forKey:@"indices"];
    
    NSMutableData* output = [NSMutableData dataWithLength:MAX_OUTPUT_SIZE];
    
    RNCSafeOperation* operation = [RNCSafeOperation new:^id (id param, NSError ** error) {
        return [RNCConvert jsonDataFromDictionary:params error:error];
    }];
    
    operation = [operation andThen:[RNCCSafeOperation new:^id (id param, char **error) {
        int32_t rsz = xwallet_addresses_safe([param bytes],
                                             [param length],
                                             [output mutableBytes],
                                             error);
        return [NSNumber numberWithInteger:rsz];
    }]];
    
    operation = [operation andThen:[RNCSafeOperation new:^id (id param, NSError ** error) {
        NSInteger rsz = [param integerValue];
        if (rsz > 0) {
            return [RNCConvert arrayFromJsonData:[output subdataWithRange:NSMakeRange(0, rsz)] error:error];
        }
        return nil;
    }]];
    
    [operation execAndResolve:resolve orReject:reject];
}



@end
