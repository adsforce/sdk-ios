//
//  XhanceSessionFileCache.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>
#import "XhanceSessionModel.h"

@interface XhanceSessionFileCache : NSObject

+ (instancetype)shareInstance;

#pragma mark - AdvertiserSession

- (void)writeAdvertiserSession:(XhanceSessionModel *)sessionModel;

- (void)removeAdvertiserSession:(XhanceSessionModel *)sessionModel;

- (NSArray <XhanceSessionModel *> *)getAdvertiserSessions;

#pragma mark - XhanceSession

- (void)writeXhanceSession:(XhanceSessionModel *)sessionModel;

- (void)removeXhanceSession:(XhanceSessionModel *)sessionModel;

- (NSArray <XhanceSessionModel *> *)getXhanceSessions;

@end
