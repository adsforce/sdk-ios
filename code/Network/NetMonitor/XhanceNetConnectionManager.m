//
//  AvidlyConnectionManager.m
//  AvidlyAdsSDK
//
//  Created by samliu on 2017/4/19.
//

#import "XhanceNetConnectionManager.h"
#import <Foundation/Foundation.h>


@interface XhanceNetConnectionManager () {
    XhanceNetReachability *_internetReachable;
    //Reachability *_hostReachable;
    NSMutableArray<XhanceNetConnectionCallback> *_callbackArys;
    
}

@end

@implementation XhanceNetConnectionManager

+ (instancetype)sharedInstance {
    static XhanceNetConnectionManager *instance = nil;
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        if(instance == nil) {
            instance = [[XhanceNetConnectionManager alloc] init];
        }
    });
    return instance;
}

- (void)createReachability {
    //dispatch_async(dispatch_get_main_queue(), ^{
        _internetReachable = [XhanceNetReachability reachabilityForInternetConnection];
        [_internetReachable startNotifier];
        [self startObserver];
    //});
    
}

- (BOOL)isWifiConneted {
    return XhanceNetReachableViaWiFi == [self currentConnectionStatus];
}

- (BOOL)isNetworkConneted {
    return XhanceNetNotReachable != [self currentConnectionStatus];
}

- (XhanceNetWorkStatus)currentConnectionStatus {
   return [_internetReachable currentReachabilityStatus];
}

- (void)startObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkStatus:)
                                                 name:kXhanceNetReachabilityChangedNotification
                                               object:nil];
    //_hostReachable = [[Reachability reachabilityWithHostName:@"www.apple.com"] retain];
    //[_hostReachable startNotifier];
}

- (void)addConnectionCallback:(id<XhanceNetConnectionCallback>)callback {
    if(!_callbackArys) {
        _callbackArys = [[NSMutableArray<XhanceNetConnectionCallback> alloc] init];
    }
    if(callback) {
        @synchronized (_callbackArys) {
            if (![_callbackArys containsObject:callback]) {
                [_callbackArys addObject:callback];
            }
        }
    }
}

- (void)removeConnectionCallback:(id<XhanceNetConnectionCallback>)callback {
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
        XhanceNetWorkStatus status = [self currentConnectionStatus];
        NSMutableArray<XhanceNetConnectionCallback> *arys = [[NSMutableArray<XhanceNetConnectionCallback> alloc]
                                                             initWithArray:_callbackArys];
        for(id<XhanceNetConnectionCallback> c in arys) {
            [c onConnectionChanged:status];
        }
        
    }
}

@end
