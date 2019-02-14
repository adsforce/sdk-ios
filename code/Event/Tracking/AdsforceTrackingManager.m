//
//  KTrackingManager.m
//  testSafariVC
//
//  Created by liuguojun on 16/7/6.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import "AdsforceTrackingManager.h"
#import "NSMutableDictionary+AdsforceCheckNullValue.h"
#import "AdsforceUtil.h"
#import "AdsforceRSA.h"
#import "AdsforceAES.h"
#import "AdsforceHttpUrl.h"
#import "AdsforceTrackingParameter.h"
#import "AdsforceDeeplinkManager.h"
#import "AdsforceTrackingSend.h"
#import "AdsforceAppleSearchManager.h"
#import "AdsforceCustomEventManager.h"

#define IOS_IS_TRACKED @"ios_is_tracked"    // Has it been attributed

@interface AdsforceTrackingManager () {
    
    NSString *_publicKey;   //RSA public key
    
    __block AdsforceTrackingParameter *_parameter;
    
    NSString *_aesKey;                              // Globally unique AES encryption key, randomly generated
    NSString *_aesEncodeKey;                        // str is _aesKey encryption to RSA
    
    AdsforceTrackingSend *_advertiserTrackingSend;
    AdsforceTrackingSend *_adsforceTrackingSend;
}
@end

@implementation AdsforceTrackingManager

static AdsforceTrackingManager *manager;

#pragma mark - shareInstancetype

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(manager == nil) {
            manager = [[AdsforceTrackingManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _aesKey = [AdsforceUtil get16RandomStr];
    }
    return self;
}

#pragma mark - API

- (void)trackingWithPublicKey:(NSString *)publicKey {
    if (publicKey == nil || [publicKey isEqualToString:@""]) {
        return;
    }
    
    _publicKey = [publicKey copy];
    
    // RSA encryption
    _aesEncodeKey = [AdsforceRSA encryptString:_aesKey publicKey:_publicKey];
    
    BOOL isTracking = [[NSUserDefaults standardUserDefaults] boolForKey:IOS_IS_TRACKED];
    if (isTracking) {
        // Has been tracked
        return;
    }
    NSLog(@"[AdsforceSDK Log] Untracked, will tracking");
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version < 9.0f) {
        // Version below 9.0 is not track
        return;
    }

    // get apple search ad info
    NSString *uuidStr = [NSUUID UUID].UUIDString;
    [AdsforceAppleSearchManager getAppleSearchAdData:^(NSString * _Nonnull referrerStr) {
        _parameter = [[AdsforceTrackingParameter alloc] initWithReferrer:referrerStr uuid:uuidStr];
        [self trackingWithAdvertiser];
        [self trackingWithAdsforce];
    } errorBlock:^(NSError * _Nonnull error) {
        // retry
        [AdsforceAppleSearchManager retryGetAppleSearchAdDataWithRetryTimes:1 uuid:uuidStr completion:^(NSString * _Nonnull referrerStr) {
            [AdsforceCustomEventManager mandatoryCustomEventWithKey:@"_apl_sch_succ" value:referrerStr];
        } errorBlock:^(NSString * _Nonnull referrerStr) {
            [AdsforceCustomEventManager mandatoryCustomEventWithKey:@"_apl_sch_err" value:referrerStr];
        }];
    }];
}

//Report to Advertiser
- (void)trackingWithAdvertiser {
    NSString *trackDataStrForAdvertiser = _parameter.dataStrForAdvertiser;
    NSString *enString = [AdsforceAES EnAESandBase64EnToString:trackDataStrForAdvertiser key:_aesKey];
    NSString *urlStr = [[AdsforceHttpUrl shareInstance] getInstallUrlForAdvertiser];
    NSString *jointParameterUrlStr = [AdsforceHttpUrl jointAdvertiserUrl:urlStr
                                                          aesEncodeKey:_aesEncodeKey
                                                enDataStrForAdvertiser:enString
                                                        parameterModel:_parameter];
    
    _advertiserTrackingSend = [[AdsforceTrackingSend alloc] init];
    [_advertiserTrackingSend safariTrack:jointParameterUrlStr completion:^(BOOL didLoadSuccessfully) {
        [self safari:jointParameterUrlStr didCompleteInitialLoad:didLoadSuccessfully];
    }];
}

//Report to Adsforce
- (void)trackingWithAdsforce {
    NSString *trackDataStrForAdsforce = _parameter.dataStrForAdsforce;
    NSString *urlStr = [[AdsforceHttpUrl shareInstance] getInstallUrlForAdsforce];
    NSString *jointParameterUrlStr = [AdsforceHttpUrl jointAdsforceUrl:urlStr
                                                  dataStrForAdsforce:trackDataStrForAdsforce
                                                     parameterModel:_parameter];
    
    _adsforceTrackingSend = [[AdsforceTrackingSend alloc] init];
    [_adsforceTrackingSend safariTrack:jointParameterUrlStr completion:^(BOOL didLoadSuccessfully) {
        [self safari:jointParameterUrlStr didCompleteInitialLoad:didLoadSuccessfully];
    }];
}

#pragma mark - SafariTrackWithURL

- (void)safari:(NSString *)urlStr didCompleteInitialLoad:(BOOL)didLoadSuccessfully {

    if (didLoadSuccessfully) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IOS_IS_TRACKED];
        
        #ifdef UPLTVAdsforceSDKDEBUG
        NSLog(@"[AdsforceSDK Log] Tracking succeed with url:%@",urlStr);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLTVAdsforceSDKDEBUGTRACKSUCCEED"
                                                            object:urlStr];
        #endif
        
        // Delay 1s to request Deeplink from the server
        int time = 1;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([AdsforceDeeplinkManager canGetDeeplink]) {
                [AdsforceDeeplinkManager getDeeplinkWithServer:_parameter];
            }
        });
    }
    else {
        #ifdef UPLTVAdsforceSDKDEBUG
        NSLog(@"[AdsforceSDK Log] Tracking failure with url:%@",urlStr);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLTVAdsforceSDKDEBUGTRACKFAILURE"
                                                            object:urlStr];
        #endif
    }
}

@end
