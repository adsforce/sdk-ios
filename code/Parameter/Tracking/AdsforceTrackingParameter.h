//
//  AdsforceTrackingParameter.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/17.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdsforceBaseParameter.h"

@interface AdsforceTrackingParameter : AdsforceBaseParameter

- (instancetype)initWithReferrer:(NSString *)referrer;
- (instancetype)initWithReferrer:(NSString *)referrer uuid:(NSString *)uuidString;

@end
