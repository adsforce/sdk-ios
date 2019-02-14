//
//  NSMutableString+AdsforceCheckNullValue.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/6/20.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import "NSMutableString+AdsforceCheckNullValue.h"

@implementation NSMutableString (AdsforceCheckNullValue)

- (void)appendAndCheckString:(NSString *)aString {
    
    if (aString == nil) {
        return;
    }
    [self appendString:aString];
}

@end
