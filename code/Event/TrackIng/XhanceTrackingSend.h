//
//  XhanceTrackingSend.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>

@interface XhanceTrackingSend : NSObject

- (void)safariTrack:(NSString *)urlStr completion:(void (^)(BOOL didLoadSuccessfully))completionBlock;

@end
