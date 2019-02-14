//
//  AvidlyConnectionManager.h
//  AvidlyAdsSDK
//
//  Created by samliu on 2017/4/19.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdsforceNetReachability.h"

@protocol AdsforceNetConnectionCallback <NSObject>

@required

- (void)onConnectionChanged:(AdsforceNetWorkStatus)status;

@end

@interface AdsforceNetConnectionManager : NSObject

+ (instancetype)sharedInstance;

- (void)createReachability;

- (AdsforceNetWorkStatus)currentConnectionStatus;

- (BOOL)isNetworkConneted;

- (BOOL)isWifiConneted;

- (void)addConnectionCallback:(id<AdsforceNetConnectionCallback>)callback;

- (void)removeConnectionCallback:(id<AdsforceNetConnectionCallback>)callback;

@end
