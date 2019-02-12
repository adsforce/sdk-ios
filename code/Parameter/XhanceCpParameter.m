//
//  XhanceCpParameter.m
//  XhanceSDK
//
//

#import "XhanceCpParameter.h"

@interface XhanceCpParameter ()

@end

@implementation XhanceCpParameter
@synthesize appId = _appId;
@synthesize devKey = _devKey;
@synthesize publicKey = _publicKey;
@synthesize trackUrl = _trackUrl;
@synthesize channelId = _channelId;

static XhanceCpParameter *manager;
+ (instancetype)shareinstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(manager == nil) {
            manager = [[XhanceCpParameter alloc] init];
        }
    });
    return manager;
}

@end
