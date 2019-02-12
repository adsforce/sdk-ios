//
//  AvidlyConnectionManager.h
//  AvidlyAdsSDK
//
//  Created by samliu on 2017/4/19.
//

#import <Foundation/Foundation.h>
#import "XhanceNetReachability.h"

@protocol XhanceNetConnectionCallback <NSObject>

@required

- (void)onConnectionChanged:(XhanceNetWorkStatus)status;

@end

@interface XhanceNetConnectionManager : NSObject

+ (instancetype)sharedInstance;

- (void)createReachability;

- (XhanceNetWorkStatus)currentConnectionStatus;

- (BOOL)isNetworkConneted;

- (BOOL)isWifiConneted;

- (void)addConnectionCallback:(id<XhanceNetConnectionCallback>)callback;

- (void)removeConnectionCallback:(id<XhanceNetConnectionCallback>)callback;

@end
