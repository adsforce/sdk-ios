//
//  XhanceSessionSend.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>
#import "XhanceSessionModel.h"

@interface XhanceSessionSend : NSObject

+ (void)sendAdvertiserSession:(XhanceSessionModel *)sessionModel;

+ (void)sendXhanceSession:(XhanceSessionModel *)sessionModel;

@end
