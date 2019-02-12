//
//  XhanceFileCache.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, XhanceFileCachePathType) {
    XhanceFileCachePathTypeSession      = 0,
    XhanceFileCachePathTypeIAP          = 1,
    XhanceFileCachePathTypeCustomEvent  = 2,
};

typedef NS_ENUM (NSInteger, XhanceFileCacheChannelType) {
    XhanceFileCacheChannelTypeAdvertiser    = 0,
    XhanceFileCacheChannelTypeXhance       = 1,
};

@interface XhanceFileCache : NSObject

+ (instancetype)shareInstance;

- (void)writeDic:(NSDictionary *)dic channelType:(XhanceFileCacheChannelType)channelType pathType:(XhanceFileCachePathType)pathType;

- (void)removeDic:(NSDictionary *)dic channelType:(XhanceFileCacheChannelType)channelType pathType:(XhanceFileCachePathType)pathType;

- (NSArray <NSDictionary *> *)getArrayWithChannelType:(XhanceFileCacheChannelType)channelType pathType:(XhanceFileCachePathType)pathType;

@end
