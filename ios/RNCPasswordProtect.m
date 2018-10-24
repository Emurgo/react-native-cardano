//
//  RNCPasswordProtect.m
//  RNCardano
//
//  Created by Yehor Popovych on 10/22/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import "RNCPasswordProtect.h"
#import <rust_native_cardano.h>
#import "RNCConvert.h"
#import "RNCSafeOperation.h"

@implementation RNCPasswordProtect

RCT_EXPORT_MODULE(CardanoPasswordProtect)

RCT_EXPORT_METHOD(encryptWithPassword:(nonnull NSString *)password
                  andSalt:(nonnull NSString *)salt
                  andNonce:(nonnull NSString *)nonce
                  andData:(nonnull NSString *)data
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSDictionary*, NSString*>* op = [RNCCSafeOperation new:^NSString*(NSDictionary* params, char **error) {
        NSData* nonce = params[@"nonce"];
        NSData* salt = params[@"params"];
        NSData* data = params[@"data"];
        NSData* password = [RNCConvert UTF8BytesFromString:params[@"password"]];
        
        CHECK_HAS_LENGTH_OR_CERROR(password, *error, "password");
        CHECK_HAS_LENGTH_OR_CERROR(data, *error, "data");
        
        if ([salt length] != SALT_SIZE) {
            *error = copy_string([[NSString stringWithFormat:@"Wrong salt len %lu should be %d", (unsigned long)[salt length], SALT_SIZE] UTF8String]);
            return nil;
        }
        if ([nonce length] != NONCE_SIZE) {
            *error = copy_string([[NSString stringWithFormat:@"Wrong nonce len %lu should be %d", (unsigned long)[nonce length], NONCE_SIZE] UTF8String]);
            return nil;
        }
        
        NSUInteger result_size = [data length] + TAG_SIZE + NONCE_SIZE + SALT_SIZE;
        
        NSMutableData* output = [NSMutableData dataWithLength:result_size];
        
        int32_t rsz = encrypt_with_password_safe([password bytes],
                                                 [password length],
                                                 [salt bytes],
                                                 [nonce bytes],
                                                 [data bytes],
                                                 [data length],
                                                 [output mutableBytes],
                                                 error);
        if (*error != NULL) {
            return nil;
        }
        if (rsz == result_size) {
            return [RNCConvert encodedStringFromData:output];
        } else {
            *error = copy_string([[NSString stringWithFormat:@"Wrong converted data len %d should be %lu", rsz, (unsigned long)result_size] UTF8String]);
            return nil;
        }
    }];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:password forKey:@"password"];
    [params setObject:[RNCConvert dataFromEncodedString:salt] forKey:@"salt"];
    [params setObject:[RNCConvert dataFromEncodedString:nonce] forKey:@"nonce"];
    [params setObject:[RNCConvert dataFromEncodedString:data] forKey:@"data"];
    
    [op exec:params andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(decryptWithPassword:(nonnull NSString *)password
                  data:(nonnull NSString *)data
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSDictionary*, NSString*>* op = [RNCCSafeOperation new:^NSString*(NSDictionary* params, char **error) {
        NSData* data = params[@"data"];
        NSData* password = [RNCConvert UTF8BytesFromString:params[@"password"]];
        
        CHECK_HAS_LENGTH_OR_CERROR(password, *error, "password");
        
        if ([data length] <= TAG_SIZE + NONCE_SIZE + SALT_SIZE) {
            *error = copy_string([[NSString stringWithFormat:@"Wrong data len %lu should be at least %d", (unsigned long)[data length], TAG_SIZE + NONCE_SIZE + SALT_SIZE + 1] UTF8String]);
        }
        
        NSUInteger result_size = [data length] - TAG_SIZE - NONCE_SIZE - SALT_SIZE;
        
        NSMutableData* output = [NSMutableData dataWithLength:result_size];
        
        int32_t rsz = decrypt_with_password_safe([password bytes],
                                                 [password length],
                                                 [data bytes],
                                                 [data length],
                                                 [output mutableBytes],
                                                 error);
        if (*error != NULL) {
            return nil;
        }
        if (rsz == result_size) {
            return [RNCConvert encodedStringFromData:output];
        } else {
            *error = copy_string([[NSString stringWithFormat:@"Wrong converted data len %d should be %lu", rsz, (unsigned long)result_size] UTF8String]);
            return nil;
        }
    }];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:password forKey:@"password"];
    [params setObject:[RNCConvert dataFromEncodedString:data] forKey:@"data"];
    
    [op exec:params andResolve:resolve orReject:reject];
}

@end
