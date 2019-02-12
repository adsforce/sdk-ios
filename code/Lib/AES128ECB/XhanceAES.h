//
//  STAESenAndDe.h
//
//  Created by jiangxiaodong on 14-6-4.
//

#import <Foundation/Foundation.h>

@interface XhanceAES : NSObject

#pragma mark - encode

+ (NSData *)EnAESandBase64ToData:(NSString *)str key:(NSString *)kKey;

+ (NSString *)EnAESandBase64EnToString:(NSString *)str key:(NSString *)kKey;

#pragma mark - decode

+ (NSString *)DeBase64andAESDeToString:(NSString *)str key:(NSString *)kKey;

+ (NSData *)DeBase64andAESToData:(NSString *)str key:(NSString *)kKey;

+ (NSDictionary *)DeBase64andAESToDictionary:(NSString *)str key:(NSString *)kKey;

@end
