//
//  KeychainIDFA.h
//  KeychainIDFA
//
//  Created by Qixin on 14/12/18.
//  Copyright (c) 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IDFA_STRING @"com.UPLTV.AdsforceSDK"

@interface AdsforceStatisticalKeychainDeviceID : NSObject

+ (NSString *)deviceID;

@end
