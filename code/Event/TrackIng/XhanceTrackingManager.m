//
//  KTrackingManager.m
//  testSafariVC
//
//

#import "XhanceTrackingManager.h"
#import "NSMutableDictionary+XhanceCheckNullValue.h"
#import "XhanceUtil.h"
#import "XhanceRSA.h"
#import "XhanceAES.h"
#import "XhanceHttpUrl.h"
#import "XhanceTrackingParameter.h"
#import "XhanceDeeplinkManager.h"
#import "XhanceTrackingSend.h"
#import <iAd/iAd.h>

#define IOS_IS_TRACKED @"ios_is_tracked"    // Has it been attributed

@interface XhanceTrackingManager () {
    
    NSString *_publicKey;   //RSA public key
    
    __block XhanceTrackingParameter *_parameter;
    
    NSString *_aesKey;                              // Globally unique AES encryption key, randomly generated
    NSString *_aesEncodeKey;                        // str is _aesKey encryption to RSA
    
    XhanceTrackingSend *_advertiserTrackingSend;
    XhanceTrackingSend *_xhanceTrackingSend;
}
@end

@implementation XhanceTrackingManager

static XhanceTrackingManager *manager;

#pragma mark - shareInstancetype

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(manager == nil) {
            manager = [[XhanceTrackingManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _aesKey = [XhanceUtil get16RandomStr];
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
    _aesEncodeKey = [XhanceRSA encryptString:_aesKey publicKey:_publicKey];
    
    BOOL isTracking = [[NSUserDefaults standardUserDefaults] boolForKey:IOS_IS_TRACKED];
    if (isTracking) {
        // Has been tracked
        return;
    }
    NSLog(@"[XhanceSDK Log] Untracked, will tracking");
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version < 9.0f) {
        // Version below 9.0 is not track
        return;
    }

    // get apple search ad info
    [self getAppleSearchAdData:^(NSString *referrerStr) {
        _parameter = [[XhanceTrackingParameter alloc] initWithReferrer:referrerStr];
        [self trackingWithAdvertiser];
        [self trackingWithXhance];
    }];
}

- (void)getAppleSearchAdData:(void (^)(NSString *referrerStr))completionBlock {
    // Get parameters
    __block NSString *referrerJson = @"";
    if ([[ADClient sharedClient] respondsToSelector:@selector(requestAttributionDetailsWithBlock:)]) {
        [[ADClient sharedClient] requestAttributionDetailsWithBlock:^(NSDictionary *attributionDetails, NSError *error) {
            NSString *referrerStr = nil;
            if (error) {
                referrerStr = nil;
            }
            else {
                if (attributionDetails != nil) {
                    NSString *jsonStr = [XhanceUtil dictionaryToJson:attributionDetails];
                    referrerJson = [jsonStr copy];
                    if (referrerJson != nil && ![referrerJson isEqualToString:@""]) {
                        NSString *str = [NSString stringWithFormat:@"_apple_search:%@",referrerJson];
                        NSString *referrer = [XhanceUtil URLEncodedString:str];
                        referrerStr = [referrer copy];
                    }
                }
            }
            completionBlock(referrerStr);
        }];
    }
    else {
        completionBlock(nil);
    }
}

//Report to Advertiser
- (void)trackingWithAdvertiser {
    NSString *trackDataStrForAdvertiser = _parameter.dataStrForAdvertiser;
    NSString *enString = [XhanceAES EnAESandBase64EnToString:trackDataStrForAdvertiser key:_aesKey];
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getInstallUrlForAdvertiser];
    NSString *jointParameterUrlStr = [XhanceHttpUrl jointAdvertiserUrl:urlStr
                                                          aesEncodeKey:_aesEncodeKey
                                                enDataStrForAdvertiser:enString
                                                        parameterModel:_parameter];
    
    _advertiserTrackingSend = [[XhanceTrackingSend alloc] init];
    [_advertiserTrackingSend safariTrack:jointParameterUrlStr completion:^(BOOL didLoadSuccessfully) {
        [self safari:jointParameterUrlStr didCompleteInitialLoad:didLoadSuccessfully];
    }];
}

//Report to Xhance
- (void)trackingWithXhance {
    NSString *trackDataStrForXhance = _parameter.dataStrForXhance;
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getInstallUrlForXhance];
    NSString *jointParameterUrlStr = [XhanceHttpUrl jointXhanceUrl:urlStr
                                                  dataStrForXhance:trackDataStrForXhance
                                                     parameterModel:_parameter];
    
    _xhanceTrackingSend = [[XhanceTrackingSend alloc] init];
    [_xhanceTrackingSend safariTrack:jointParameterUrlStr completion:^(BOOL didLoadSuccessfully) {
        [self safari:jointParameterUrlStr didCompleteInitialLoad:didLoadSuccessfully];
    }];
}

#pragma mark - SafariTrackWithURL

- (void)safari:(NSString *)urlStr didCompleteInitialLoad:(BOOL)didLoadSuccessfully {

    if (didLoadSuccessfully) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IOS_IS_TRACKED];
        
        #ifdef UPLTVXhanceSDKDEBUG
        NSLog(@"[XhanceSDK Log] Tracking succeed with url:%@",urlStr);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLTVXhanceSDKDEBUGTRACKSUCCEED"
                                                            object:urlStr];
        #endif
        
        // Delay 1s to request Deeplink from the server
        int time = 1;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([XhanceDeeplinkManager canGetDeeplink]) {
                [XhanceDeeplinkManager getDeeplinkWithServer:_parameter];
            }
        });
    }
    else {
        #ifdef UPLTVXhanceSDKDEBUG
        NSLog(@"[XhanceSDK Log] Tracking failure with url:%@",urlStr);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLTVXhanceSDKDEBUGTRACKFAILURE"
                                                            object:urlStr];
        #endif
    }
}

@end
