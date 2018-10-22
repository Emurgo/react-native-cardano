//
//  RNCConvert.m
//  RNCardano
//
//  Created by Yehor Popovych on 10/21/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import "RNCConvert.h"
#import "NSData+FastHex.h"

// Uncomment this if you want to use base16 for data
//#define USE_BASE16 YES

@implementation RNCConvert

+ (NSData *)dataFromEncodedString:(NSString *)string {
    #ifdef USE_BASE16
        return [NSData dataWithHexString:string];
    #else
        return [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    #endif
}

+ (NSString *)encodedStringFromData:(NSData *)data {
    #ifdef USE_BASE16
        return [data hexStringRepresentationUppercase:YES];
    #else
        return [data base64EncodedStringWithOptions:kNilOptions];
    #endif
}

+ (NSDictionary *)dictionaryFromJsonData:(NSData *)data error:(NSError **)error {
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
}

+ (NSArray *)arrayFromJsonData:(NSData *)data error:(NSError **)error {
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
}

+ (NSString *)stringFromBytes:(const char*)bytes length:(NSUInteger)len {
    NSData* data = [[NSData alloc] initWithBytesNoCopy:(void*)bytes length:len];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSData *)jsonDataFromDictionary:(NSDictionary *)dictionary error:(NSError **)error {
    return [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:error];
}

+ (NSData *)jsonDataFromArray:(NSArray *)array error:(NSError **)error {
    return [NSJSONSerialization dataWithJSONObject:array options:kNilOptions error:error];
}

@end
