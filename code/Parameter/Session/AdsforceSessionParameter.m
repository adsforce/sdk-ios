//
//  AdsforceParameter.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/17.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import "AdsforceSessionParameter.h"

@interface AdsforceSessionParameter ()
{
    AdsforceSessionModel *_model;
}
@end

@implementation AdsforceSessionParameter

- (instancetype)initWithSession:(AdsforceSessionModel *)model {
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
     @param s_id Abbreviation for session_id
     @param cat Short name of category, indicating the classification of events, session cat=session
     @param e_id The short name of event_id indicates the name of the event.
            The e_id enumeration type of the session consists of three types: s_start, s_end, s_going.
     @param val Abbreviation of value, indicating the value of the event, the session does not need to pass, it is empty
     */
    NSString *s_id = _model.sessionID;
    NSString *cat = @"session";
    NSString *e_id = @"";
    if (_model.dataType == AdsforceSessionModelTypeStart) {
        e_id = @"s_start";
    } else if (_model.dataType == AdsforceSessionModelTypeTimer) {
        e_id = @"s_going";
    } else if (_model.dataType == AdsforceSessionModelTypeEnd) {
        e_id = @"s_end";
    } else if (_model.dataType == AdsforceSessionModelTypeOpen) {
        e_id = @"s_open";
    }
    NSString *val = @"";
    
    // set session parameters
    [self.dataForAdvertiser setCheckObject:s_id forKey:@"s_id"];
    [self.dataForAdvertiser setCheckObject:cat forKey:@"cat"];
    [self.dataForAdvertiser setCheckObject:e_id forKey:@"e_id"];
    [self.dataForAdvertiser setCheckObject:val forKey:@"val"];
    
    [super createDataForAdvertiser];
}

- (void)createDataForAdsforce {
    [super createDataForAdsforce];
}

@end
