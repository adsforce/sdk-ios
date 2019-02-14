//
//  AdsforceCpParameter.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/17.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdsforceCpParameter : NSObject

@property(nonatomic,copy) NSString *appId;
@property(nonatomic,copy) NSString *devKey;
@property(nonatomic,copy) NSString *publicKey;
@property(nonatomic,copy) NSString *trackUrl;
@property(nonatomic,copy) NSString *channelId;

+ (instancetype)shareinstance;

@end
