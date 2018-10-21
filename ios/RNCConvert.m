//
//  RNCConvert.m
//  RNCardano
//
//  Created by Yehor Popovych on 10/21/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import "RNCConvert.h"
#import "NSData+FastHex.h"

@implementation RNCConvert

+ (NSData *)dataFromHexString:(NSString *)string {
    return [NSData dataWithHexString:string];
}

+ (NSString *)hexStringFromData:(NSData *)data {
    return [data hexStringRepresentationUppercase:NO];
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

@end
