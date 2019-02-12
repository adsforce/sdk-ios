//
//  XhanceHttpUrl.m
//  XhanceSDK
//
//

//#define IOS_TRACKING_URL_Domain         @"https://track-digest-test.xhance.io"    //The digest data sending address  Test
//#define IOS_TRACKING_URL_Domain         @"https://track-digest.xhance.io"       //The digest data sending address  Old Formal
#define IOS_TRACKING_URL_Domain         @"https://digest-track.xhance.io"       //The digest data sending address  Formal
#define IOS_TRACKING_URL_Path_INSTALL   @"install"
#define IOS_TRACKING_URL_Path_EVENT     @"event"
#define IOS_Deeplink_URL_Path_DEEPLINK  @"dl"
//#define IOS_TRACKING_URL_Path_IAP       @"iap"

#import "XhanceHttpUrl.h"
#import "XhanceUtil.h"
#import "NSMutableString+XhanceCheckNullValue.h"
#import "XhanceBase64Utils.h"

@interface XhanceHttpUrl () {
    NSString *_advertiserUrl;   //Advertisers data sending address
}
@end

@implementation XhanceHttpUrl

static XhanceHttpUrl *manager;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(manager == nil) {
            manager = [[XhanceHttpUrl alloc] init];
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
    NSString *u = [XhanceUtil urlWithDomain:_advertiserUrl path:IOS_TRACKING_URL_Path_INSTALL];
    return u;
}

- (NSString *)getInstallUrlForXhance {
    NSString *u = [XhanceUtil urlWithDomain:IOS_TRACKING_URL_Domain path:IOS_TRACKING_URL_Path_INSTALL];
    return u;
}

#pragma mark - SessionUrl

- (NSString *)getSessionUrlForAdvertiser {
    NSString *u = [XhanceUtil urlWithDomain:_advertiserUrl path:IOS_TRACKING_URL_Path_EVENT];
    return u;
}

- (NSString *)getSessionUrlForXhance {
    NSString *u = [XhanceUtil urlWithDomain:IOS_TRACKING_URL_Domain path:IOS_TRACKING_URL_Path_EVENT];
    return u;
}

#pragma mark - IAPUrl

- (NSString *)getIAPUrlForAdvertiser {
    NSString *u = [XhanceUtil urlWithDomain:_advertiserUrl path:IOS_TRACKING_URL_Path_EVENT];
    return u;
}

- (NSString *)getIAPUrlForXhance {
    NSString *u = [XhanceUtil urlWithDomain:IOS_TRACKING_URL_Domain path:IOS_TRACKING_URL_Path_EVENT];
    return u;
}

#pragma mark - DeeplinkUrl

- (NSString *)getDeeplinkUrlForAdvertiser {
    NSString *u = [XhanceUtil urlWithDomain:_advertiserUrl path:IOS_Deeplink_URL_Path_DEEPLINK];
    return u;
}

#pragma mark - CustomEventUrl

- (NSString *)getCustomEventUrlForAdvertiser {
    NSString *u = [XhanceUtil urlWithDomain:_advertiserUrl path:IOS_TRACKING_URL_Path_EVENT];
    return u;
}

- (NSString *)getCustomEventUrlForXhance {
    NSString *u = [XhanceUtil urlWithDomain:IOS_TRACKING_URL_Domain path:IOS_TRACKING_URL_Path_EVENT];
    return u;
}

#pragma mark - Util

+ (NSString *)jointAdvertiserUrl:(NSString *)url
                    aesEncodeKey:(NSString *)aesEncodeKey
          enDataStrForAdvertiser:(NSString *)enDataStrForAdvertiser
                  parameterModel:(XhanceBaseParameter *)parameterModel {
    
    NSString *ahs = [XhanceMd5Utils MD5OfString:[XhanceCpParameter shareinstance].appId];
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

+ (NSString *)jointXhanceUrl:(NSString *)url
            dataStrForXhance:(NSString *)dataStrForXhance
               parameterModel:(XhanceBaseParameter *)parameterModel {
    
    NSString *ahs = [XhanceMd5Utils MD5OfString:[XhanceCpParameter shareinstance].appId];
    NSString *xhanceParameterStr = [self getXhanceParameterStrWithDataStrForXhance:dataStrForXhance
                                                                       parameterModel:parameterModel];
    
    //拼接URL参数
    NSMutableString *mUrl = [[NSMutableString alloc] initWithString:url];
    [mUrl appendAndCheckString:@"/"];
    [mUrl appendAndCheckString:ahs];
    [mUrl appendAndCheckString:@"?"];
    [mUrl appendAndCheckString:xhanceParameterStr];
    
    NSString *urlStr = mUrl;
    return urlStr;
}

+ (NSString *)getAdvertiserParameterStrWithAesEncodeKey:(NSString *)aesEncodeKey
                                 enDataStrForAdvertiser:(NSString *)enDataStrForAdvertiser
                                         parameterModel:(XhanceBaseParameter *)parameterModel {
    
    NSString *ahs = [XhanceMd5Utils MD5OfString:[XhanceCpParameter shareinstance].appId];
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

+ (NSString *)getXhanceParameterStrWithDataStrForXhance:(NSString *)dataStrForXhance
                                           parameterModel:(XhanceBaseParameter *)parameterModel {
    
    NSString *uuid = parameterModel.uuid;
    
    //拼接URL参数
    NSMutableString *mStr = [[NSMutableString alloc] init];
    
    [mStr appendAndCheckString:@"pf=ios"];
    
    [mStr appendAndCheckString:@"&"];
    [mStr appendAndCheckString:dataStrForXhance];
    //DataStrForXhance has been included in the CTS and ahs, so don't need to be repeated to add
    
    [mStr appendAndCheckString:@"&"];
    [mStr appendAndCheckString:@"uuid="];
    [mStr appendAndCheckString:uuid];
    
    NSString *str = mStr;
    
    return str;
}

@end
