//
//  XhanceCustomEventManager.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>

@interface XhanceCustomEventManager : NSObject

+ (void)enableCustomerEvent:(BOOL)enable;

+ (void)customEventWithKey:(NSString *)key value:(NSObject *)value;

+ (void)checkDefeatedCustomEventAndSendWithChildThread;

@end
