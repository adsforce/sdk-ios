//
//  STAESenAndDe.h
//
//  Created by jiangxiaodong on 14-6-4.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdsforceAES : NSObject

#pragma mark - encode

+ (NSData *)EnAESandBase64ToData:(NSString *)str key:(NSString *)kKey;

+ (NSString *)EnAESandBase64EnToString:(NSString *)str key:(NSString *)kKey;

#pragma mark - decode

+ (NSString *)DeBase64andAESDeToString:(NSString *)str key:(NSString *)kKey;

+ (NSData *)DeBase64andAESToData:(NSString *)str key:(NSString *)kKey;

+ (NSDictionary *)DeBase64andAESToDictionary:(NSString *)str key:(NSString *)kKey;

@end
