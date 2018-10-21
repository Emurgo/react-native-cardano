//
//  RNCConvert.h
//  RNCardano
//
//  Created by Yehor Popovych on 10/21/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNCConvert : NSObject

+ (NSData *)dataFromArray:(NSArray<NSNumber *> *)array;
+ (NSArray<NSNumber *> *)arrayFromData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
