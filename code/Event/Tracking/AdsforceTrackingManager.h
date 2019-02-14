//
//  KTrackingManager.h
//  testSafariVC
//
//  Created by liuguojun on 16/7/6.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdsforceTrackingManager : NSObject

+ (instancetype)shareInstance;

- (void)trackingWithPublicKey:(NSString *)publicKey;

@end
