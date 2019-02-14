//
//  AdsforceDeeplinkManager.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/6/1.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import "AdsforceDeeplinkManager.h"
#import "AdsforceHttpManager.h"
#import "AdsforceHttpUrl.h"
#import "AdsforceRSA.h"
#import "AdsforceAES.h"
#import "AdsforceEncryptModel.h"

#define AdsforceSDK_DEEPLINK_CACHE_KEY               @"AdsforceSDK_DEEPLINK_CACHE_KEY"
#define AdsforceSDK_DEEPLINK_CACHE_GAVE_CP_KEY       @"AdsforceSDK_DEEPLINK_CACHE_KEY"

#define DEEPLINK_URL_KEY                        @"dlink_url"
#define DEEPLINK_ARGS_KEY                       @"dlink_args"

@interface AdsforceDeeplinkManager ()

@end

@implementation AdsforceDeeplinkManager
BOOL _isGeting;

+ (BOOL)canGetDeeplink {
    return !_isGeting;
}

+ (void)getDeeplinkWithServer:(AdsforceTrackingParameter *)parameter {
    if (_isGeting) {
        return;
    }
    
//    NSString *aesKey = [AdsforceUtil get16RandomStr];
//    NSString *aesEncodeKey = [AdsforceRSA encryptString:aesKey publicKey:[AdsforceCpParameter shareinstance].publicKey];
    AdsforceEncryptModel *encryptModel = [AdsforceEncryptModel getModel];
    if (![encryptModel available]) {
        return;
    }
    NSString *aesKey = encryptModel.aesKey;
    NSString *aesEncodeKey = encryptModel.aesEncodeKey;
    
    // The main parameters
    NSString *dataStrForAdvertiser = parameter.dataStrForAdvertiser;
    
    // AES encryption
    NSString *enString = [AdsforceAES EnAESandBase64EnToString:dataStrForAdvertiser key:aesKey];
    
    // Get the domain name path url
    NSString *urlStr = [[AdsforceHttpUrl shareInstance] getDeeplinkUrlForAdvertiser];
    
    // Stitching parameter into url
    NSString *jointParmeterUrlStr = [AdsforceHttpUrl jointAdvertiserUrl:urlStr
                                                         aesEncodeKey:aesEncodeKey
                                               enDataStrForAdvertiser:enString
                                                       parameterModel:parameter];
    
    [AdsforceHttpManager getDeepLink:jointParmeterUrlStr retryCount:0 completion:^(id responseObject) {
        [self cacheDeeplink:responseObject];
    } error:^(NSError *error) {
        
    }];
    
    _isGeting = YES;
}

+ (void)cacheDeeplink:(NSDictionary *)deeplinkDic {
    [[NSUserDefaults standardUserDefaults] setObject:deeplinkDic forKey:AdsforceSDK_DEEPLINK_CACHE_KEY];
}

+ (void)getDeeplink:(void (^)(AdsforceDeeplinkModel *deeplinkModel))completionBlock {
    BOOL isGave = [[NSUserDefaults standardUserDefaults] boolForKey:AdsforceSDK_DEEPLINK_CACHE_GAVE_CP_KEY];
    if (isGave) {
        completionBlock(nil);
        return;
    }
    
    AdsforceDeeplinkModel *deeplinkModel = [self getDeeplinkForCache];
    if (deeplinkModel != nil) {
        completionBlock(deeplinkModel);
    }
    else {
        NSInteger time = 5;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            AdsforceDeeplinkModel *deeplinkModel = [self getDeeplinkForCache];
            if (deeplinkModel != nil) {
                completionBlock(deeplinkModel);
            }
            else {
                completionBlock(nil);
            }
        });
    }
}

+ (AdsforceDeeplinkModel *)getDeeplinkForCache {

    NSDictionary *deeplinkDic = [[NSUserDefaults standardUserDefaults] objectForKey:AdsforceSDK_DEEPLINK_CACHE_KEY];
    if (deeplinkDic == nil) {
        return nil;
    }
    
    AdsforceDeeplinkModel *model = [[AdsforceDeeplinkModel alloc] init];
    if ([[deeplinkDic allKeys] containsObject:DEEPLINK_URL_KEY]) {
        model.targetUrl = [deeplinkDic objectForKey:DEEPLINK_URL_KEY];
    }
    if ([[deeplinkDic allKeys] containsObject:DEEPLINK_ARGS_KEY]) {
        model.linkArgs = [deeplinkDic objectForKey:DEEPLINK_ARGS_KEY];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:AdsforceSDK_DEEPLINK_CACHE_KEY];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AdsforceSDK_DEEPLINK_CACHE_GAVE_CP_KEY];
    return model;
}

@end
