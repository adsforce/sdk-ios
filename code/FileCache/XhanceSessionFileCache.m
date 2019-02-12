//
//  XhanceSessionFileCache.m
//  XhanceSDK
//
//

#import "XhanceSessionFileCache.h"

#define XhanceSDKSessionAdvertiserFilePath    [[NSString alloc] initWithFormat:@"%@/XhanceSDKAdvertiserSession.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]
#define XhanceSDKSessionXhanceFilePath    [[NSString alloc] initWithFormat:@"%@/XhanceSDKXhanceSession.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

@interface XhanceSessionFileCache () {
    NSString *_advertiserFilePath;
    NSString *_xhanceFilePath;
}
@end

@implementation XhanceSessionFileCache

static XhanceSessionFileCache *manager;

#pragma mark - shareInstancetype

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(manager == nil) {
            manager = [[XhanceSessionFileCache alloc] init];
        }
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _advertiserFilePath = XhanceSDKSessionAdvertiserFilePath;
        _xhanceFilePath = XhanceSDKSessionXhanceFilePath;
    }
    return self;
}

#pragma mark - AdvertiserSession

- (void)writeAdvertiserSession:(XhanceSessionModel *)sessionModel {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self writeSession:sessionModel path:_advertiserFilePath];
    });
}

- (void)removeAdvertiserSession:(XhanceSessionModel *)sessionModel {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self removeSession:sessionModel path:_advertiserFilePath];
    });
}

- (NSArray <XhanceSessionModel *> *)getAdvertiserSessions {
    return [self getSessionsForPath:_advertiserFilePath];
}

#pragma mark - XhanceSession

- (void)writeXhanceSession:(XhanceSessionModel *)sessionModel {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self writeSession:sessionModel path:_xhanceFilePath];
    });
}

- (void)removeXhanceSession:(XhanceSessionModel *)sessionModel {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self removeSession:sessionModel path:_xhanceFilePath];
    });
}

- (NSArray <XhanceSessionModel *> *)getXhanceSessions {
    return [self getSessionsForPath:_xhanceFilePath];
}

#pragma makr - write remove session

- (void)writeSession:(XhanceSessionModel *)sessionModel path:(NSString *)path {
    
    @synchronized(path) {
        #ifdef UPLTVXhanceSDKDEBUG
            NSLog(@"[XhanceSDK Log] writeSession %@ %@ %i",
                  sessionModel.sessionID,
                  sessionModel.clientTime,
                  (int)sessionModel.dataType);
        #endif
        
        NSDictionary *sessionDic = [XhanceSessionModel convertDicWithModel:sessionModel];
        
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
        [mArr addObject:sessionDic];
        
        [mArr writeToFile:path atomically:YES];
    }
}

- (void)removeSession:(XhanceSessionModel *)sessionModel path:(NSString *)path {
    
    @synchronized(path) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:path]) {
            return;
        }
        
        NSArray *arr = [[NSArray alloc] initWithContentsOfFile:path];
        
        if (arr == nil) {
            return;
        }
        
        NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:arr];
        
        BOOL isRemove = NO;
        for (int i = 0; i < mArr.count; i++) {
            NSDictionary *dic = [mArr objectAtIndex:i];
            XhanceSessionModel *cSession = [XhanceSessionModel convertModelWithDic:dic];
            if ([cSession.sessionID isEqualToString:sessionModel.sessionID]
                && cSession.dataType == sessionModel.dataType) {
                
                #ifdef UPLTVXhanceSDKDEBUG
                    NSLog(@"[XhanceSDK Log] before remove mArr count %i",(int)mArr.count);
                #endif
                
                [mArr removeObject:dic];
                isRemove = YES;
                
                #ifdef UPLTVXhanceSDKDEBUG
                    NSLog(@"[XhanceSDK Log] remove %@ dataType:%i",cSession.sessionID,(int)cSession.dataType);
                    NSLog(@"[XhanceSDK Log] after remove mArr count %i",(int)mArr.count);
                #endif
                
            }
        }
        
        if (!isRemove) {

            #ifdef UPLTVXhanceSDKDEBUG
                NSLog(@"[XhanceSDK Log] isRemove is false");
            #endif
            return;
        }
        
        #ifdef UPLTVXhanceSDKDEBUG
            NSLog(@"[XhanceSDK Log] Write mArr");
        #endif
        
        [mArr writeToFile:path atomically:YES];
    }
}

- (NSArray <XhanceSessionModel *> *)getSessionsForPath:(NSString *)path {
    
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
        NSMutableArray *mSessionArr = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < mArr.count; i++) {
            NSDictionary *dic = [mArr objectAtIndex:i];
            XhanceSessionModel *cSession = [XhanceSessionModel convertModelWithDic:dic];
            [mSessionArr addObject:cSession];
        }
        
        return mSessionArr;
    }
}

@end
