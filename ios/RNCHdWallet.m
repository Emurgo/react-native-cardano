//
//  HdWallet.m
//  RNCardano
//
//  Created by Yehor Popovych on 10/21/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import "RNCHdWallet.h"

@implementation RNCHdWallet

RCT_EXPORT_MODULE(CardanoHdWallet)

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(fromEnhancedEntropy:(NSArray *)entropy withPassword:(NSString *)password resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    resolve(entropy);
}

@end
