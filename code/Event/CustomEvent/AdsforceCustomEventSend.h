//
//  AdsforceCustomEventSend.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/8/22.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdsforceCustomEventParameter.h"
#import "AdsforceCustomEventModel.h"

@interface AdsforceCustomEventSend : NSObject

+ (void)sendAdvertiserCustomEvent:(AdsforceCustomEventModel *)customEventParameter;

+ (void)sendAdsforceCustomEvent:(AdsforceCustomEventModel *)customEventParameter;

@end
