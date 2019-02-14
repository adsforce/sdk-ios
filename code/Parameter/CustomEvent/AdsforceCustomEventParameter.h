//
//  AdsforceCustomEventParameter.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/8/22.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdsforceBaseParameter.h"
#import "AdsforceCustomEventModel.h"

@interface AdsforceCustomEventParameter : AdsforceBaseParameter

- (instancetype)initWithCustomEventModel:(AdsforceCustomEventModel *)model;

@end
