//
//  XhanceBase64Utils.m
//  XhanceSDK
//
//

#import "XhanceBase64Utils.h"

@implementation XhanceBase64Utils

+ (NSString *)base64OfString:(NSString *)text {
    if (text == nil) {
        return @"";
    }
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [data base64EncodedStringWithOptions:0];
    return str;
}

@end
