//
//  AdsforceTrackingParameter.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/17.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import "AdsforceTrackingParameter.h"
#import <iAd/iAd.h>

@interface AdsforceTrackingParameter () {
    NSString *_referrer;
}
@end

@implementation AdsforceTrackingParameter

- (instancetype)initWithReferrer:(NSString *)referrer uuid:(NSString *)uuidString {
    NSString *timeStamp = [AdsforceUtil getDateTimeStamp];
    NSString *uuid = [AdsforceMd5Utils MD5OfString:uuidString];
    self = [super initWithTimeStamp:timeStamp uuid:uuid];
    if (self) {
        _referrer = [referrer copy];
        [self createDataForAdvertiser];
        [self createDataForAdsforce];
    }
    return self;
}

- (instancetype)initWithReferrer:(NSString *)referrer {
    NSString *timeStamp = [AdsforceUtil getDateTimeStamp];
    NSString *uuid = [AdsforceMd5Utils MD5OfString:[NSUUID UUID].UUIDString];
    self = [super initWithTimeStamp:timeStamp uuid:uuid];
    if (self) {
        _referrer = [referrer copy];
        [self createDataForAdvertiser];
        [self createDataForAdsforce];
    }
    return self;
}

- (void)createDataForAdvertiser {
    
    if (_referrer != nil) {
        [self.dataForAdvertiser setCheckObject:_referrer forKey:@"referrer"];
    }
    
    [super createDataForAdvertiser];
}

- (void)createDataForAdsforce {
    [super createDataForAdsforce];
}

@end
