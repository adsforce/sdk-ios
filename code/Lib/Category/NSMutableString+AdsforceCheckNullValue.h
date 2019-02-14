//
//  NSMutableString+AdsforceCheckNullValue.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/6/20.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (AdsforceCheckNullValue)

- (void)appendAndCheckString:(NSString *)aString;

@end
