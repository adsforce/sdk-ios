//
//  AdsforceSDK.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/4/12.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import "AdsforceSDK.h"
#import "AdsforceTrackingManager.h"
#import "AdsforceHttpUrl.h"
#import "AdsforceCpParameter.h"
#import "AdsforceSessionManager.h"
#import "AdsforceIAPManager.h"
#import "AdsforceDeeplinkManager.h"
#import "AdsforceCustomEventManager.h"
#import "AdsforceHttpDnsManager.h"

@implementation AdsforceSDK

BOOL isInit;

#pragma mark - init
+ (void)initWithDevKey:(NSString *)devKey
             publicKey:(NSString *)publicKey
              trackUrl:(NSString *)trackUrl
             channelId:(NSString *)channelId
                 appId:(NSString *)appId {
    
    if (devKey == nil || [devKey isEqualToString:@""]) {
        NSLog(@"[AdsforceSDK Error] devKey is nil, SDK not initialized successfully. Please check!");
        return;
    }
    if (publicKey == nil || [publicKey isEqualToString:@""]) {
        NSLog(@"[AdsforceSDK Error] publicKey is nil, SDK not initialized successfully. Please check!");
        return;
    }
    if (trackUrl == nil || [trackUrl isEqualToString:@""]) {
        NSLog(@"[AdsforceSDK Log Error] trackUrl is nil, SDK not initialized successfully. Please check!");
        return;
    }
    if (channelId == nil || [channelId isEqualToString:@""]) {
        NSLog(@"[AdsforceSDK Log Error] channelId is nil, SDK not initialized successfully. Please check!");
        return;
    }
    if (appId == nil || [appId isEqualToString:@""]) {
        NSLog(@"[AdsforceSDK Log Error] channelId is nil, SDK not initialized successfully. Please check!");
        return;
    }
    
    if (isInit) {
        return;
    }
    
    //cache cp parameter
    [AdsforceCpParameter shareinstance].devKey = devKey;
    [AdsforceCpParameter shareinstance].publicKey = publicKey;
    [AdsforceCpParameter shareinstance].trackUrl = trackUrl;
    [AdsforceCpParameter shareinstance].channelId = channelId;
    [AdsforceCpParameter shareinstance].appId = appId;
    
    //set cp advertiser server url
    [[AdsforceHttpUrl shareInstance] setAdvertiserUrl:trackUrl];
    
    //tracking
    [[AdsforceTrackingManager shareInstance] trackingWithPublicKey:publicKey];
    
    //session
    [[AdsforceSessionManager shareInstance] sendOpenSession];
    [[AdsforceSessionManager shareInstance] checkDefeatedSessionAndSendWithChildThread];
    //customEvent
    [AdsforceCustomEventManager checkDefeatedCustomEventAndSendWithChildThread];
    //iap
    [AdsforceIAPManager checkDefeatedIAPAndSendWithChildThread];
    
    isInit = YES;
}

#pragma mark - Deeplink

+ (void)getDeeplink:(void (^)(AdsforceDeeplinkModel *deeplinkModel))completionBlock {
    if (!isInit) {
        NSLog(@"[AdsforceSDK Log Error] SDK not initialized successfully. Please check!");
        return;
    }
    return [AdsforceDeeplinkManager getDeeplink:completionBlock];
}

+ (void)appStoreWithProductPrice:(NSNumber *)productPrice
             productCurrencyCode:(NSString *)productCurrencyCode
               receiptDataString:(NSString *)receiptDataString
                          pubkey:(NSString *)pubkey
                          params:(NSDictionary *)params {
    
    if (!isInit) {
        NSLog(@"[AdsforceSDK Log Error] SDK not initialized successfully. Please check!");
        return;
    }
    
    [AdsforceIAPManager appStoreWithProductPrice:productPrice
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
        NSLog(@"[AdsforceSDK Log Error] SDK not initialized successfully. Please check!");
        return;
    }
    
    [AdsforceIAPManager thirdPayWithProductPrice:productPrice
                        productCurrencyCode:productCurrencyCode
                          productIdentifier:productIdentifier
                            productCategory:productCategory];
}

#pragma mark - CustomEvent

+ (void)enableCustomerEvent:(BOOL)enable {
    [AdsforceCustomEventManager enableCustomerEvent:enable];
}

+ (void)customEventWithKey:(NSString *)key stringValue:(NSString *)value {
    if (!isInit) {
        NSLog(@"[AdsforceSDK Log Error] SDK not initialized successfully. Please check!");
        return;
    }
    
    [AdsforceCustomEventManager customEventWithKey:key value:value];
}

+ (void)customEventWithKey:(NSString *)key arrayValue:(NSArray<NSString *> *)value {
    if (!isInit) {
        NSLog(@"[AdsforceSDK Log Error] SDK not initialized successfully. Please check!");
        return;
    }
    
    [AdsforceCustomEventManager customEventWithKey:key value:value];
}

+ (void)customEventWithKey:(NSString *)key dictionaryValue:(NSDictionary<NSString *,NSString *> *)value {
    if (!isInit) {
        NSLog(@"[AdsforceSDK Log Error] SDK not initialized successfully. Please check!");
        return;
    }
    
    [AdsforceCustomEventManager customEventWithKey:key value:value];
}

#pragma mark - DnsMappingServers

+ (void)enableDnsMode:(BOOL)enable {
    [[AdsforceHttpDnsManager shareInstance] setEnableDnsMode:enable];
}

+ (void)setDnsMappingServers:(NSArray <NSString *> *)dnsMappingServers host:(NSString *)host {
    if (dnsMappingServers == nil || dnsMappingServers.count == 0) {
        NSLog(@"[AdsforceSDK Log Error] dnsMappingServers is nil. Please check!");
        return;
    }

    if (host == nil || [host isEqualToString:@""]) {
        NSLog(@"[AdsforceSDK Log Error] trackUrl host is nil. Please check!");
        return;
    }
    [[AdsforceHttpDnsManager shareInstance] setDnsServerAddressList:dnsMappingServers host:host];
}

@end
