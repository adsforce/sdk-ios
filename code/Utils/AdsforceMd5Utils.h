//
//  AdsforceMd5Utils.h
//  AdsforceSDK
//
//  Created by samliu on 2017/5/12.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdsforceMd5Utils : NSObject

+ (NSString *)MD5OfString:(NSString *)text;

+ (NSString *)MD5OfFile:(NSString *)path;

+ (NSString *)MD5OfData:(NSData *)data;

@end
