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

RCT_EXPORT_METHOD(fromMasterKey:(NSString *)pkey
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSData*, NSDictionary*> *op1 = [RNCCSafeOperation new:^NSDictionary*(NSData* pkey, char **error) {
        NSMutableData* output = [NSMutableData dataWithLength:MAX_OUTPUT_SIZE];
        int32_t rsz = xwallet_from_master_key_safe([pkey bytes],
                                                   [output mutableBytes],
                                                   error);
        return @{@"size": [NSNumber numberWithInteger:rsz], @"output": output};
    }];
    
    RNCBaseSafeOperation<NSDictionary*, NSDictionary*> *op2 = [RNCSafeOperation new:^NSDictionary*(NSDictionary* params, NSError ** error) {
        NSInteger rsz = [params[@"size"] integerValue];
        if (rsz > 0) {
            return [RNCConvert dictionaryFromJsonData:[params[@"output"] subdataWithRange:NSMakeRange(0, rsz)] error:error];
        }
        return nil;
    }];
    
    [[RNCSafeOperationCombined combine:op1 with:op2] exec:[RNCConvert dataFromHexString:pkey] andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(newAccount:(NSDictionary *)wallet
                  withIndex:(NSNumber *)index
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
            return [RNCConvert dictionaryFromJsonData:[params[@"output"] subdataWithRange:NSMakeRange(0, rsz)] error:error];
        } else if (*error == nil) {
            *error = [NSError rustError:[NSString stringWithFormat: @"Wrong response size: %li", (long)rsz]];
        }
        return nil;
    }];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:wallet forKey:@"wallet"];
    [params setObject:index forKey:@"account"];
    
    [[RNCSafeOperationCombined combine:[RNCSafeOperationCombined combine:op1 with:op2] with:op3] exec:params andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(generateAddresses:(NSDictionary *)account
                  withType:(NSString*) type
                  forIndices:(NSArray<NSNumber *> *)indices
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
            return [RNCConvert arrayFromJsonData:[param[@"output"] subdataWithRange:NSMakeRange(0, rsz)] error:error];
        } else if (*error == nil) {
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


RCT_EXPORT_METHOD(checkAddress:(NSString *)address
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSString*, NSNumber*>* op = [RNCCSafeOperation new:^NSNumber*(NSString* address, char **error) {
        NSData* input = [[NSString stringWithFormat:@"\"%@\"", address] dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableData* output = [NSMutableData dataWithLength:MAX_OUTPUT_SIZE];
        int32_t rsz = xwallet_checkaddress_safe([input bytes],
                                                [input length],
                                                [output mutableBytes],
                                                error);
        if (rsz > 0) {
            NSString* response = [RNCConvert stringFromBytes:[output bytes] length:rsz];
            return [response isEqualToString:@"true"]
                ? [NSNumber numberWithBool:YES]
                : [NSNumber numberWithBool:NO];
        }
        *error = copy_string([[NSString stringWithFormat:@"Response length %d <= 0", rsz] UTF8String]);
        return nil;
    }];
    
    [op exec:address andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(spend:(NSString *)wallet
                  withInputs:(NSArray*)inputs
                  andOutputs:(NSArray*)outputs
                  andChangeAddress:(NSString*)change
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSDictionary*, NSDictionary*>* op1 = [RNCSafeOperation new:^NSDictionary*(NSDictionary* params, NSError ** error) {
        return @{@"data": [RNCConvert jsonDataFromDictionary:params error:error],
                 @"ilen": [NSNumber numberWithUnsignedInteger:[params[@"inputs"] length]],
                 @"olen": [NSNumber numberWithUnsignedInteger:[params[@"outputs"] length]]};
    }];
    
    RNCBaseSafeOperation<NSData*, NSDictionary*>* op2 = [RNCCSafeOperation new:^NSDictionary*(NSDictionary* params, char **error) {
        NSData* input = params[@"data"];
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
            return [RNCConvert dictionaryFromJsonData:[params[@"output"] subdataWithRange:NSMakeRange(0, rsz)] error:error];
        } else if (*error == nil) {
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

RCT_EXPORT_METHOD(move:(NSString *)wallet
                  withInputs:(NSArray*)inputs
                  andOutput:(NSString*)output
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSDictionary*, NSDictionary*>* op1 = [RNCSafeOperation new:^NSDictionary*(NSDictionary* params, NSError ** error) {
        return @{@"data": [RNCConvert jsonDataFromDictionary:params error:error],
                 @"ilen": [NSNumber numberWithUnsignedInteger:[params[@"inputs"] length]]};
    }];
    
    RNCBaseSafeOperation<NSData*, NSDictionary*>* op2 = [RNCCSafeOperation new:^NSDictionary*(NSDictionary* params, char **error) {
        NSData* input = params[@"data"];
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
            return [RNCConvert dictionaryFromJsonData:[params[@"output"] subdataWithRange:NSMakeRange(0, rsz)] error:error];
        } else if (*error == nil) {
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
