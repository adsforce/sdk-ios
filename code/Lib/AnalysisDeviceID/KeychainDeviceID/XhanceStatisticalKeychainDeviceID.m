//
//  KeychainIDFA.m
//  KeychainIDFA
//
//

#import "XhanceStatisticalKeychainDeviceID.h"
#import "XhanceStatisticalKeychainHelper.h"
#import "XhanceStatisticalSimulateIDFA.h"
@import AdSupport;

#define kIsStringValid(text) (text && text!=NULL && text.length>0)

@implementation XhanceStatisticalKeychainDeviceID

+ (void)deleteDeviceID {
    [XhanceStatisticalKeychainHelper delete:IDFA_STRING];
}

+ (NSString *)deviceID {
    NSString *deviceID = [XhanceStatisticalKeychainDeviceID getIdfaString];
    if (kIsStringValid(deviceID)) {
        return deviceID;
    }
    else {
        double version = [[UIDevice currentDevice].systemVersion doubleValue];
        
        if (![ASIdentifierManager sharedManager].advertisingTrackingEnabled && version >= 10.0f) {
            deviceID = [XhanceStatisticalSimulateIDFA createSimulateIDFA];
            
            [XhanceStatisticalKeychainDeviceID setIdfaString:deviceID];
            if (kIsStringValid(deviceID)) {
                return deviceID;
            }
        }
        else {
            deviceID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            
            [XhanceStatisticalKeychainDeviceID setIdfaString:deviceID];
            return deviceID;
        }
    }
    
    return nil;
}

#pragma mark - Keychain

+ (NSString *)getIdfaString {
    NSString *idfaStr = [XhanceStatisticalKeychainHelper load:IDFA_STRING];
    if (kIsStringValid(idfaStr)) {
        return idfaStr;
    }
    else {
        return nil;
    }
}

+ (BOOL)setIdfaString:(NSString *)secValue {
    if (kIsStringValid(secValue)) {
        [XhanceStatisticalKeychainHelper save:IDFA_STRING data:secValue];
        return YES;
    }
    else {
        return NO;
    }
}


@end
