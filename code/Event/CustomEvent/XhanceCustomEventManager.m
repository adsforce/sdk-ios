//
//  XhanceCustomEventManager.m
//  XhanceSDK
//
//

#import "XhanceCustomEventManager.h"
#import "XhanceCustomEventSend.h"
#import "XhanceCustomEventParameter.h"
#import "XhanceFileCache.h"

BOOL CustomEventOpen;

@implementation XhanceCustomEventManager

+ (void)enableCustomerEvent:(BOOL)enable {
    CustomEventOpen = enable;
}

+ (void)customEventWithKey:(NSString *)key value:(NSObject *)value {
    
    if (!CustomEventOpen) {
        NSLog(@"[XhanceSDK Log Warning] SDK cannot use custom events. Please check!");
        return;
    }
    
    XhanceCustomEventModel *model = [[XhanceCustomEventModel alloc] initWithKey:key value:value];
    [self sendModel:model];
}

#pragma mark - CacheModel

+ (void)cacheModel:(XhanceCustomEventModel *)model {
    // Write customEvent model to file chache
    NSDictionary *customEventDic = [XhanceCustomEventModel convertDicWithModel:model];
    [[XhanceFileCache shareInstance] writeDic:customEventDic
                                  channelType:XhanceFileCacheChannelTypeAdvertiser
                                     pathType:XhanceFileCachePathTypeCustomEvent];
    [[XhanceFileCache shareInstance] writeDic:customEventDic
                                  channelType:XhanceFileCacheChannelTypeXhance
                                     pathType:XhanceFileCachePathTypeCustomEvent];
}

#pragma mark - sendModel

+ (void)sendModel:(XhanceCustomEventModel *)model {
    [self cacheModel:model];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self sendAdvertiserCustomEvent:model];
        [self sendXhanceCustomEvent:model];
    });
}

+ (void)sendAdvertiserCustomEvent:(XhanceCustomEventModel *)model {
    [XhanceCustomEventSend sendAdvertiserCustomEvent:model];
}

+ (void)sendXhanceCustomEvent:(XhanceCustomEventModel *)model {
    [XhanceCustomEventSend sendXhanceCustomEvent:model];
}

#pragma mark - checkDefeatedCustomEventAndSend

+ (void)checkDefeatedCustomEventAndSend {
    // Get the advertiser model that failed to send before and send.
    NSArray *defeatedAdvertiserCustomEventDics = [[XhanceFileCache shareInstance] getArrayWithChannelType:XhanceFileCacheChannelTypeAdvertiser
                                                                                             pathType:XhanceFileCachePathTypeCustomEvent];
    for (int i = 0; i < defeatedAdvertiserCustomEventDics.count; i++) {
        NSDictionary *customEventDic = [defeatedAdvertiserCustomEventDics objectAtIndex:i];
        XhanceCustomEventModel *customEventModel = [XhanceCustomEventModel convertModelWithDic:customEventDic];
        if (customEventModel == nil) {
            continue;
        }
        [self sendAdvertiserCustomEvent:customEventModel];
    }
    
    // Get the xhance model that failed to send before and send.
    NSArray *defeatedXhanceCustomEventDics = [[XhanceFileCache shareInstance] getArrayWithChannelType:XhanceFileCacheChannelTypeXhance
                                                                                          pathType:XhanceFileCachePathTypeCustomEvent];
    for (int i = 0; i < defeatedXhanceCustomEventDics.count; i++) {
        NSDictionary *customEventDic = [defeatedXhanceCustomEventDics objectAtIndex:i];
        XhanceCustomEventModel *customEventModel = [XhanceCustomEventModel convertModelWithDic:customEventDic];
        if (customEventModel == nil) {
            continue;
        }
        [self sendXhanceCustomEvent:customEventModel];
    }
}

+ (void)checkDefeatedCustomEventAndSendWithChildThread {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self checkDefeatedCustomEventAndSend];
    });
}

@end
