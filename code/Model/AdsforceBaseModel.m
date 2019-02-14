//
//  AdsforceBaseModel.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/8/28.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import "AdsforceBaseModel.h"
#import "AdsforceMd5Utils.h"
#import "NSMutableDictionary+AdsforceCheckNullValue.h"

@implementation AdsforceBaseModel

- (instancetype)initWithTimeStampAndUUID {
    self = [super init];
    if (self) {
        _timeStamp = [NSDate date];
        _uuid = [AdsforceMd5Utils MD5OfString:[NSUUID UUID].UUIDString];
    }
    return self;
}

#pragma mark - Util

+ (void)convertToDic:(NSMutableDictionary *)dic withModel:(AdsforceBaseModel *)model {
    [dic setCheckValue:model.timeStamp forKey:@"timeStamp"];
    [dic setCheckValue:model.uuid forKey:@"uuid"];
}

+ (void)convertToModel:(AdsforceBaseModel *)model withDic:(NSDictionary *)dic {
    model.timeStamp = [dic objectForCheckKey:@"timeStamp"];
    model.uuid = [dic objectForCheckKey:@"uuid"];
}

@end
