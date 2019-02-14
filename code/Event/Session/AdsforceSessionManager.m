//
//  AdsforceSessionManager.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/14.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import "AdsforceSessionManager.h"
#import <UIKit/UIKit.h>
#import "AdsforceSessionModel.h"
#import "AdsforceMd5Utils.h"
#import "AdsforceFileCache.h"
#import "AdsforceSessionSend.h"

#define TIMER_SESSION_INTERVAL      (300)
#define START_SESSION_MIN_INTERVAL  (300)
#define END_SESSION_MIN_INTERVAL    (300)

@interface AdsforceSessionManager () {
    NSString *_sessionId;
    NSTimer *_timer;
    NSDate *_lastStartSessionDate;
    NSDate *_lastEndSessionDate;
}
@end

@implementation AdsforceSessionManager

static AdsforceSessionManager *manager;

#pragma mark - shareInstancetype

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(manager == nil) {
            manager = [[AdsforceSessionManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self listenApplicationDidBecomeActive];
        [self listenApplicationWillResignActive];
        
        // In order to prevent the cp initialization time from being delayed,
        // the UIApplicationDidBecomeActiveNotification notification cannot be received in time,
        // which causes the _timer to fail to initialize. Therefore, the _timer (10s) is initialized in the init.
        if (_timer != nil) {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer timerWithTimeInterval:10
                                         target:self
                                       selector:@selector(timerSession)
                                       userInfo:nil
                                        repeats:NO];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

#pragma mark - Notification

// The listening application becomes active
- (void)listenApplicationDidBecomeActive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

// The listening application becomes inactive
- (void)listenApplicationWillResignActive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

// becomes active
- (void)becomeActive {
    #ifdef UPLTVAdsforceSDKDEBUG
        NSLog(@"[AdsforceSDK Log] AppDelegate applicationDidBecomeActive  ---Become active---");
    #endif
    
    [self startSession];
}

// becomes inactive
- (void)resignActive {
    #ifdef UPLTVAdsforceSDKDEBUG
        NSLog(@"[AdsforceSDK Log] AppDelegate applicationWillResignActive  ---Become inactive---");
    #endif
    
    [self endSession];
}

#pragma mark - Session

// Start session
- (void)startSession {
    if (_lastStartSessionDate) {
        NSTimeInterval lastSatrtInterval = [[NSDate date] timeIntervalSinceDate:_lastStartSessionDate];
        if (lastSatrtInterval < START_SESSION_MIN_INTERVAL) {
            return;
        }
    }
    
    _sessionId = [AdsforceMd5Utils MD5OfString:[[NSUUID UUID] UUIDString]];
    NSString *uuid = [AdsforceMd5Utils MD5OfString:[NSUUID UUID].UUIDString];
    AdsforceSessionModel *model = [[AdsforceSessionModel alloc] initWithSessionId:_sessionId
                                                                         type:AdsforceSessionModelTypeStart
                                                                         uuid:uuid];
    [self sendSession:model];
    
    _lastStartSessionDate = [NSDate date];
    
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer timerWithTimeInterval:TIMER_SESSION_INTERVAL
                                     target:self
                                   selector:@selector(timerSession)
                                   userInfo:nil
                                    repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

// End session
- (void)endSession {
    if (_lastEndSessionDate) {
        NSTimeInterval lastSatrtInterval = [[NSDate date] timeIntervalSinceDate:_lastEndSessionDate];
        if (lastSatrtInterval < END_SESSION_MIN_INTERVAL) {
            return;
        }
    }
    
    if (_sessionId == nil || [_sessionId isEqualToString:@""]) {
        _sessionId = [AdsforceMd5Utils MD5OfString:[[NSUUID UUID] UUIDString]];
    }
    NSString *uuid = [AdsforceMd5Utils MD5OfString:[NSUUID UUID].UUIDString];
    AdsforceSessionModel *model = [[AdsforceSessionModel alloc] initWithSessionId:_sessionId
                                                                         type:AdsforceSessionModelTypeEnd
                                                                         uuid:uuid];
    [self sendSession:model];
    
    _lastEndSessionDate = [NSDate date];
    
    _sessionId = nil;
    
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

// Timer session
- (void)timerSession {
    if (_sessionId == nil || [_sessionId isEqualToString:@""]) {
        _sessionId = [AdsforceMd5Utils MD5OfString:[[NSUUID UUID] UUIDString]];
    }
    NSString *uuid = [AdsforceMd5Utils MD5OfString:[NSUUID UUID].UUIDString];
    AdsforceSessionModel *model = [[AdsforceSessionModel alloc] initWithSessionId:_sessionId
                                                                         type:AdsforceSessionModelTypeTimer
                                                                         uuid:uuid];
    [self sendSession:model];
    
    _timer = [NSTimer timerWithTimeInterval:TIMER_SESSION_INTERVAL
                                     target:self
                                   selector:@selector(timerSession)
                                   userInfo:nil
                                    repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

#pragma mark - OpenSession
- (void)sendOpenSession {
    if (_sessionId == nil || [_sessionId isEqualToString:@""]) {
        _sessionId = [AdsforceMd5Utils MD5OfString:[[NSUUID UUID] UUIDString]];
    }
    NSString *uuid = [AdsforceMd5Utils MD5OfString:[NSUUID UUID].UUIDString];
    AdsforceSessionModel *model = [[AdsforceSessionModel alloc] initWithSessionId:_sessionId
                                                                         type:AdsforceSessionModelTypeOpen
                                                                         uuid:uuid];
    [self sendSession:model];
}

#pragma mark - CacheSession

- (void)cacheSession:(AdsforceSessionModel *)sessionModel {
    // Write session model to file chache
    NSDictionary *sessionDic = [AdsforceSessionModel convertDicWithModel:sessionModel];
    [[AdsforceFileCache shareInstance] writeDic:sessionDic
                                  channelType:AdsforceFileCacheChannelTypeAdvertiser
                                     pathType:AdsforceFileCachePathTypeSession];
    [[AdsforceFileCache shareInstance] writeDic:sessionDic
                                  channelType:AdsforceFileCacheChannelTypeAdsforce
                                     pathType:AdsforceFileCachePathTypeSession];
}

#pragma mark - sendSession

- (void)sendSession:(AdsforceSessionModel *)sessionModel {
    [self cacheSession:sessionModel];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self sendAdvertiserSession:sessionModel];
        [self sendAdsforceSession:sessionModel];
    });
    
    #ifdef UPLTVAdsforceSDKDEBUG
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLTVAdsforceSDKDEBUGSENDSESSION"
                                                        object:sessionModel];
    #endif
}

- (void)sendAdvertiserSession:(AdsforceSessionModel *)sessionModel {
    [AdsforceSessionSend sendAdvertiserSession:sessionModel];
}

- (void)sendAdsforceSession:(AdsforceSessionModel *)sessionModel {
    [AdsforceSessionSend sendAdsforceSession:sessionModel];
}

#pragma mark - checkDefeatedSessionAndSend

- (void)checkDefeatedSessionAndSend {
    // Get the advertiser model that failed to send before and send.
    NSArray *defeatedAdvertiserSessionDics = [[AdsforceFileCache shareInstance] getArrayWithChannelType:AdsforceFileCacheChannelTypeAdvertiser
                                                                                             pathType:AdsforceFileCachePathTypeSession];
    for (int i = 0; i < defeatedAdvertiserSessionDics.count; i++) {
        NSDictionary *sessionDic = [defeatedAdvertiserSessionDics objectAtIndex:i];
        AdsforceSessionModel *sessionModel = [AdsforceSessionModel convertModelWithDic:sessionDic];
        if (sessionModel == nil) {
            continue;
        }
        [self sendAdvertiserSession:sessionModel];
    }
    
    // Get the adsforce model that failed to send before and send.
    NSArray *defeatedAdsforceSessionDics = [[AdsforceFileCache shareInstance] getArrayWithChannelType:AdsforceFileCacheChannelTypeAdsforce
                                                                                          pathType:AdsforceFileCachePathTypeSession];
    for (int i = 0; i < defeatedAdsforceSessionDics.count; i++) {
        NSDictionary *sessionDic = [defeatedAdsforceSessionDics objectAtIndex:i];
        AdsforceSessionModel *sessionModel = [AdsforceSessionModel convertModelWithDic:sessionDic];
        if (sessionModel == nil) {
            continue;
        }
        [self sendAdsforceSession:sessionModel];
    }
}

- (void)checkDefeatedSessionAndSendWithChildThread {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self checkDefeatedSessionAndSend];
    });
}

#pragma mark - SessionId

- (NSString *)getCurrentSessionId {
    if (_sessionId == nil) {
        return @"";
    }
    return _sessionId;
}

@end
