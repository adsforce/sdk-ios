//
//  AdsforceIAPSend.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/31.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdsforceIAPParameter.h"

@interface AdsforceIAPSend : NSObject

+ (void)sendAdvertiserIAP:(AdsforceIAPModel *)iapModel;

+ (void)sendAdsforceIAP:(AdsforceIAPModel *)iapModel;

@end
