//
//  KeychainHelper.h
//  KeychainIDFA
//
//

#import <UIKit/UIKit.h>

@interface XhanceStatisticalKeychainHelper : NSObject

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

@end
