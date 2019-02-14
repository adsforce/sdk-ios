//
//  AdsforceCustomEventManager.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/8/22.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import "AdsforceCustomEventManager.h"
#import "AdsforceCustomEventSend.h"
#import "AdsforceCustomEventParameter.h"
#import "AdsforceFileCache.h"

BOOL CustomEventOpen;

@implementation AdsforceCustomEventManager

+ (void)enableCustomerEvent:(BOOL)enable {
    CustomEventOpen = enable;
}

+ (void)customEventWithKey:(NSString *)key value:(NSObject *)value {
    
    if (!CustomEventOpen) {
        NSLog(@"[AdsforceSDK Log Warning] SDK cannot use custom events. Please check!");
        return;
    }
    
    AdsforceCustomEventModel *model = [[AdsforceCustomEventModel alloc] initWithKey:key value:value];
    [self sendModel:model];
}

+ (void)mandatoryCustomEventWithKey:(NSString *)key value:(NSObject *)value {
    AdsforceCustomEventModel *model = [[AdsforceCustomEventModel alloc] initWithKey:key value:value];
    [self sendModel:model];
}

#pragma mark - CacheModel

+ (void)cacheModel:(AdsforceCustomEventModel *)model {
    // Write customEvent model to file chache
    NSDictionary *customEventDic = [AdsforceCustomEventModel convertDicWithModel:model];
    [[AdsforceFileCache shareInstance] writeDic:customEventDic
                                  channelType:AdsforceFileCacheChannelTypeAdvertiser
                                     pathType:AdsforceFileCachePathTypeCustomEvent];
    [[AdsforceFileCache shareInstance] writeDic:customEventDic
                                  channelType:AdsforceFileCacheChannelTypeAdsforce
                                     pathType:AdsforceFileCachePathTypeCustomEvent];
}

#pragma mark - sendModel

+ (void)sendModel:(AdsforceCustomEventModel *)model {
    [self cacheModel:model];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self sendAdvertiserCustomEvent:model];
        [self sendAdsforceCustomEvent:model];
    });
}

+ (void)sendAdvertiserCustomEvent:(AdsforceCustomEventModel *)model {
    [AdsforceCustomEventSend sendAdvertiserCustomEvent:model];
}

+ (void)sendAdsforceCustomEvent:(AdsforceCustomEventModel *)model {
    [AdsforceCustomEventSend sendAdsforceCustomEvent:model];
}

#pragma mark - checkDefeatedCustomEventAndSend

+ (void)checkDefeatedCustomEventAndSend {
    // Get the advertiser model that failed to send before and send.
    NSArray *defeatedAdvertiserCustomEventDics = [[AdsforceFileCache shareInstance] getArrayWithChannelType:AdsforceFileCacheChannelTypeAdvertiser
                                                                                             pathType:AdsforceFileCachePathTypeCustomEvent];
    for (int i = 0; i < defeatedAdvertiserCustomEventDics.count; i++) {
        NSDictionary *customEventDic = [defeatedAdvertiserCustomEventDics objectAtIndex:i];
        AdsforceCustomEventModel *customEventModel = [AdsforceCustomEventModel convertModelWithDic:customEventDic];
        if (customEventModel == nil) {
            continue;
        }
        [self sendAdvertiserCustomEvent:customEventModel];
    }
    
    // Get the adsforce model that failed to send before and send.
    NSArray *defeatedAdsforceCustomEventDics = [[AdsforceFileCache shareInstance] getArrayWithChannelType:AdsforceFileCacheChannelTypeAdsforce
                                                                                          pathType:AdsforceFileCachePathTypeCustomEvent];
    for (int i = 0; i < defeatedAdsforceCustomEventDics.count; i++) {
        NSDictionary *customEventDic = [defeatedAdsforceCustomEventDics objectAtIndex:i];
        AdsforceCustomEventModel *customEventModel = [AdsforceCustomEventModel convertModelWithDic:customEventDic];
        if (customEventModel == nil) {
            continue;
        }
        [self sendAdsforceCustomEvent:customEventModel];
    }
}

+ (void)checkDefeatedCustomEventAndSendWithChildThread {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self checkDefeatedCustomEventAndSend];
    });
}

@end
