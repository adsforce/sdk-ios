//
//  AdsforceIAPParameter.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/29.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdsforceBaseParameter.h"
#import "AdsforceIAPModel.h"

@interface AdsforceIAPParameter : AdsforceBaseParameter

- (instancetype)initWithIAPModel:(AdsforceIAPModel *)model;

@end
