//
//  KeychainHelper.h
//  KeychainIDFA
//
//  Created by Qixin on 14/12/18.
//  Copyright (c) 2018 Adsforce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdsforceStatisticalKeychainHelper : NSObject

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

@end
