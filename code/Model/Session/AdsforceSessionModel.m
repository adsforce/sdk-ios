//
//  AdsforceSessionModel.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/14.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import "AdsforceSessionModel.h"

@implementation AdsforceSessionModel

#pragma mark - init

- (instancetype)initWithSessionId:(NSString *)sessionId type:(AdsforceSessionModelType)type uuid:(NSString *)uuid {
    self = [super initWithTimeStampAndUUID];
    if (self) {
        _sessionID = sessionId;
        _dataType = type;
    }
    return self;
}

#pragma mark - Util

+ (NSDictionary *)convertDicWithModel:(AdsforceSessionModel *)model {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [AdsforceBaseModel convertToDic:dic withModel:model];
    
    NSString *sessionID = [model.sessionID copy];
    AdsforceSessionModelType dataType = model.dataType;
    if (sessionID != nil) {
        [dic setObject:sessionID forKey:@"sessionID"];
    }
    if (dataType == AdsforceSessionModelTypeStart
        || dataType == AdsforceSessionModelTypeTimer
        || dataType == AdsforceSessionModelTypeEnd) {
        NSString *strDataType = [NSString stringWithFormat:@"%i",(int)dataType];
        [dic setObject:strDataType forKey:@"dataType"];
    }
    
    return dic;
}

+ (AdsforceSessionModel *)convertModelWithDic:(NSDictionary *)dic {
    AdsforceSessionModel *model = [[AdsforceSessionModel alloc] init];
    [AdsforceBaseModel convertToModel:model withDic:dic];
    
    if ([[dic allKeys] containsObject:@"sessionID"]) {
        model.sessionID = [dic objectForKey:@"sessionID"];
    }
    if ([[dic allKeys] containsObject:@"dataType"]) {
        NSString *strDataType = [dic objectForKey:@"dataType"];
        model.dataType = strDataType.intValue;
    }
    return model;
}

@end
