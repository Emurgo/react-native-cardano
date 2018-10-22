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

@interface RNCBaseSafeOperation<In, Out> : NSObject

- (Out)exec:(In)param error:(NSError **)error;

- (void)exec:(In)param andResolve:(RCTPromiseResolveBlock)resolve orReject:(RCTPromiseRejectBlock)reject;

@end

@interface RNCSafeOperation<In, Out> : RNCBaseSafeOperation<In, Out>

+ (RNCBaseSafeOperation<In, Out> *)new:(Out(^)(In param, NSError** error))cb;

- (RNCSafeOperation<In, Out> *)initWithCallback:(Out(^)(In param, NSError** error))cb;

@end

@interface RNCCSafeOperation<In, Out> : RNCSafeOperation<In, Out>

+ (RNCBaseSafeOperation *)new:(Out(^)(In param, char** error))cb;

- (RNCCSafeOperation *)initWithCallback:(Out(^)(In param, char** error))cb;

@end

@interface RNCSafeOperationCombined<In1, Out1, Out2> : RNCBaseSafeOperation<In1, Out2>

+ (RNCBaseSafeOperation<In1, Out2>* )combine:(RNCBaseSafeOperation<In1, Out1> *)op1
                                    with:(RNCBaseSafeOperation<Out1, Out2> *)op2;

- (RNCSafeOperationCombined<In1, Out1, Out2> *)init:(RNCBaseSafeOperation<In1, Out1> *)op1
                                                and:(RNCBaseSafeOperation<Out1, Out2> *)op2;

@end

NS_ASSUME_NONNULL_END
