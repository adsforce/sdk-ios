//
//  XhanceCustomEventParameter.m
//  XhanceSDK
//
//

#import "XhanceCustomEventParameter.h"
#import "XhanceUtil.h"

@interface XhanceCustomEventParameter ()
{
    XhanceCustomEventModel *_model;
}
@end

@implementation XhanceCustomEventParameter

- (instancetype)initWithCustomEventModel:(XhanceCustomEventModel *)model {
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
     @param cat Short name of category, indicating the classification of events, session cat=event
     @param e_id The short name of event_id indicates the name of the event.
     The e_id is custom event key.
     @param val Abbreviation of value, indicating the value of the event, the session does not need to pass, it is empty
     */
    NSString *cat = @"event";
    NSString *e_id = _model.key;
    // Convert value from object to string, and url encoding
    NSString *val = [XhanceUtil URLEncodedString:[self convertStrWithObj:_model.value]];
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

- (void)createDataForXhance {
    [super createDataForXhance];
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
        return [XhanceUtil arrayToJson:(NSArray *)obj];
    }
    if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSMutableDictionary class]]) {
        return [XhanceUtil dictionaryToJson:(NSDictionary *)obj];
    }
    
    return nil;
}

@end
