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

RCT_EXPORT_METHOD(fromMasterKey:(nonnull NSString *)pkey
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSData*, NSDictionary*> *op1 = [RNCCSafeOperation new:^NSDictionary*(NSData* pkey, char **error) {
        CHECK_HAS_LENGTH_OR_CERROR(pkey, *error, "pkey");
        NSMutableData* output = [NSMutableData dataWithLength:MAX_OUTPUT_SIZE];
        int32_t rsz = xwallet_from_master_key_safe([pkey bytes],
                                                   [output mutableBytes],
                                                   error);
        return @{@"size": [NSNumber numberWithInteger:rsz], @"output": output};
    }];
    
    RNCBaseSafeOperation<NSDictionary*, NSDictionary*> *op2 = [RNCSafeOperation new:^NSDictionary*(NSDictionary* params, NSError ** error) {
        NSInteger rsz = [params[@"size"] integerValue];
        if (rsz > 0) {
            return [RNCConvert dictionaryResponseFromJsonData:[params[@"output"] subdataWithRange:NSMakeRange(0, rsz)] error:error];
        } else {
            *error = [NSError rustError:[NSString stringWithFormat: @"Wrong response size: %li", (long)rsz]];
        }
        return nil;
    }];
    
    [[RNCSafeOperationCombined combine:op1 with:op2] exec:[RNCConvert dataFromEncodedString:pkey] andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(newAccount:(nonnull NSDictionary *)wallet
                  withIndex:(nonnull NSNumber *)index
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSDictionary*, NSData*>* op1 = [RNCSafeOperation new:^NSData*(NSDictionary* params, NSError ** error) {
        return [RNCConvert jsonDataFromDictionary:params error:error];
    }];
    
    RNCBaseSafeOperation<NSData*, NSDictionary*>* op2 = [RNCCSafeOperation new:^NSDictionary*(NSData* input, char **error) {
        NSMutableData* output = [NSMutableData dataWithLength:MAX_OUTPUT_SIZE];
        int32_t rsz = xwallet_account_safe([input bytes],
                                           [input length],
                                           [output mutableBytes],
                                           error);
        return @{@"size": [NSNumber numberWithInteger:rsz], @"output": output};
    }];
    
    RNCBaseSafeOperation<NSDictionary*, NSDictionary*> *op3 = [RNCSafeOperation new:^NSDictionary*(NSDictionary* params, NSError **error) {
        NSInteger rsz = [params[@"size"] integerValue];
        if (rsz > 0) {
            return [RNCConvert dictionaryResponseFromJsonData:[params[@"output"] subdataWithRange:NSMakeRange(0, rsz)] error:error];
        } else {
            *error = [NSError rustError:[NSString stringWithFormat: @"Wrong response size: %li", (long)rsz]];
        }
        return nil;
    }];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:wallet forKey:@"wallet"];
    [params setObject:index forKey:@"account"];
    
    [[RNCSafeOperationCombined combine:[RNCSafeOperationCombined combine:op1 with:op2] with:op3] exec:params andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(generateAddresses:(nonnull NSDictionary *)account
                  withType:(nonnull NSString*) type
                  forIndices:(nonnull NSArray<NSNumber *> *)indices
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSDictionary*, NSData*>* op1 = [RNCSafeOperation new:^NSData*(NSDictionary* params, NSError ** error) {
        return [RNCConvert jsonDataFromDictionary:params error:error];
    }];
    
    RNCBaseSafeOperation<NSData*, NSDictionary*>* op2 = [RNCCSafeOperation new:^NSDictionary*(NSData* input, char **error) {
        NSMutableData* output = [NSMutableData dataWithLength:MAX_OUTPUT_SIZE];
        int32_t rsz = xwallet_addresses_safe([input bytes],
                                             [input length],
                                             [output mutableBytes],
                                             error);
        return @{@"size": [NSNumber numberWithInteger:rsz], @"output": output};
    }];
    
    RNCBaseSafeOperation<NSDictionary*, NSArray*> *op3 = [RNCSafeOperation new:^NSArray*(NSDictionary* param, NSError **error) {
        NSInteger rsz = [param[@"size"] integerValue];
        if (rsz > 0) {
            return [RNCConvert arrayResponseFromJsonData:[param[@"output"] subdataWithRange:NSMakeRange(0, rsz)] error:error];
        } else {
            *error = [NSError rustError:[NSString stringWithFormat: @"Wrong response size: %li", (long)rsz]];
        }
        return nil;
    }];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:account forKey:@"account"];
    [params setObject:type forKey:@"address_type"];
    [params setObject:indices forKey:@"indices"];
    
    [[RNCSafeOperationCombined combine:[RNCSafeOperationCombined combine:op1 with:op2] with:op3] exec:params andResolve:resolve orReject:reject];
}


RCT_EXPORT_METHOD(checkAddress:(nonnull NSString *)address
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSString*, NSDictionary*>* op1 = [RNCCSafeOperation new:^NSDictionary*(NSString* address, char **error) {
        CHECK_HAS_LENGTH_OR_CERROR(address, *error, "address");
        NSData* input = [RNCConvert UTF8BytesFromString:[NSString stringWithFormat:@"\"%@\"", address]];
        NSMutableData* output = [NSMutableData dataWithLength:MAX_OUTPUT_SIZE];
        int32_t rsz = xwallet_checkaddress_safe([input bytes],
                                                [input length],
                                                [output mutableBytes],
                                                error);
        return @{@"size": [NSNumber numberWithInteger:rsz], @"output": output};
    }];
    
    RNCBaseSafeOperation<NSDictionary*, NSNumber*> *op2 = [RNCSafeOperation new:^NSNumber*(NSDictionary* params, NSError **error) {
        NSInteger rsz = [params[@"size"] integerValue];
        if (rsz > 0) {
            NSNumber* res = [RNCConvert numberResponseFromJsonData:[params[@"output"] subdataWithRange:NSMakeRange(0, rsz)] error:error];
            if (*error != nil) {
                *error = nil;
                return [NSNumber numberWithBool:NO];
            }
            return res;
        } else {
            *error = [NSError rustError:[NSString stringWithFormat: @"Wrong response size: %li", (long)rsz]];
        }
        return nil;
    }];
    
    [[RNCSafeOperationCombined combine:op1 with:op2] exec:address andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(spend:(nonnull NSDictionary *)wallet
                  withInputs:(nonnull NSArray*)inputs
                  andOutputs:(nonnull NSArray*)outputs
                  andChangeAddress:(nonnull NSString*)change
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSDictionary*, NSDictionary*>* op1 = [RNCSafeOperation new:^NSDictionary*(NSDictionary* params, NSError ** error) {
        return @{@"data": [RNCConvert jsonDataFromDictionary:params error:error],
                 @"ilen": [NSNumber numberWithUnsignedInteger:[params[@"inputs"] count]],
                 @"olen": [NSNumber numberWithUnsignedInteger:[params[@"outputs"] count]]};
    }];
    
    RNCBaseSafeOperation<NSData*, NSDictionary*>* op2 = [RNCCSafeOperation new:^NSDictionary*(NSDictionary* params, char **error) {
        NSData* input = params[@"data"];
        CHECK_NON_NULL_OR_CERROR(params[@"ilen"], *error, "inputs");
        CHECK_NON_NULL_OR_CERROR(params[@"olen"], *error, "outputs");
        NSUInteger ilen = [params[@"ilen"] unsignedIntegerValue];
        NSUInteger olen = [params[@"olen"] unsignedIntegerValue];
        NSUInteger OUTPUT_SIZE = (ilen + olen + 1) * 4096;
        NSMutableData* output = [NSMutableData dataWithLength:OUTPUT_SIZE];
        int32_t rsz = xwallet_spend_safe([input bytes],
                                         [input length],
                                         [output mutableBytes],
                                         error);
        return @{@"size": [NSNumber numberWithInteger:rsz], @"output": output};
    }];
    
    RNCBaseSafeOperation<NSDictionary*, NSDictionary*> *op3 = [RNCSafeOperation new:^NSDictionary*(NSDictionary* params, NSError **error) {
        NSInteger rsz = [params[@"size"] integerValue];
        if (rsz > 0) {
            NSDictionary* res = [RNCConvert dictionaryResponseFromJsonData:[params[@"output"] subdataWithRange:NSMakeRange(0, rsz)] error:error];
            if (*error == nil) {
                NSMutableDictionary* fixed = [res mutableCopy];
                fixed[@"cbor_encoded_tx"] = [RNCConvert encodedStringFromData:[RNCConvert dataFromByteArray:res[@"cbor_encoded_tx"]]];
                return fixed;
            }
            return res;
        } else {
            *error = [NSError rustError:[NSString stringWithFormat: @"Wrong response size: %li", (long)rsz]];
        }
        return nil;
    }];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:wallet forKey:@"wallet"];
    [params setObject:inputs forKey:@"inputs"];
    [params setObject:outputs forKey:@"outputs"];
    [params setObject:change forKey:@"change_addr"];
    
    [[RNCSafeOperationCombined combine:[RNCSafeOperationCombined combine:op1 with:op2] with:op3] exec:params andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(move:(nonnull NSDictionary *)wallet
                  withInputs:(nonnull NSArray*)inputs
                  andOutput:(nonnull NSString*)output
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSDictionary*, NSDictionary*>* op1 = [RNCSafeOperation new:^NSDictionary*(NSDictionary* params, NSError ** error) {
        return @{@"data": [RNCConvert jsonDataFromDictionary:params error:error],
                 @"ilen": [NSNumber numberWithUnsignedInteger:[params[@"inputs"] count]]};
    }];
    
    RNCBaseSafeOperation<NSData*, NSDictionary*>* op2 = [RNCCSafeOperation new:^NSDictionary*(NSDictionary* params, char **error) {
        NSData* input = params[@"data"];
        CHECK_NON_NULL_OR_CERROR(params[@"ilen"], *error, "inputs");
        NSUInteger ilen = [params[@"ilen"] unsignedIntegerValue];
        NSUInteger OUTPUT_SIZE = (ilen + 1) * 4096;
        NSMutableData* output = [NSMutableData dataWithLength:OUTPUT_SIZE];
        int32_t rsz = xwallet_move_safe([input bytes],
                                        [input length],
                                        [output mutableBytes],
                                        error);
        return @{@"size": [NSNumber numberWithInteger:rsz], @"output": output};
    }];
    
    RNCBaseSafeOperation<NSDictionary*, NSDictionary*> *op3 = [RNCSafeOperation new:^NSDictionary*(NSDictionary* params, NSError **error) {
        NSInteger rsz = [params[@"size"] integerValue];
        if (rsz > 0) {
            NSDictionary* res = [RNCConvert dictionaryResponseFromJsonData:[params[@"output"] subdataWithRange:NSMakeRange(0, rsz)] error:error];
            if (*error == nil) {
                NSMutableDictionary* fixed = [res mutableCopy];
                fixed[@"cbor_encoded_tx"] = [RNCConvert encodedStringFromData:[RNCConvert dataFromByteArray:res[@"cbor_encoded_tx"]]];
                return fixed;
            }
            return res;
        } else {
            *error = [NSError rustError:[NSString stringWithFormat: @"Wrong response size: %li", (long)rsz]];
        }
        return nil;
    }];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:wallet forKey:@"wallet"];
    [params setObject:inputs forKey:@"inputs"];
    [params setObject:output forKey:@"outputs"];
    
    [[RNCSafeOperationCombined combine:[RNCSafeOperationCombined combine:op1 with:op2] with:op3] exec:params andResolve:resolve orReject:reject];
}

@end
