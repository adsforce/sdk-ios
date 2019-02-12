//
//  XhanceTrackingParameter.m
//  XhanceSDK
//
//

#import "XhanceTrackingParameter.h"
#import <iAd/iAd.h>

@interface XhanceTrackingParameter () {
    NSString *_referrer;
}
@end

@implementation XhanceTrackingParameter

- (instancetype)initWithReferrer:(NSString *)referrer {
    NSString *timeStamp = [XhanceUtil getDateTimeStamp];
    NSString *uuid = [XhanceMd5Utils MD5OfString:[NSUUID UUID].UUIDString];
    self = [super initWithTimeStamp:timeStamp uuid:uuid];
    if (self) {
        _referrer = [referrer copy];
        [self createDataForAdvertiser];
        [self createDataForXhance];
    }
    return self;
}

- (void)createDataForAdvertiser {
    
    if (_referrer != nil) {
        [self.dataForAdvertiser setCheckObject:_referrer forKey:@"referrer"];
    }
    
    [super createDataForAdvertiser];
}

- (void)createDataForXhance {
    [super createDataForXhance];
}

@end
