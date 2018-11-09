//
//  RNCRandomAddressChecker.m
//  RNCardano
//
//  Created by Yehor Popovych on 10/22/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import "RNCRandomAddressChecker.h"
#import <rust_native_cardano.h>
#import "RNCConvert.h"
#import "RNCSafeOperation.h"


@implementation RNCRandomAddressChecker

RCT_EXPORT_MODULE(CardanoRandomAddressChecker)

RCT_EXPORT_METHOD(newChecker:(nonnull NSString *)pkey
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    RNCBaseSafeOperation<NSString*, NSDictionary*> *op1 = [RNCCSafeOperation new:^NSDictionary*(NSString* pkey, char **error) {
        CHECK_HAS_LENGTH_OR_CERROR(pkey, *error, "pkey");
        NSData* input = [RNCConvert UTF8BytesFromString:[NSString stringWithFormat:@"\"%@\"", pkey]];
        NSMutableData* output = [NSMutableData dataWithLength:MAX_OUTPUT_SIZE];
        int32_t rsz = random_address_checker_new_safe([input bytes],
                                                      [input length],
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
    
    [[RNCSafeOperationCombined combine:op1 with:op2] exec:pkey andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(newCheckerFromMnemonics:(nonnull NSString *)mnemonics
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    RNCBaseSafeOperation<NSString*, NSDictionary*> *op1 = [RNCCSafeOperation new:^NSDictionary*(NSString* mnemonics, char **error) {
        CHECK_HAS_LENGTH_OR_CERROR(mnemonics, *error, "mnemonics");
        NSData* input = [RNCConvert UTF8BytesFromString:[NSString stringWithFormat:@"\"%@\"", mnemonics]];
        NSMutableData* output = [NSMutableData dataWithLength:MAX_OUTPUT_SIZE];
        int32_t rsz = random_address_checker_from_mnemonics_safe([input bytes],
                                                                 [input length],
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
    
    [[RNCSafeOperationCombined combine:op1 with:op2] exec:mnemonics andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(checkAddresses:(nonnull NSDictionary *)checker
                  addresses:(nonnull NSArray *)addresses
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSDictionary*, NSData*>* op1 = [RNCSafeOperation new:^NSData*(NSDictionary* params, NSError ** error) {
        return [RNCConvert jsonDataFromDictionary:params error:error];
    }];
    
    RNCBaseSafeOperation<NSData*, NSDictionary*>* op2 = [RNCCSafeOperation new:^NSDictionary*(NSData* input, char **error) {
        CHECK_HAS_LENGTH_OR_CERROR(input, *error, "addresses");
        NSUInteger OUTPUT_SIZE = MAX([input length], MAX_OUTPUT_SIZE);
        NSMutableData* output = [NSMutableData dataWithLength:OUTPUT_SIZE];
        int32_t rsz = random_address_check_safe([input bytes],
                                                [input length],
                                                [output mutableBytes],
                                                error);
        return @{@"size": [NSNumber numberWithInteger:rsz], @"output": output};
    }];
    
    RNCBaseSafeOperation<NSDictionary*, NSArray*> *op3 = [RNCSafeOperation new:^NSArray*(NSDictionary* params, NSError **error) {
        NSInteger rsz = [params[@"size"] integerValue];
        if (rsz > 0) {
            return [RNCConvert arrayResponseFromJsonData:[params[@"output"] subdataWithRange:NSMakeRange(0, rsz)] error:error];
        } else {
            *error = [NSError rustError:[NSString stringWithFormat: @"Wrong response size: %li", (long)rsz]];
        }
        return nil;
    }];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:checker forKey:@"checker"];
    [params setObject:addresses forKey:@"addresses"];
    
    [[RNCSafeOperationCombined combine:[RNCSafeOperationCombined combine:op1 with:op2] with:op3] exec:params andResolve:resolve orReject:reject];
}

@end
