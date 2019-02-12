//
//  XhanceFileCache.m
//  XhanceSDK
//
//

#import "XhanceFileCache.h"

#define XhanceSDKSessionAdvertiserFilePath      [[NSString alloc] initWithFormat:@"%@/XhanceSDKAdvertiserSession.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]
#define XhanceSDKSessionXhanceFilePath         [[NSString alloc] initWithFormat:@"%@/XhanceSDKXhanceSession.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

#define XhanceSDKIAPAdvertiserFilePath      [[NSString alloc] initWithFormat:@"%@/XhanceSDKAdvertiserIAP.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]
#define XhanceSDKIAPXhanceFilePath         [[NSString alloc] initWithFormat:@"%@/XhanceSDKXhanceIAP.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

#define XhanceSDKCustomEventAdvertiserFilePath      [[NSString alloc] initWithFormat:@"%@/XhanceSDKAdvertiserCustomEvent.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]
#define XhanceSDKCustomEventXhanceFilePath         [[NSString alloc] initWithFormat:@"%@/XhanceSDKXhanceCustomEvent.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

@interface XhanceFileCache () {
    NSString *_sessionAdvertiserFilePath;
    NSString *_sessionXhanceFilePath;
    
    NSString *_iapAdvertiserFilePath;
    NSString *_iapXhanceFilePath;
    
    NSString *_customEventAdvertiserFilePath;
    NSString *_customEventXhanceFilePath;
}
@end

@implementation XhanceFileCache

static XhanceFileCache *manager;

#pragma mark - shareInstancetype

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(manager == nil) {
            manager = [[XhanceFileCache alloc] init];
        }
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _sessionAdvertiserFilePath = XhanceSDKSessionAdvertiserFilePath;
        _sessionXhanceFilePath = XhanceSDKSessionXhanceFilePath;
        
        _iapAdvertiserFilePath = XhanceSDKIAPAdvertiserFilePath;
        _iapXhanceFilePath = XhanceSDKIAPXhanceFilePath;
        
        _customEventAdvertiserFilePath = XhanceSDKCustomEventAdvertiserFilePath;
        _customEventXhanceFilePath = XhanceSDKCustomEventXhanceFilePath;
    }
    return self;
}

#pragma mark - path

- (NSString *)getPathWithChannelType:(XhanceFileCacheChannelType)channelType pathType:(XhanceFileCachePathType)pathType {
    if (pathType == XhanceFileCachePathTypeSession) {
        if (channelType == XhanceFileCacheChannelTypeAdvertiser) {
            return _sessionAdvertiserFilePath;
        }
        else if (channelType == XhanceFileCacheChannelTypeXhance) {
            return _sessionXhanceFilePath;
        }
    }
    else if (pathType == XhanceFileCachePathTypeIAP) {
        if (channelType == XhanceFileCacheChannelTypeAdvertiser) {
            return _iapAdvertiserFilePath;
        }
        else if (channelType == XhanceFileCacheChannelTypeXhance) {
            return _iapXhanceFilePath;
        }
    }
    else if (pathType == XhanceFileCachePathTypeCustomEvent) {
        if (channelType == XhanceFileCacheChannelTypeAdvertiser) {
            return _customEventAdvertiserFilePath;
        }
        else if (channelType == XhanceFileCacheChannelTypeXhance) {
            return _customEventXhanceFilePath;
        }
    }
    return nil;
}

#pragma mark - write remove get

- (void)writeDic:(NSDictionary *)dic channelType:(XhanceFileCacheChannelType)channelType pathType:(XhanceFileCachePathType)pathType {
    NSString *path = [self getPathWithChannelType:channelType pathType:pathType];
    if (path == nil || [path isEqualToString:@""]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self writeDic:dic path:path];
    });
}

- (void)removeDic:(NSDictionary *)dic channelType:(XhanceFileCacheChannelType)channelType pathType:(XhanceFileCachePathType)pathType {
    NSString *path = [self getPathWithChannelType:channelType pathType:pathType];
    if (path == nil || [path isEqualToString:@""]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self removeDic:dic path:path];
    });
}

- (NSArray <NSDictionary *> *)getArrayWithChannelType:(XhanceFileCacheChannelType)channelType pathType:(XhanceFileCachePathType)pathType {
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
