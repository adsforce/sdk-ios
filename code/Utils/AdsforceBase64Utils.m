//
//  AdsforceBase64Utils.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/6/29.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import "AdsforceBase64Utils.h"

@implementation AdsforceBase64Utils

+ (NSString *)base64OfString:(NSString *)text {
    if (text == nil) {
        return @"";
    }
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [data base64EncodedStringWithOptions:0];
    return str;
}

@end
