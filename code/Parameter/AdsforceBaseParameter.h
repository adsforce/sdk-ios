//
//  AdsforceBaseParameter.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/28.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdsforceUtil.h"
#import "AdsforceMd5Utils.h"
#import "AdsforceCpParameter.h"
#import "NSMutableDictionary+AdsforceCheckNullValue.h"

@interface AdsforceBaseParameter : NSObject

@property(nonatomic,copy) NSString *timeStamp;      //Timestamp, globally use this one to ensure that each API is unique
@property(nonatomic,copy) NSString *uuid;           //Uuid after md5 encryption

@property(nonatomic) NSMutableDictionary *dataForAdvertiser;    //Attribution data is sent to the advertiser
@property(nonatomic) NSMutableDictionary *dataForAdsforce;       //Attribution summary data sent to the Adsforce

@property(nonatomic,copy) NSString *dataStrForAdvertiser;       //Attribution data str is sent to the advertiser
@property(nonatomic,copy) NSString *dataStrForAdsforce;          //Attribution summary data str sent to the Adsforce

@property(nonatomic) NSMutableDictionary *baseParameterDic;     //Common parameter map

- (instancetype)initWithTimeStamp:(NSString *)timeStamp uuid:(NSString *)uuid;

- (void)createDataForAdvertiser;

- (void)createDataForAdsforce;

#pragma mark - Util

- (NSString *)sortParameter:(NSMutableDictionary *)parameters;

@end
