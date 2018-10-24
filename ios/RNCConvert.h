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

+ (NSData *)dataFromEncodedString:(NSString *)string;
+ (NSString *)encodedStringFromData:(NSData *)data;

+ (NSDictionary *)dictionaryFromJsonData:(NSData *)data error:(NSError **)error;
+ (NSData *)jsonDataFromDictionary:(NSDictionary *)dictionary error:(NSError **)error;

+ (NSDictionary *)dictionaryResponseFromJsonData:(NSData *)data error:(NSError **)error;
+ (NSArray *)arrayResponseFromJsonData:(NSData *)data error:(NSError **)error;
+ (NSNumber *)numberResponseFromJsonData:(NSData *)data error:(NSError **)error;

+ (NSData *)UTF8BytesFromString:(NSString *)string;

+ (NSData *)dataFromByteArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
