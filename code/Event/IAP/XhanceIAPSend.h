//
//  XhanceIAPSend.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>
#import "XhanceIAPParameter.h"

@interface XhanceIAPSend : NSObject

+ (void)sendAdvertiserIAP:(XhanceIAPModel *)iapModel;

+ (void)sendXhanceIAP:(XhanceIAPModel *)iapModel;

@end
