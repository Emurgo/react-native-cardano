//
//  Wallet.m
//  RNCardano
//
//  Created by Yehor Popovych on 10/21/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import "RNCWallet.h"

@implementation RNCWallet

RCT_EXPORT_MODULE(CardanoWallet)

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(fromMasterKey:(NSArray*) pkey resolver:(RCTPromiseResolveBlock) resolve rejecter:(RCTPromiseRejectBlock) reject) {
    resolve(pkey);
}

@end
