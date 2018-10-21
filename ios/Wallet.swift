//
//  Wallet.swift
//  RNCardano
//
//  Created by Yehor Popovych on 10/21/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation

@objc(Wallet)
class Wallet: NSObject {
    
    @objc func methodQueue() -> DispatchQueue {
        return DispatchQueue.main
    }
    
    @objc func fromMasterKey(
        _ pkey: NSArray,
        resolver resolve: RCTPromiseResolveBlock,
        rejecter reject: RCTPromiseRejectBlock
    ) {
        resolve(pkey)
    }
}
