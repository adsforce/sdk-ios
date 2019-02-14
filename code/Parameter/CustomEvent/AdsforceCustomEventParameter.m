//
//  AdsforceCustomEventParameter.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/8/22.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import "AdsforceCustomEventParameter.h"
#import "AdsforceUtil.h"

@interface AdsforceCustomEventParameter ()
{
    AdsforceCustomEventModel *_model;
}
@end

@implementation AdsforceCustomEventParameter

- (instancetype)initWithCustomEventModel:(AdsforceCustomEventModel *)model {
    NSString *timeStamp = [AdsforceUtil getDateTimeStampWithDate:model.timeStamp];
    NSString *uuid = model.uuid;
    self = [super initWithTimeStamp:timeStamp uuid:uuid];
    if (self) {
        _model = model;
        [self createDataForAdvertiser];
        [self createDataForAdsforce];
    }
    return self;
}

- (void)createDataForAdvertiser {
    
    /*
     @param cat Short name of category, indicating the classification of events, session cat=event
     @param e_id The short name of event_id indicates the name of the event.
     The e_id is custom event key.
     @param val Abbreviation of value, indicating the value of the event, the session does not need to pass, it is empty
     */
    NSString *cat = @"event";
    NSString *e_id = _model.key;
    // Convert value from object to string, and url encoding
    NSString *val = [AdsforceUtil URLEncodedString:[self convertStrWithObj:_model.value]];
    if (e_id == nil || [e_id isEqualToString:@""]) {
        e_id = @"";
    }
    if (val == nil || [val isEqualToString:@""]) {
        val = @"";
    }
    
    [self.dataForAdvertiser setCheckObject:cat forKey:@"cat"];
    [self.dataForAdvertiser setCheckObject:e_id forKey:@"e_id"];
    [self.dataForAdvertiser setCheckObject:val forKey:@"val"];
    
    [super createDataForAdvertiser];
}

- (void)createDataForAdsforce {
    [super createDataForAdsforce];
}

#pragma mark - util

- (NSString *)convertStrWithObj:(NSObject *)obj {
    if (obj == nil) {
        return @"";
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString *)obj;
    }
    if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]]) {
        return [AdsforceUtil arrayToJson:(NSArray *)obj];
    }
    if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSMutableDictionary class]]) {
        return [AdsforceUtil dictionaryToJson:(NSDictionary *)obj];
    }
    
    return nil;
}

@end
