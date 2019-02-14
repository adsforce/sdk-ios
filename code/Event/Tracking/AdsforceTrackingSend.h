//
//  AdsforceTrackingSend.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/7/30.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdsforceTrackingSend : NSObject

- (void)safariTrack:(NSString *)urlStr completion:(void (^)(BOOL didLoadSuccessfully))completionBlock;

@end
