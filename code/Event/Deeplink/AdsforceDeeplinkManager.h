//
//  AdsforceDeeplinkManager.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/6/1.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdsforceTrackingParameter.h"
#import "AdsforceDeeplinkModel.h"

@interface AdsforceDeeplinkManager : NSObject

+ (BOOL)canGetDeeplink;

+ (void)getDeeplinkWithServer:(AdsforceTrackingParameter *)parameter;

+ (void)getDeeplink:(void (^)(AdsforceDeeplinkModel *deeplinkModel))completionBlock;

@end
