//
//  AdsforceCustomEventModel.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/8/29.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import "AdsforceCustomEventModel.h"
#import "NSMutableDictionary+AdsforceCheckNullValue.h"

@implementation AdsforceCustomEventModel

- (instancetype)initWithKey:(NSString *)key value:(NSObject *)value {
    self = [super initWithTimeStampAndUUID];
    if (self) {
        _key = [key copy];
        _value = value;
    }
    return self;
}

#pragma mark - Util

+ (NSDictionary *)convertDicWithModel:(AdsforceCustomEventModel *)model {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [AdsforceBaseModel convertToDic:dic withModel:model];
    
    [dic setCheckValue:model.key forKey:@"key"];
    [dic setCheckValue:model.value forKey:@"value"];
    
    return dic;
}

+ (AdsforceCustomEventModel *)convertModelWithDic:(NSDictionary *)dic {
    AdsforceCustomEventModel *model = [[AdsforceCustomEventModel alloc] init];
    [AdsforceBaseModel convertToModel:model withDic:dic];
    
    model.key = [dic objectForCheckKey:@"key"];
    model.value = [dic objectForCheckKey:@"value"];
    
    return model;
}

@end
