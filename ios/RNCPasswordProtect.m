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

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(encryptWithPassword:(NSString *)password
                  andSalt:(NSString *)salt
                  andNonce:(NSString *)nonce
                  andData:(NSString *)data
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSDictionary*, NSString*>* op = [RNCCSafeOperation new:^NSString*(NSDictionary* params, char **error) {
        NSData* nonce = params[@"nonce"];
        NSData* salt = params[@"params"];
        NSData* data = params[@"data"];
        const char* cstr = [params[@"password"] UTF8String];
        
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
        
        int32_t rsz = encrypt_with_password_safe((const unsigned char*)cstr,
                                                 strlen(cstr),
                                                 [salt bytes],
                                                 [nonce bytes],
                                                 [data bytes],
                                                 [data length],
                                                 [output mutableBytes],
                                                 error);
        
        if (rsz == result_size) {
            return [RNCConvert hexStringFromData:output];
        } else {
            *error = copy_string([[NSString stringWithFormat:@"Wrong converted data len %d should be %lu", rsz, (unsigned long)result_size] UTF8String]);
            return nil;
        }
    }];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:password forKey:@"password"];
    [params setObject:[RNCConvert dataFromHexString:salt] forKey:@"salt"];
    [params setObject:[RNCConvert dataFromHexString:nonce] forKey:@"nonce"];
    [params setObject:[RNCConvert dataFromHexString:data] forKey:@"data"];
    
    [op exec:params andResolve:resolve orReject:reject];
}

RCT_EXPORT_METHOD(decryptWithPassword:(NSString *)password
                  data:(NSString *)data
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    RNCBaseSafeOperation<NSDictionary*, NSString*>* op = [RNCCSafeOperation new:^NSString*(NSDictionary* params, char **error) {
        NSData* data = params[@"data"];
        const char* cstr = [params[@"password"] UTF8String];
        
        if ([data length] <= TAG_SIZE + NONCE_SIZE + SALT_SIZE) {
            *error = copy_string([[NSString stringWithFormat:@"Wrong data len %lu should be at least %d", (unsigned long)[data length], TAG_SIZE + NONCE_SIZE + SALT_SIZE + 1] UTF8String]);
        }
        
        NSUInteger result_size = [data length] - TAG_SIZE - NONCE_SIZE - SALT_SIZE;
        
        NSMutableData* output = [NSMutableData dataWithLength:result_size];
        
        int32_t rsz = decrypt_with_password_safe((const unsigned char*)cstr,
                                                 strlen(cstr),
                                                 [data bytes],
                                                 [data length],
                                                 [output mutableBytes],
                                                 error);
        
        if (rsz == result_size) {
            return [RNCConvert hexStringFromData:output];
        } else {
            *error = copy_string([[NSString stringWithFormat:@"Wrong converted data len %d should be %lu", rsz, (unsigned long)result_size] UTF8String]);
            return nil;
        }
    }];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:password forKey:@"password"];
    [params setObject:[RNCConvert dataFromHexString:data] forKey:@"data"];
    
    [op exec:params andResolve:resolve orReject:reject];
}

@end
