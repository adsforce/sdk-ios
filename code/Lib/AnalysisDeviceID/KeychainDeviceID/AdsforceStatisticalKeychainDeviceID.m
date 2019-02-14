//
//  KeychainIDFA.m
//  KeychainIDFA
//
//  Created by Qixin on 14/12/18.
//  Copyright (c) 2018 Adsforce. All rights reserved.
//

#import "AdsforceStatisticalKeychainDeviceID.h"
#import "AdsforceStatisticalKeychainHelper.h"
#import "AdsforceStatisticalSimulateIDFA.h"
@import AdSupport;

#define kIsStringValid(text) (text && text!=NULL && text.length>0)

@implementation AdsforceStatisticalKeychainDeviceID

+ (void)deleteDeviceID {
    [AdsforceStatisticalKeychainHelper delete:IDFA_STRING];
}

+ (NSString *)deviceID {
    NSString *deviceID = [AdsforceStatisticalKeychainDeviceID getIdfaString];
    if (kIsStringValid(deviceID)) {
        return deviceID;
    }
    else {
        double version = [[UIDevice currentDevice].systemVersion doubleValue];
        
        if (![ASIdentifierManager sharedManager].advertisingTrackingEnabled && version >= 10.0f) {
            deviceID = [AdsforceStatisticalSimulateIDFA createSimulateIDFA];
            
            [AdsforceStatisticalKeychainDeviceID setIdfaString:deviceID];
            if (kIsStringValid(deviceID)) {
                return deviceID;
            }
        }
        else {
            deviceID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            
            [AdsforceStatisticalKeychainDeviceID setIdfaString:deviceID];
            return deviceID;
        }
    }
    
    return nil;
}

#pragma mark - Keychain

+ (NSString *)getIdfaString {
    NSString *idfaStr = [AdsforceStatisticalKeychainHelper load:IDFA_STRING];
    if (kIsStringValid(idfaStr)) {
        return idfaStr;
    }
    else {
        return nil;
    }
}

+ (BOOL)setIdfaString:(NSString *)secValue {
    if (kIsStringValid(secValue)) {
        [AdsforceStatisticalKeychainHelper save:IDFA_STRING data:secValue];
        return YES;
    }
    else {
        return NO;
    }
}


@end
