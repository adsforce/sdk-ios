//
//  AvidlyAdsMd5Utils.m
//  AvidlyAdsSDK
//
//  Created by samliu on 2017/5/12.
//

#import "XhanceMd5Utils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation XhanceMd5Utils

+ (NSString *)MD5OfString:(NSString *)text {
    // Create pointer to the string as UTF8
    const char *ptr = [text UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

+ (NSString *)MD5OfFile:(NSString *)path {
    NSData *nsData = [NSData dataWithContentsOfFile:path];
    return [self MD5OfData:nsData];
}

+ (NSString *)MD5OfData:(NSData *)data {
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(data.bytes, (CC_LONG)data.length, md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

@end
