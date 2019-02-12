//
//  XhanceSessionManager.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>

@interface XhanceSessionManager : NSObject

+ (instancetype)shareInstance;

#pragma mark - checkDefeatedSessionAndSendWithChildThread
- (void)checkDefeatedSessionAndSendWithChildThread;

#pragma mark - SessionId
- (NSString *)getCurrentSessionId;

@end
