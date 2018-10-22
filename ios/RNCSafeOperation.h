//
//  RNCSafeOperation.h
//  RNCardano
//
//  Created by Yehor Popovych on 10/22/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (Rust)

+ (NSError *)rustError:(NSString *)description;

@end

@interface RNCSafeOperation : NSObject

+ (RNCSafeOperation *)new:(id(^)(_Nullable id param, NSError** error))cb;

- (RNCSafeOperation *)initWithCallback:(id(^)(_Nullable id param, NSError** error))cb;

- (RNCSafeOperation *)andThen:(RNCSafeOperation *)next;

- (void)execAndResolve:(RCTPromiseResolveBlock)resolve orReject:(RCTPromiseRejectBlock)reject;

@end

@interface RNCCSafeOperation : RNCSafeOperation

+ (RNCCSafeOperation *)new:(id(^)(_Nullable id param, char** error))cb;

- (RNCCSafeOperation *)initWithCallback:(id(^)(_Nullable id param, char** error))cb;

@end

NS_ASSUME_NONNULL_END
