//
//  XhanceDeeplinkManager.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>
#import "XhanceTrackingParameter.h"
#import "XhanceDeeplinkModel.h"

@interface XhanceDeeplinkManager : NSObject

+ (BOOL)canGetDeeplink;

+ (void)getDeeplinkWithServer:(XhanceTrackingParameter *)parameter;

+ (void)getDeeplink:(void (^)(XhanceDeeplinkModel *deeplinkModel))completionBlock;

@end
