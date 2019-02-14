//
//  AdsforceCpParameter.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/17.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import "AdsforceCpParameter.h"

@interface AdsforceCpParameter ()

@end

@implementation AdsforceCpParameter
@synthesize appId = _appId;
@synthesize devKey = _devKey;
@synthesize publicKey = _publicKey;
@synthesize trackUrl = _trackUrl;
@synthesize channelId = _channelId;

static AdsforceCpParameter *manager;
+ (instancetype)shareinstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(manager == nil) {
            manager = [[AdsforceCpParameter alloc] init];
        }
    });
    return manager;
}

@end
