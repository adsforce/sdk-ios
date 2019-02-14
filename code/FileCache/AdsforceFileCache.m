//
//  AdsforceFileCache.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/8/27.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import "AdsforceFileCache.h"

#define AdsforceSDKSessionAdvertiserFilePath      [[NSString alloc] initWithFormat:@"%@/AdsforceSDKAdvertiserSession.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]
#define AdsforceSDKSessionAdsforceFilePath         [[NSString alloc] initWithFormat:@"%@/AdsforceSDKAdsforceSession.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

#define AdsforceSDKIAPAdvertiserFilePath      [[NSString alloc] initWithFormat:@"%@/AdsforceSDKAdvertiserIAP.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]
#define AdsforceSDKIAPAdsforceFilePath         [[NSString alloc] initWithFormat:@"%@/AdsforceSDKAdsforceIAP.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

#define AdsforceSDKCustomEventAdvertiserFilePath      [[NSString alloc] initWithFormat:@"%@/AdsforceSDKAdvertiserCustomEvent.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]
#define AdsforceSDKCustomEventAdsforceFilePath         [[NSString alloc] initWithFormat:@"%@/AdsforceSDKAdsforceCustomEvent.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

@interface AdsforceFileCache () {
    NSString *_sessionAdvertiserFilePath;
    NSString *_sessionAdsforceFilePath;
    
    NSString *_iapAdvertiserFilePath;
    NSString *_iapAdsforceFilePath;
    
    NSString *_customEventAdvertiserFilePath;
    NSString *_customEventAdsforceFilePath;
}
@end

@implementation AdsforceFileCache

static AdsforceFileCache *manager;

#pragma mark - shareInstancetype

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(manager == nil) {
            manager = [[AdsforceFileCache alloc] init];
        }
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _sessionAdvertiserFilePath = AdsforceSDKSessionAdvertiserFilePath;
        _sessionAdsforceFilePath = AdsforceSDKSessionAdsforceFilePath;
        
        _iapAdvertiserFilePath = AdsforceSDKIAPAdvertiserFilePath;
        _iapAdsforceFilePath = AdsforceSDKIAPAdsforceFilePath;
        
        _customEventAdvertiserFilePath = AdsforceSDKCustomEventAdvertiserFilePath;
        _customEventAdsforceFilePath = AdsforceSDKCustomEventAdsforceFilePath;
    }
    return self;
}

#pragma mark - path

- (NSString *)getPathWithChannelType:(AdsforceFileCacheChannelType)channelType pathType:(AdsforceFileCachePathType)pathType {
    if (pathType == AdsforceFileCachePathTypeSession) {
        if (channelType == AdsforceFileCacheChannelTypeAdvertiser) {
            return _sessionAdvertiserFilePath;
        }
        else if (channelType == AdsforceFileCacheChannelTypeAdsforce) {
            return _sessionAdsforceFilePath;
        }
    }
    else if (pathType == AdsforceFileCachePathTypeIAP) {
        if (channelType == AdsforceFileCacheChannelTypeAdvertiser) {
            return _iapAdvertiserFilePath;
        }
        else if (channelType == AdsforceFileCacheChannelTypeAdsforce) {
            return _iapAdsforceFilePath;
        }
    }
    else if (pathType == AdsforceFileCachePathTypeCustomEvent) {
        if (channelType == AdsforceFileCacheChannelTypeAdvertiser) {
            return _customEventAdvertiserFilePath;
        }
        else if (channelType == AdsforceFileCacheChannelTypeAdsforce) {
            return _customEventAdsforceFilePath;
        }
    }
    return nil;
}

#pragma mark - write remove get

- (void)writeDic:(NSDictionary *)dic channelType:(AdsforceFileCacheChannelType)channelType pathType:(AdsforceFileCachePathType)pathType {
    NSString *path = [self getPathWithChannelType:channelType pathType:pathType];
    if (path == nil || [path isEqualToString:@""]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self writeDic:dic path:path];
    });
}

- (void)removeDic:(NSDictionary *)dic channelType:(AdsforceFileCacheChannelType)channelType pathType:(AdsforceFileCachePathType)pathType {
    NSString *path = [self getPathWithChannelType:channelType pathType:pathType];
    if (path == nil || [path isEqualToString:@""]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self removeDic:dic path:path];
    });
}

- (NSArray <NSDictionary *> *)getArrayWithChannelType:(AdsforceFileCacheChannelType)channelType pathType:(AdsforceFileCachePathType)pathType {
    NSString *path = [self getPathWithChannelType:channelType pathType:pathType];
    if (path == nil || [path isEqualToString:@""]) {
        return nil;
    }
    return [self getArrayForPath:path];
}

#pragma makr - write remove session

- (void)writeDic:(NSDictionary *)dic path:(NSString *)path {
    
    @synchronized(path) {
        NSDictionary *writeDic = dic;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            [fileManager createFileAtPath:path contents:nil attributes:nil];
        }
        
        NSArray *arr = [[NSArray alloc] initWithContentsOfFile:path];
        
        NSMutableArray *mArr;
        if (arr == nil) {
            mArr = [[NSMutableArray alloc] init];
        }
        else {
            mArr = [[NSMutableArray alloc] initWithArray:arr];
        }
        [mArr addObject:writeDic];
        
        [mArr writeToFile:path atomically:YES];
    }
}

- (void)removeDic:(NSDictionary *)dic path:(NSString *)path {

    @synchronized(path) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:path]) {
            return;
        }
        
        NSArray *arr = [[NSArray alloc] initWithContentsOfFile:path];
        
        if (arr == nil) {
            return;
        }
        
        NSDictionary *removeDic = dic;
        NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:arr];
        
        BOOL isRemove = NO;
        for (int i = 0; i < mArr.count; i++) {
            NSDictionary *temporaryDic = [mArr objectAtIndex:i];
            if ([removeDic isEqualToDictionary:temporaryDic]) {
                [mArr removeObject:temporaryDic];
                isRemove = YES;
            }
        }
        
        if (!isRemove) {
            return;
        }
        
        [mArr writeToFile:path atomically:YES];
    }
}

- (NSArray <NSDictionary *> *)getArrayForPath:(NSString *)path {
    
    @synchronized(path) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:path]) {
            return nil;
        }
        
        NSArray *arr = [[NSArray alloc] initWithContentsOfFile:path];
        
        if (arr == nil) {
            return nil;
        }
        
        NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:arr];
        return mArr;
    }
}

@end
