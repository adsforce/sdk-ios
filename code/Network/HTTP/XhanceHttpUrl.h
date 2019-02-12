//
//  XhanceHttpUrl.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XhanceBaseParameter.h"

@interface XhanceHttpUrl : NSObject

+ (instancetype)shareInstance;

#pragma mark - AdvertiserUrl

- (void)setAdvertiserUrl:(NSString *)advertiserlUrl;

- (NSString *)getAdvertiserUrl;

#pragma mark - InstallUrl

- (NSString *)getInstallUrlForAdvertiser;

- (NSString *)getInstallUrlForXhance;

#pragma mark - SessionUrl

- (NSString *)getSessionUrlForAdvertiser;

- (NSString *)getSessionUrlForXhance;

#pragma mark - IAPUrl

- (NSString *)getIAPUrlForAdvertiser;

- (NSString *)getIAPUrlForXhance;

#pragma mark - DeeplinkUrl

- (NSString *)getDeeplinkUrlForAdvertiser;

#pragma mark - CustomEventUrl

- (NSString *)getCustomEventUrlForAdvertiser;

- (NSString *)getCustomEventUrlForXhance;

#pragma mark - jointUrl

+ (NSString *)jointAdvertiserUrl:(NSString *)url
                    aesEncodeKey:(NSString *)aesEncodeKey
          enDataStrForAdvertiser:(NSString *)enDataStrForAdvertiser
                  parameterModel:(XhanceBaseParameter *)parameterModel;

+ (NSString *)jointXhanceUrl:(NSString *)url
            dataStrForXhance:(NSString *)dataStrForXhance
               parameterModel:(XhanceBaseParameter *)parameterModel;

#pragma mark - ParameterStr

+ (NSString *)getAdvertiserParameterStrWithAesEncodeKey:(NSString *)aesEncodeKey
                                 enDataStrForAdvertiser:(NSString *)enDataStrForAdvertiser
                                         parameterModel:(XhanceBaseParameter *)parameterModel;

+ (NSString *)getXhanceParameterStrWithDataStrForXhance:(NSString *)dataStrForXhance
                                           parameterModel:(XhanceBaseParameter *)parameterModel;
@end
