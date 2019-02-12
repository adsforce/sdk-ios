//
//  XhanceDeeplinkManager.m
//  XhanceSDK
//
//

#import "XhanceDeeplinkManager.h"
#import "XhanceHttpManager.h"
#import "XhanceHttpUrl.h"
#import "XhanceRSA.h"
#import "XhanceAES.h"

#define XhanceSDK_DEEPLINK_CACHE_KEY               @"XhanceSDK_DEEPLINK_CACHE_KEY"
#define XhanceSDK_DEEPLINK_CACHE_GAVE_CP_KEY       @"XhanceSDK_DEEPLINK_CACHE_KEY"

#define DEEPLINK_URL_KEY                        @"dlink_url"
#define DEEPLINK_ARGS_KEY                       @"dlink_args"

@interface XhanceDeeplinkManager ()

@end

@implementation XhanceDeeplinkManager
BOOL _isGeting;

+ (BOOL)canGetDeeplink {
    return !_isGeting;
}

+ (void)getDeeplinkWithServer:(XhanceTrackingParameter *)parameter {
    if (_isGeting) {
        return;
    }
    
    NSString *aesKey = [XhanceUtil get16RandomStr];
    NSString *aesEncodeKey = [XhanceRSA encryptString:aesKey publicKey:[XhanceCpParameter shareinstance].publicKey];
    
    // The main parameters
    NSString *dataStrForAdvertiser = parameter.dataStrForAdvertiser;
    
    // AES encryption
    NSString *enString = [XhanceAES EnAESandBase64EnToString:dataStrForAdvertiser key:aesKey];
    
    // Get the domain name path url
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getDeeplinkUrlForAdvertiser];
    
    // Stitching parameter into url
    NSString *jointParmeterUrlStr = [XhanceHttpUrl jointAdvertiserUrl:urlStr
                                                         aesEncodeKey:aesEncodeKey
                                               enDataStrForAdvertiser:enString
                                                       parameterModel:parameter];
    
    [XhanceHttpManager getDeepLink:jointParmeterUrlStr retryCount:0 completion:^(id responseObject) {
        [self cacheDeeplink:responseObject];
    } error:^(NSError *error) {
        
    }];
    
    _isGeting = YES;
}

+ (void)cacheDeeplink:(NSDictionary *)deeplinkDic {
    [[NSUserDefaults standardUserDefaults] setObject:deeplinkDic forKey:XhanceSDK_DEEPLINK_CACHE_KEY];
}

+ (void)getDeeplink:(void (^)(XhanceDeeplinkModel *deeplinkModel))completionBlock {
    BOOL isGave = [[NSUserDefaults standardUserDefaults] boolForKey:XhanceSDK_DEEPLINK_CACHE_GAVE_CP_KEY];
    if (isGave) {
        completionBlock(nil);
        return;
    }
    
    XhanceDeeplinkModel *deeplinkModel = [self getDeeplinkForCache];
    if (deeplinkModel != nil) {
        completionBlock(deeplinkModel);
    }
    else {
        NSInteger time = 5;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            XhanceDeeplinkModel *deeplinkModel = [self getDeeplinkForCache];
            if (deeplinkModel != nil) {
                completionBlock(deeplinkModel);
            }
            else {
                completionBlock(nil);
            }
        });
    }
}

+ (XhanceDeeplinkModel *)getDeeplinkForCache {

    NSDictionary *deeplinkDic = [[NSUserDefaults standardUserDefaults] objectForKey:XhanceSDK_DEEPLINK_CACHE_KEY];
    if (deeplinkDic == nil) {
        return nil;
    }
    
    XhanceDeeplinkModel *model = [[XhanceDeeplinkModel alloc] init];
    if ([[deeplinkDic allKeys] containsObject:DEEPLINK_URL_KEY]) {
        model.targetUrl = [deeplinkDic objectForKey:DEEPLINK_URL_KEY];
    }
    if ([[deeplinkDic allKeys] containsObject:DEEPLINK_ARGS_KEY]) {
        model.linkArgs = [deeplinkDic objectForKey:DEEPLINK_ARGS_KEY];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XhanceSDK_DEEPLINK_CACHE_KEY];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:XhanceSDK_DEEPLINK_CACHE_GAVE_CP_KEY];
    return model;
}

@end
