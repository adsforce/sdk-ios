//
//  AdsforceHttpUrl.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/15.
//  Copyright © 2018 Adsforce. All rights reserved.
//

//#define IOS_TRACKING_URL_Domain         @"https://track-digest-test.adrealm.com"    //The digest data sending address  Test
//#define IOS_TRACKING_URL_Domain         @"https://track-digest.adrealm.com"       //The digest data sending address  Old Formal
#define IOS_TRACKING_URL_Domain         @"https://digest-track.xhance.io"       //The digest data sending address  Formal
#define IOS_TRACKING_URL_Path_INSTALL   @"install"
#define IOS_TRACKING_URL_Path_EVENT     @"event"
#define IOS_Deeplink_URL_Path_DEEPLINK  @"dl"
#define IOS_TRACKING_URL_Path_IAP       @"revn"
#define IOS_TRACKING_URL_Path_SESSION   @"active"

#import "AdsforceHttpUrl.h"
#import "AdsforceUtil.h"
#import "NSMutableString+AdsforceCheckNullValue.h"
#import "AdsforceBase64Utils.h"

@interface AdsforceHttpUrl () {
    NSString *_advertiserUrl;   //Advertisers data sending address
}
@end

@implementation AdsforceHttpUrl

static AdsforceHttpUrl *manager;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(manager == nil) {
            manager = [[AdsforceHttpUrl alloc] init];
        }
    });
    return manager;
}

#pragma mark - AdvertiserUrl

- (void)setAdvertiserUrl:(NSString *)advertiserUrl {
    _advertiserUrl = advertiserUrl;
}

- (NSString *)getAdvertiserUrl {
    return _advertiserUrl;
}

#pragma mark - InstallUrl

- (NSString *)getInstallUrlForAdvertiser {
    NSString *u = [AdsforceUtil urlWithDomain:_advertiserUrl path:IOS_TRACKING_URL_Path_INSTALL];
    return u;
}

- (NSString *)getInstallUrlForAdsforce {
    NSString *u = [AdsforceUtil urlWithDomain:IOS_TRACKING_URL_Domain path:IOS_TRACKING_URL_Path_INSTALL];
    return u;
}

#pragma mark - SessionUrl

- (NSString *)getSessionUrlForAdvertiser {
    NSString *u = [AdsforceUtil urlWithDomain:_advertiserUrl path:IOS_TRACKING_URL_Path_SESSION];
    return u;
}

- (NSString *)getSessionUrlForAdsforce {
    NSString *u = [AdsforceUtil urlWithDomain:IOS_TRACKING_URL_Domain path:IOS_TRACKING_URL_Path_SESSION];
    return u;
}

#pragma mark - IAPUrl

- (NSString *)getIAPUrlForAdvertiser {
    NSString *u = [AdsforceUtil urlWithDomain:_advertiserUrl path:IOS_TRACKING_URL_Path_IAP];
    return u;
}

- (NSString *)getIAPUrlForAdsforce {
    NSString *u = [AdsforceUtil urlWithDomain:IOS_TRACKING_URL_Domain path:IOS_TRACKING_URL_Path_IAP];
    return u;
}

#pragma mark - DeeplinkUrl

- (NSString *)getDeeplinkUrlForAdvertiser {
    NSString *u = [AdsforceUtil urlWithDomain:_advertiserUrl path:IOS_Deeplink_URL_Path_DEEPLINK];
    return u;
}

#pragma mark - CustomEventUrl

- (NSString *)getCustomEventUrlForAdvertiser {
    NSString *u = [AdsforceUtil urlWithDomain:_advertiserUrl path:IOS_TRACKING_URL_Path_EVENT];
    return u;
}

- (NSString *)getCustomEventUrlForAdsforce {
    NSString *u = [AdsforceUtil urlWithDomain:IOS_TRACKING_URL_Domain path:IOS_TRACKING_URL_Path_EVENT];
    return u;
}

#pragma mark - Util

