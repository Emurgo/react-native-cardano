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

RCT_EXPORT_METHOD(newChecker:(NSString *)pkey
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    RNCBaseSafeOperation<NSString*, NSDictionary*> *op1 = [RNCCSafeOperation new:^NSDictionary*(NSString* pkey, char **error) {
        CHECK_HAS_LENGTH_OR_CERROR(pkey, *error, "pkey");
        NSData* input = [[NSString stringWithFormat:@"\"%@\"", pkey] dataUsingEncoding:NSUTF8StringEncoding];
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
            return [RNCConvert dictionaryFromJsonData:[params[@"output"] subdataWithRange:NSMakeRange(0, rsz)] error:error];
        } else if (*error == nil) {
            *error = [NSError rustError:[NSString stringWithFormat: @"Wrong response size: %li", (long)rsz]];
        }
        return nil;
    }];
    
    [[RNCSafeOperationCombined combine:op1 with:op2] exec:pkey andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(checkAddresses:(NSDictionary *)checker
                  addresses:(NSArray *)addresses
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSDictionary*, NSData*>* op1 = [RNCSafeOperation new:^NSData*(NSDictionary* params, NSError ** error) {
        return [RNCConvert jsonDataFromDictionary:params error:error];
    }];
    
    RNCBaseSafeOperation<NSData*, NSDictionary*>* op2 = [RNCCSafeOperation new:^NSDictionary*(NSData* input, char **error) {
        NSMutableData* output = [NSMutableData dataWithLength:MAX_OUTPUT_SIZE];
        int32_t rsz = random_address_check_safe([input bytes],
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
    [params setObject:checker forKey:@"checker"];
    [params setObject:addresses forKey:@"addresses"];
    
    [[RNCSafeOperationCombined combine:[RNCSafeOperationCombined combine:op1 with:op2] with:op3] exec:params andResolve:resolve orReject:reject];
}

@end
