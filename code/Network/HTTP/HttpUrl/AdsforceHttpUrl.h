//
//  AdsforceHttpUrl.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/15.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdsforceBaseParameter.h"

@interface AdsforceHttpUrl : NSObject

+ (instancetype)shareInstance;

#pragma mark - AdvertiserUrl

- (void)setAdvertiserUrl:(NSString *)advertiserlUrl;

- (NSString *)getAdvertiserUrl;

#pragma mark - InstallUrl

- (NSString *)getInstallUrlForAdvertiser;

- (NSString *)getInstallUrlForAdsforce;

#pragma mark - SessionUrl

- (NSString *)getSessionUrlForAdvertiser;

- (NSString *)getSessionUrlForAdsforce;

#pragma mark - IAPUrl

- (NSString *)getIAPUrlForAdvertiser;

- (NSString *)getIAPUrlForAdsforce;

#pragma mark - DeeplinkUrl

- (NSString *)getDeeplinkUrlForAdvertiser;

#pragma mark - CustomEventUrl

- (NSString *)getCustomEventUrlForAdvertiser;

- (NSString *)getCustomEventUrlForAdsforce;

#pragma mark - jointUrl

+ (NSString *)jointAdvertiserUrl:(NSString *)url
                    aesEncodeKey:(NSString *)aesEncodeKey
          enDataStrForAdvertiser:(NSString *)enDataStrForAdvertiser
                  parameterModel:(AdsforceBaseParameter *)parameterModel;

+ (NSString *)jointAdsforceUrl:(NSString *)url
            dataStrForAdsforce:(NSString *)dataStrForAdsforce
               parameterModel:(AdsforceBaseParameter *)parameterModel;

#pragma mark - ParameterStr

+ (NSString *)getAdvertiserParameterStrWithAesEncodeKey:(NSString *)aesEncodeKey
                                 enDataStrForAdvertiser:(NSString *)enDataStrForAdvertiser
                                         parameterModel:(AdsforceBaseParameter *)parameterModel;

+ (NSString *)getAdsforceParameterStrWithDataStrForAdsforce:(NSString *)dataStrForAdsforce
                                           parameterModel:(AdsforceBaseParameter *)parameterModel;
@end
