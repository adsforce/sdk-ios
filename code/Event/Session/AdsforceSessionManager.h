//
//  AdsforceSessionManager.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/14.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdsforceSessionManager : NSObject

+ (instancetype)shareInstance;

#pragma mark - checkDefeatedSessionAndSendWithChildThread
- (void)checkDefeatedSessionAndSendWithChildThread;

#pragma mark - SessionId
- (NSString *)getCurrentSessionId;

#pragma mark - OpenSession
- (void)sendOpenSession;

@end
