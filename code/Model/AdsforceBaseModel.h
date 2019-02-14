//
//  AdsforceBaseModel.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/8/28.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdsforceBaseModel : NSObject

@property (nonatomic) NSDate *timeStamp;
@property (nonatomic,copy) NSString *uuid;

- (instancetype)initWithTimeStampAndUUID;

+ (void)convertToDic:(NSMutableDictionary *)dic withModel:(AdsforceBaseModel *)model;

+ (void)convertToModel:(AdsforceBaseModel *)model withDic:(NSDictionary *)dic;

@end
