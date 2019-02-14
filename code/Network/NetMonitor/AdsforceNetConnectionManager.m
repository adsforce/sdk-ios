//
//  AvidlyConnectionManager.m
//  AvidlyAdsSDK
//
//  Created by samliu on 2017/4/19.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import "AdsforceNetConnectionManager.h"
#import <Foundation/Foundation.h>


@interface AdsforceNetConnectionManager () {
    AdsforceNetReachability *_internetReachable;
    //Reachability *_hostReachable;
    NSMutableArray<AdsforceNetConnectionCallback> *_callbackArys;
    
}

@end

@implementation AdsforceNetConnectionManager

+ (instancetype)sharedInstance {
    static AdsforceNetConnectionManager *instance = nil;
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        if(instance == nil) {
            instance = [[AdsforceNetConnectionManager alloc] init];
        }
    });
    return instance;
}

- (void)createReachability {
    //dispatch_async(dispatch_get_main_queue(), ^{
        _internetReachable = [AdsforceNetReachability reachabilityForInternetConnection];
        [_internetReachable startNotifier];
        [self startObserver];
    //});
    
}

- (BOOL)isWifiConneted {
    return AdsforceNetReachableViaWiFi == [self currentConnectionStatus];
}

- (BOOL)isNetworkConneted {
    return AdsforceNetNotReachable != [self currentConnectionStatus];
}

- (AdsforceNetWorkStatus)currentConnectionStatus {
   return [_internetReachable currentReachabilityStatus];
}

- (void)startObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkStatus:)
                                                 name:kAdsforceNetReachabilityChangedNotification
                                               object:nil];
    //_hostReachable = [[Reachability reachabilityWithHostName:@"www.apple.com"] retain];
    //[_hostReachable startNotifier];
}

- (void)addConnectionCallback:(id<AdsforceNetConnectionCallback>)callback {
    if(!_callbackArys) {
        _callbackArys = [[NSMutableArray<AdsforceNetConnectionCallback> alloc] init];
    }
    if(callback) {
        @synchronized (_callbackArys) {
            if (![_callbackArys containsObject:callback]) {
                [_callbackArys addObject:callback];
            }
        }
    }
}

- (void)removeConnectionCallback:(id<AdsforceNetConnectionCallback>)callback {
    if(_callbackArys) {
        @synchronized (_callbackArys) {
            if ([_callbackArys containsObject:callback]) {
                [_callbackArys removeObject:callback];
            }
        }
    }
}

- (void)checkNetworkStatus:(NSNotification *)notice {
    if(_callbackArys) {
        AdsforceNetWorkStatus status = [self currentConnectionStatus];
        NSMutableArray<AdsforceNetConnectionCallback> *arys = [[NSMutableArray<AdsforceNetConnectionCallback> alloc]
                                                             initWithArray:_callbackArys];
        for(id<AdsforceNetConnectionCallback> c in arys) {
            [c onConnectionChanged:status];
        }
        
    }
}

@end