+ (NSString *)jointAdvertiserUrl:(NSString *)url
                    aesEncodeKey:(NSString *)aesEncodeKey
          enDataStrForAdvertiser:(NSString *)enDataStrForAdvertiser
                  parameterModel:(AdsforceBaseParameter *)parameterModel {
    
    NSString *ahs = [AdsforceMd5Utils MD5OfString:[AdsforceCpParameter shareinstance].appId];
    NSString *advertiserParameterStr = [self getAdvertiserParameterStrWithAesEncodeKey:aesEncodeKey
                                                                enDataStrForAdvertiser:enDataStrForAdvertiser
                                                                        parameterModel:parameterModel];
    
    //拼接URL参数
    NSMutableString *mUrl = [[NSMutableString alloc] initWithString:url];
    [mUrl appendAndCheckString:@"/"];
    [mUrl appendAndCheckString:ahs];
    [mUrl appendAndCheckString:@"?"];
    [mUrl appendAndCheckString:advertiserParameterStr];
    
    NSString *urlStr = mUrl;
    return urlStr;
}

+ (NSString *)jointAdsforceUrl:(NSString *)url
            dataStrForAdsforce:(NSString *)dataStrForAdsforce
               parameterModel:(AdsforceBaseParameter *)parameterModel {
    
    NSString *ahs = [AdsforceMd5Utils MD5OfString:[AdsforceCpParameter shareinstance].appId];
    NSString *adsforceParameterStr = [self getAdsforceParameterStrWithDataStrForAdsforce:dataStrForAdsforce
                                                                       parameterModel:parameterModel];
    
    //拼接URL参数
    NSMutableString *mUrl = [[NSMutableString alloc] initWithString:url];
    [mUrl appendAndCheckString:@"/"];
    [mUrl appendAndCheckString:ahs];
    [mUrl appendAndCheckString:@"?"];
    [mUrl appendAndCheckString:adsforceParameterStr];
    
    NSString *urlStr = mUrl;
    return urlStr;
}

+ (NSString *)getAdvertiserParameterStrWithAesEncodeKey:(NSString *)aesEncodeKey
                                 enDataStrForAdvertiser:(NSString *)enDataStrForAdvertiser
                                         parameterModel:(AdsforceBaseParameter *)parameterModel {
    
    NSString *ahs = [AdsforceMd5Utils MD5OfString:[AdsforceCpParameter shareinstance].appId];
    NSString *uuid = parameterModel.uuid;
    
    //拼接参数
    NSMutableString *mStr = [[NSMutableString alloc] init];
    
    [mStr appendAndCheckString:@"pf=ios"];
    
    [mStr appendAndCheckString:@"&"];
    [mStr appendAndCheckString:@"k="];
    [mStr appendAndCheckString:aesEncodeKey];
    
    [mStr appendAndCheckString:@"&"];
    [mStr appendAndCheckString:@"cts="];
    [mStr appendAndCheckString:parameterModel.timeStamp];
    
    [mStr appendAndCheckString:@"&"];
    [mStr appendAndCheckString:@"ahs="];
    [mStr appendAndCheckString:ahs];
    
    [mStr appendAndCheckString:@"&"];
    [mStr appendAndCheckString:@"d="];
    [mStr appendAndCheckString:enDataStrForAdvertiser];
    
    [mStr appendAndCheckString:@"&"];
    [mStr appendAndCheckString:@"uuid="];
    [mStr appendAndCheckString:uuid];
    
    NSString *str = mStr;
    
    return str;
}

+ (NSString *)getAdsforceParameterStrWithDataStrForAdsforce:(NSString *)dataStrForAdsforce
                                           parameterModel:(AdsforceBaseParameter *)parameterModel {
    
    NSString *uuid = parameterModel.uuid;
    
    //拼接URL参数
    NSMutableString *mStr = [[NSMutableString alloc] init];
    
    [mStr appendAndCheckString:@"pf=ios"];
    
    [mStr appendAndCheckString:@"&"];
    [mStr appendAndCheckString:dataStrForAdsforce];
    //DataStrForAdsforce has been included in the CTS and ahs, so don't need to be repeated to add
    
    [mStr appendAndCheckString:@"&"];
    [mStr appendAndCheckString:@"uuid="];
    [mStr appendAndCheckString:uuid];
    
    NSString *str = mStr;
    
    return str;
}

@end
