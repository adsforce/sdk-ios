//
//  AdsforceParameter.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/17.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdsforceBaseParameter.h"
#import "AdsforceSessionModel.h"

@interface AdsforceSessionParameter : AdsforceBaseParameter

- (instancetype)initWithSession:(AdsforceSessionModel *)session;

@end
