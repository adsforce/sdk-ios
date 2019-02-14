//
//  AdsforceSessionModel.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/14.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdsforceBaseModel.h"

typedef NS_ENUM (NSInteger, AdsforceSessionModelType) {
    AdsforceSessionModelTypeStart = 0,
    AdsforceSessionModelTypeTimer = 1,
    AdsforceSessionModelTypeEnd = 2,
    AdsforceSessionModelTypeOpen = 3,
};

@interface AdsforceSessionModel : AdsforceBaseModel

@property (nonatomic,copy) NSString *sessionID;
@property (nonatomic) AdsforceSessionModelType dataType;

- (instancetype)initWithSessionId:(NSString *)sessionId type:(AdsforceSessionModelType)type uuid:(NSString *)uuid;

#pragma mark - Util

+ (NSDictionary *)convertDicWithModel:(AdsforceSessionModel *)model;

+ (AdsforceSessionModel *)convertModelWithDic:(NSDictionary *)dic;

@end
