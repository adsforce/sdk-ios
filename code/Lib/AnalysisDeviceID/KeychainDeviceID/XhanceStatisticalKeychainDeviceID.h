//
//  KeychainIDFA.h
//  KeychainIDFA
//
//

#import <Foundation/Foundation.h>

#define IDFA_STRING @"com.UPLTV.XhanceSDK"

@interface XhanceStatisticalKeychainDeviceID : NSObject

+ (NSString *)deviceID;

@end
