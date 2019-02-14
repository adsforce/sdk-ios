//
//  AdsforceCustomEventModel.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/8/29.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdsforceBaseModel.h"

@interface AdsforceCustomEventModel : AdsforceBaseModel

@property (nonatomic,copy) NSString *key;
@property (nonatomic) NSObject *value;

- (instancetype)initWithKey:(NSString *)key value:(NSObject *)value;

#pragma mark - Util

+ (NSDictionary *)convertDicWithModel:(AdsforceCustomEventModel *)model;

+ (AdsforceCustomEventModel *)convertModelWithDic:(NSDictionary *)dic;

@end
