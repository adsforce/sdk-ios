//
//  KTrackingManager.h
//  testSafariVC
//
//

#import <Foundation/Foundation.h>

@interface XhanceTrackingManager : NSObject

+ (instancetype)shareInstance;

- (void)trackingWithPublicKey:(NSString *)publicKey;

@end
