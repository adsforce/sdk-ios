//
//  XhanceCustomEventSend.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>
#import "XhanceCustomEventParameter.h"
#import "XhanceCustomEventModel.h"

@interface XhanceCustomEventSend : NSObject

+ (void)sendAdvertiserCustomEvent:(XhanceCustomEventModel *)customEventParameter;

+ (void)sendXhanceCustomEvent:(XhanceCustomEventModel *)customEventParameter;

@end
