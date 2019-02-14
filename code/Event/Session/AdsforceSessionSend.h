//
//  AdsforceSessionSend.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/17.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdsforceSessionModel.h"

@interface AdsforceSessionSend : NSObject

+ (void)sendAdvertiserSession:(AdsforceSessionModel *)sessionModel;

+ (void)sendAdsforceSession:(AdsforceSessionModel *)sessionModel;

@end
