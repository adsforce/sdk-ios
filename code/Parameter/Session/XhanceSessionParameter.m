//
//  XhanceParameter.m
//  XhanceSDK
//
//

#import "XhanceSessionParameter.h"

@interface XhanceSessionParameter ()
{
    XhanceSessionModel *_model;
}
@end

@implementation XhanceSessionParameter

- (instancetype)initWithSession:(XhanceSessionModel *)model {
    NSString *timeStamp = [XhanceUtil getDateTimeStampWithDate:model.timeStamp];
    NSString *uuid = model.uuid;
    self = [super initWithTimeStamp:timeStamp uuid:uuid];
    if (self) {
        _model = model;
        [self createDataForAdvertiser];
        [self createDataForXhance];
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
    if (_model.dataType == XhanceSessionModelTypeStart) {
        e_id = @"s_start";
    } else if (_model.dataType == XhanceSessionModelTypeTimer) {
        e_id = @"s_going";
    } else if (_model.dataType == XhanceSessionModelTypeEnd) {
        e_id = @"s_end";
    }
    NSString *val = @"";
    
    // set session parameters
    [self.dataForAdvertiser setCheckObject:s_id forKey:@"s_id"];
    [self.dataForAdvertiser setCheckObject:cat forKey:@"cat"];
    [self.dataForAdvertiser setCheckObject:e_id forKey:@"e_id"];
    [self.dataForAdvertiser setCheckObject:val forKey:@"val"];
    
    [super createDataForAdvertiser];
}

- (void)createDataForXhance {
    [super createDataForXhance];
}

@end
