//
//  XhanceSDK.m
//  XhanceSDK
//
//

#import "XhanceSDK.h"
#import "XhanceTrackingManager.h"
#import "XhanceHttpUrl.h"
#import "XhanceCpParameter.h"
#import "XhanceSessionManager.h"
#import "XhanceIAPManager.h"
#import "XhanceDeeplinkManager.h"
#import "XhanceCustomEventManager.h"

@implementation XhanceSDK

BOOL isInit;

#pragma mark - init
+ (void)initWithDevKey:(NSString *)devKey
             publicKey:(NSString *)publicKey
              trackUrl:(NSString *)trackUrl
             channelId:(NSString *)channelId
                 appId:(NSString *)appId {
    
    if (devKey == nil || [devKey isEqualToString:@""]) {
        NSLog(@"[XhanceSDK Error] devKey is nil, SDK not initialized successfully. Please check!");
        return;
    }
    if (publicKey == nil || [publicKey isEqualToString:@""]) {
        NSLog(@"[XhanceSDK Error] publicKey is nil, SDK not initialized successfully. Please check!");
        return;
    }
    if (trackUrl == nil || [trackUrl isEqualToString:@""]) {
        NSLog(@"[XhanceSDK Log Error] trackUrl is nil, SDK not initialized successfully. Please check!");
        return;
    }
    if (channelId == nil || [channelId isEqualToString:@""]) {
        NSLog(@"[XhanceSDK Log Error] channelId is nil, SDK not initialized successfully. Please check!");
        return;
    }
    if (appId == nil || [appId isEqualToString:@""]) {
        NSLog(@"[XhanceSDK Log Error] channelId is nil, SDK not initialized successfully. Please check!");
        return;
    }
    
    if (isInit) {
        return;
    }
    
    //cache cp parameter
    [XhanceCpParameter shareinstance].devKey = devKey;
    [XhanceCpParameter shareinstance].publicKey = publicKey;
    [XhanceCpParameter shareinstance].trackUrl = trackUrl;
    [XhanceCpParameter shareinstance].channelId = channelId;
    [XhanceCpParameter shareinstance].appId = appId;
    
    //set cp advertiser server url
    [[XhanceHttpUrl shareInstance] setAdvertiserUrl:trackUrl];
    
    //tracking
    [[XhanceTrackingManager shareInstance] trackingWithPublicKey:publicKey];
    
    //session
    [[XhanceSessionManager shareInstance] checkDefeatedSessionAndSendWithChildThread];
    //customEvent
    [XhanceCustomEventManager checkDefeatedCustomEventAndSendWithChildThread];
    //iap
    [XhanceIAPManager checkDefeatedIAPAndSendWithChildThread];
    
    isInit = YES;
}

#pragma mark - Deeplink

+ (void)getDeeplink:(void (^)(XhanceDeeplinkModel *deeplinkModel))completionBlock {
    if (!isInit) {
        NSLog(@"[XhanceSDK Log Error] SDK not initialized successfully. Please check!");
        return;
    }
    return [XhanceDeeplinkManager getDeeplink:completionBlock];
}

+ (void)appStoreWithProductPrice:(NSNumber *)productPrice
             productCurrencyCode:(NSString *)productCurrencyCode
               receiptDataString:(NSString *)receiptDataString
                          pubkey:(NSString *)pubkey
                          params:(NSDictionary *)params {
    
    if (!isInit) {
        NSLog(@"[XhanceSDK Log Error] SDK not initialized successfully. Please check!");
        return;
    }
    
    [XhanceIAPManager appStoreWithProductPrice:productPrice
                        productCurrencyCode:productCurrencyCode
                          receiptDataString:receiptDataString
                                     pubkey:pubkey
                                     params:params];
}

#pragma mark - IAP

+ (void)thirdPayWithProductPrice:(NSNumber *)productPrice
             productCurrencyCode:(NSString *)productCurrencyCode
               productIdentifier:(NSString *)productIdentifier
                 productCategory:(NSString *)productCategory {
 
    if (!isInit) {
        NSLog(@"[XhanceSDK Log Error] SDK not initialized successfully. Please check!");
        return;
    }
    
    [XhanceIAPManager thirdPayWithProductPrice:productPrice
                        productCurrencyCode:productCurrencyCode
                          productIdentifier:productIdentifier
                            productCategory:productCategory];
}

#pragma mark - CustomEvent

+ (void)enableCustomerEvent:(BOOL)enable {
    [XhanceCustomEventManager enableCustomerEvent:enable];
}

+ (void)customEventWithKey:(NSString *)key stringValue:(NSString *)value {
    if (!isInit) {
        NSLog(@"[XhanceSDK Log Error] SDK not initialized successfully. Please check!");
        return;
    }
    
    [XhanceCustomEventManager customEventWithKey:key value:value];
}

+ (void)customEventWithKey:(NSString *)key arrayValue:(NSArray<NSString *> *)value {
    if (!isInit) {
        NSLog(@"[XhanceSDK Log Error] SDK not initialized successfully. Please check!");
        return;
    }
    
    [XhanceCustomEventManager customEventWithKey:key value:value];
}

+ (void)customEventWithKey:(NSString *)key dictionaryValue:(NSDictionary<NSString *,NSString *> *)value {
    if (!isInit) {
        NSLog(@"[XhanceSDK Log Error] SDK not initialized successfully. Please check!");
        return;
    }
    
    [XhanceCustomEventManager customEventWithKey:key value:value];
}

@end
