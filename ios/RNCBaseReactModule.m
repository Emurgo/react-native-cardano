//
//  RNCBaseReactModule.m
//  RNCardano
//
//  Created by Yehor Popovych on 10/23/18.
//  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.
//

#import "RNCBaseReactModule.h"
#import <rust_native_cardano.h>


@implementation RNCBaseReactModule

+ (void)load {
    init_cardano();
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

// Can't be called
+ (NSString *)moduleName {
    return @"RNCBaseReactModule";
}

@end
