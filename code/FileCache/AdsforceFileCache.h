//
//  AdsforceFileCache.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/8/27.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, AdsforceFileCachePathType) {
    AdsforceFileCachePathTypeSession      = 0,
    AdsforceFileCachePathTypeIAP          = 1,
    AdsforceFileCachePathTypeCustomEvent  = 2,
};

typedef NS_ENUM (NSInteger, AdsforceFileCacheChannelType) {
    AdsforceFileCacheChannelTypeAdvertiser    = 0,
    AdsforceFileCacheChannelTypeAdsforce       = 1,
};

@interface AdsforceFileCache : NSObject

+ (instancetype)shareInstance;

- (void)writeDic:(NSDictionary *)dic channelType:(AdsforceFileCacheChannelType)channelType pathType:(AdsforceFileCachePathType)pathType;

- (void)removeDic:(NSDictionary *)dic channelType:(AdsforceFileCacheChannelType)channelType pathType:(AdsforceFileCachePathType)pathType;

- (NSArray <NSDictionary *> *)getArrayWithChannelType:(AdsforceFileCacheChannelType)channelType pathType:(AdsforceFileCachePathType)pathType;

@end
