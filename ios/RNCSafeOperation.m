//
//  RNCSafeOperation.m
//  RNCardano
//
//  Created by Yehor Popovych on 10/22/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import "RNCSafeOperation.h"
#import <rust_native_cardano.h>

@implementation RNCBaseSafeOperation

- (void)exec:(id)param andResolve:(RCTPromiseResolveBlock)resolve orReject:(RCTPromiseRejectBlock)reject {
    NSError* error = nil;
    id result = [self exec:param error:&error];
    if (error != nil) {
        reject([NSString stringWithFormat:@"%li", (long)[error code]],
               [error localizedDescription],
               error);
    } else {
        resolve(result);
    }
}

- (id)exec:(id)param error:(NSError **)error {
    NSAssert(true, @"Reload");
    return nil;
}

@end

@interface RNCSafeOperation<In, Out> (/* Private */)

@property (copy) Out (^callback)(In param, NSError** error);

@end

@implementation RNCSafeOperation

+ (RNCBaseSafeOperation *)new:(_Nullable id (^)(_Nullable id param, NSError** error))cb {
    return [[RNCSafeOperation alloc] initWithCallback: cb];
}

- (RNCSafeOperation *)initWithCallback:(_Nullable id(^)(_Nullable id param, NSError** error))cb {
    if (self = [super init]) {
        self.callback = cb;
    }
    return self;
}

- (id)exec:(id)param error:(NSError **)error {
    return self.callback(param, error);
}

@end

@implementation RNCCSafeOperation

+ (RNCBaseSafeOperation *)new:(_Nullable id(^)(_Nullable id param, char** error))cb {
    return [[RNCCSafeOperation alloc] initWithCallback:cb];
}

- (RNCCSafeOperation *)initWithCallback:(_Nullable id(^)(_Nullable id param, char** error))cb {
    return [super initWithCallback:^_Nullable id(_Nullable id param, NSError **error) {
        char* cError = NULL;
        id result = cb(param, &cError);
        if (cError != NULL) {
            *error = [NSError rustError:[NSString stringWithUTF8String: cError]];
            dealloc_string(cError);
        }
        return result;
    }];
}

@end

@interface RNCSafeOperationCombined (/* Private */)

@property (strong) RNCSafeOperation* op1;
@property (strong) RNCSafeOperation* op2;

@end

@implementation RNCSafeOperationCombined

+ (RNCBaseSafeOperation* )combine:(RNCSafeOperation *)op1 with:(RNCSafeOperation *)op2 {
    return [[self alloc] init:op1 and: op2];
}

- (RNCSafeOperationCombined* )init:(RNCSafeOperation *)op1 and:(RNCSafeOperation *)op2 {
    if (self = [super init]) {
        self.op1 = op1;
        self.op2 = op2;
    }
    return self;
}

- (id)exec:(id)param error:(NSError **)error {
    id result = [self.op1 exec:param error:error];
    if (*error == nil) {
        result = [self.op2 exec:result error:error];
    }
    return result;
}

@end

@implementation NSError (Rust)

+ (NSError *)rustError:(NSString *)description {
    return [NSError errorWithDomain:@"RNCardano.Rust"
                              code: 0
                          userInfo: @{NSLocalizedDescriptionKey: description}];
}

@end


