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

+ (NSData *)dataFromHexString:(NSString *)string;
+ (NSString *)hexStringFromData:(NSData *)data;

+ (NSDictionary *)dictionaryFromJsonData:(NSData *)data error:(NSError **)error;
+ (NSArray *)arrayFromJsonData:(NSData *)data error:(NSError **)error;

+ (NSString *)stringFromBytes:(const char*)bytes length:(NSUInteger)len;

@end

NS_ASSUME_NONNULL_END
