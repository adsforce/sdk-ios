//
//  XhanceMd5Utils.h
//  XhanceSDK
//
//  Created by samliu on 2017/5/12.
//

#import <Foundation/Foundation.h>

@interface XhanceMd5Utils : NSObject

+ (NSString *)MD5OfString:(NSString *)text;

+ (NSString *)MD5OfFile:(NSString *)path;

+ (NSString *)MD5OfData:(NSData *)data;

@end
