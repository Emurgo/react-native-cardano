//
//  RNCSafeOperation.m
//  RNCardano
//
//  Created by Yehor Popovych on 10/22/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import "RNCSafeOperation.h"
#import <rust_native_cardano.h>

@interface RNCSafeOperation (/* Private */)

@property (strong, nullable) RNCSafeOperation* parent;
@property (copy) id (^callback)(_Nullable id param, NSError** error);

- (id)callAllStack:(NSError **)error;

@end

@implementation RNCSafeOperation

+ (RNCSafeOperation *)new:(id (^)(_Nullable id param, NSError** error))cb {
    return [[RNCSafeOperation alloc] initWithCallback: cb];
}

- (RNCSafeOperation *)initWithCallback:(id(^)(_Nullable id param, NSError** error))cb {
    if (self = [super init]) {
        self.parent = nil;
        self.callback = cb;
    }
    return self;
}

- (RNCSafeOperation *)andThen:(RNCSafeOperation *)next {
    next.parent = self;
    return next;
}

- (id)callAllStack:(NSError **)error {
    if (self.parent != nil) {
        id res = [self.parent callAllStack:error];
        if (*error == nil) {
            res = self.callback(res, error);
        }
        return res;
    }
    return self.callback(nil, error);
}

- (void)execAndResolve:(RCTPromiseResolveBlock)resolve orReject:(RCTPromiseRejectBlock)reject {
    NSError* error = nil;
    id result = [self callAllStack: &error];
    if (error != nil) {
        reject(@"-1",
               @"Error occured",
               error);
    } else {
        resolve(result);
    }
}

@end

@implementation RNCCSafeOperation

+ (RNCCSafeOperation *)new:(id(^)(_Nullable id param, char** error))cb {
    return [[RNCCSafeOperation alloc] initWithCallback:cb];
}

- (RNCCSafeOperation *)initWithCallback:(id(^)(_Nullable id param, char** error))cb {
    return [super initWithCallback:^id(_Nullable id param, NSError **error) {
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

@implementation NSError (Rust)

+ (NSError *)rustError:(NSString *)description {
    return [NSError errorWithDomain:@"RustError"
                              code: 1
                          userInfo: @{@"message": description}];
}

@end


