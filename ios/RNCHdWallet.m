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

RCT_EXPORT_METHOD(fromEnhancedEntropy:(nonnull NSString *)entropy
                  withPassword:(nonnull NSString *)password
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSDictionary*, NSString*> *op = [RNCCSafeOperation new:^NSString*(NSDictionary* params, char ** error) {
        NSData* entropy = params[@"entropy"];
        NSData* password = [RNCConvert UTF8BytesFromString:params[@"password"]];
        CHECK_HAS_LENGTH_OR_CERROR(entropy, *error, "entropy");
        CHECK_NON_NULL_OR_CERROR(password, *error, "password");
     
        NSMutableData* output = [NSMutableData dataWithLength:XPRV_SIZE];
        uintptr_t res = wallet_from_enhanced_entropy_safe([entropy bytes], [entropy length],
                                                          [password bytes], [password length],
                                                          [output mutableBytes], error);
        if (*error != NULL) {
            return nil;
        }
        if (res != 0) {
            *error = copy_string([[NSString stringWithFormat:@"Wrong response %lu should be 0", res] UTF8String]);
            return nil;
        }
        return [RNCConvert encodedStringFromData:output];
    }];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:[RNCConvert dataFromEncodedString:entropy] forKey:@"entropy"];
    [params setObject:password forKey:@"password"];
    
    [op exec:params andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(fromSeed:(nonnull NSString *)seed
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSData*, NSString*> *op = [RNCCSafeOperation new:^NSString*(NSData* seed, char ** error) {
        if ([seed length] != SEED_SIZE) {
            *error = copy_string([[NSString stringWithFormat:@"Wrong seed len %lu should be %d", (unsigned long)[seed length], SEED_SIZE] UTF8String]);
            return nil;
        }
        NSMutableData* output = [NSMutableData dataWithLength:XPRV_SIZE];
        
        wallet_from_seed_safe([seed bytes], [output mutableBytes], error);
        
        return [RNCConvert encodedStringFromData:output];
    }];
    
    [op exec:[RNCConvert dataFromEncodedString:seed] andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(toPublic:(nonnull NSString *)xprv
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSData*, NSString*> *op = [RNCCSafeOperation new:^NSString*(NSData* xprv, char ** error) {
        if ([xprv length] != XPRV_SIZE) {
            *error = copy_string([[NSString stringWithFormat:@"Wrong XPrv len %lu should be %d", (unsigned long)[xprv length], XPRV_SIZE] UTF8String]);
            return nil;
        }
        NSMutableData* output = [NSMutableData dataWithLength:XPUB_SIZE];
        
        wallet_to_public_safe([xprv bytes], [output mutableBytes], error);
        
        return [RNCConvert encodedStringFromData:output];
    }];
    
    [op exec:[RNCConvert dataFromEncodedString:xprv] andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(derivePrivate:(nonnull NSString *)xprv
                  withIndex:(nonnull NSNumber *)index
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSDictionary*, NSString*> *op = [RNCCSafeOperation new:^NSString*(NSDictionary* params, char ** error) {
        NSData* xprv = params[@"xprv"];
        CHECK_NON_NULL_OR_CERROR(params[@"index"], *error, "index");
        uint32_t index = [params[@"index"] unsignedIntValue];
        if ([xprv length] != XPRV_SIZE) {
            *error = copy_string([[NSString stringWithFormat:@"Wrong XPrv len %lu should be %d", (unsigned long)[xprv length], XPRV_SIZE] UTF8String]);
            return nil;
        }
        NSMutableData* output = [NSMutableData dataWithLength:XPRV_SIZE];
        
        wallet_derive_private_safe([xprv bytes], index, [output mutableBytes], error);
        
        return [RNCConvert encodedStringFromData:output];
    }];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:[RNCConvert dataFromEncodedString:xprv] forKey:@"xprv"];
    [params setObject:index forKey:@"index"];
    
    [op exec:params andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(derivePublic:(nonnull NSString *)xpub
                  withIndex:(nonnull NSNumber *)index
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSDictionary*, NSString*> *op = [RNCCSafeOperation new:^NSString*(NSDictionary* params, char ** error) {
        NSData* xpub = params[@"xpub"];
        CHECK_NON_NULL_OR_CERROR(params[@"index"], *error, "index");
        uint32_t index = [params[@"index"] unsignedIntValue];
        
        if ([xpub length] != XPUB_SIZE) {
            *error = copy_string([[NSString stringWithFormat:@"Wrong XPub len %lu should be %d", (unsigned long)[xpub length], XPUB_SIZE] UTF8String]);
            return nil;
        }
        
        if (index >= 0x80000000) {
            *error = copy_string("Cannot do public derivation with hard index");
            return nil;
        }
        
        NSMutableData* output = [NSMutableData dataWithLength:XPUB_SIZE];
        
        bool res = wallet_derive_public_safe([xpub bytes], index, [output mutableBytes], error);
        
        if (*error != NULL) {
            return nil;
        }
        
        if (!res) {
            *error = copy_string("Can't derive public key");
        }
        
        return [RNCConvert encodedStringFromData:output];
    }];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:[RNCConvert dataFromEncodedString:xpub] forKey:@"xpub"];
    [params setObject:index forKey:@"index"];
    
    [op exec:params andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(sign:(nonnull NSString *)xprv
                  data:(nonnull NSString *)data
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSDictionary*, NSString*> *op = [RNCCSafeOperation new:^NSString*(NSDictionary* params, char ** error) {
        NSData* xprv = params[@"xprv"];
        NSData* data = params[@"data"];
        CHECK_HAS_LENGTH_OR_CERROR(data, *error, "data");
        
        if ([xprv length] != XPRV_SIZE) {
            *error = copy_string([[NSString stringWithFormat:@"Wrong XPrv len %lu should be %d", (unsigned long)[xprv length], XPRV_SIZE] UTF8String]);
            return nil;
        }
        
        NSMutableData* output = [NSMutableData dataWithLength:SIGNATURE_SIZE];
        
        wallet_sign_safe([xprv bytes], [data bytes], [data length], [output mutableBytes], error);
        
        return [RNCConvert encodedStringFromData:output];
    }];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:[RNCConvert dataFromEncodedString:xprv] forKey:@"xprv"];
    [params setObject:[RNCConvert dataFromEncodedString:data] forKey:@"data"];
    
    [op exec:params andResolve:resolve orReject:reject];
}

@end
