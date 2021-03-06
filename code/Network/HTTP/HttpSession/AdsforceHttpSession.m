//
//  AdsforceHttpSession.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/4/12.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import "AdsforceHttpSession.h"
#import "NSMutableString+AdsforceCheckNullValue.h"
#import "AdsforceHttpDnsSession.h"

@implementation AdsforceHttpSession

+ (NSMutableString *)convertDicToString:(NSDictionary *)parameter {
    NSMutableString *parameterStr = [[NSMutableString alloc] init];
    int i = 0;
    for (NSString *key in parameter) {
        if (i != 0) {
            [parameterStr appendString:@"&"];
        }
        NSString *value = [parameter objectForKey:key];
        [parameterStr appendFormat:@"%@=%@",key,value];
        i++;
    }
    
    return parameterStr;
}

+ (void)HTTPPostWithUrl:(NSString *)url
             completion:(void (^)(id responseObject))completionBlock
                  error:(void (^)(NSError *error))errorBlock {
    
    [self HTTPPostWithUrl:url bodyData:nil completion:completionBlock error:errorBlock];
}

+ (void)HTTPPostWithUrl:(NSString *)url
              parameter:(NSDictionary *)parameter
             completion:(void (^)(id responseObject))completionBlock
                  error:(void (^)(NSError *error))errorBlock {
    
    NSString *parameterStr = [AdsforceHttpSession convertDicToString:parameter];
    NSData *bodyData = [parameterStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [self HTTPPostWithUrl:url bodyData:bodyData completion:completionBlock error:errorBlock];
}

+ (void)HTTPPostWithUrl:(NSString *)url
           parameterStr:(NSString *)parameterStr
             completion:(void (^)(id responseObject))completionBlock
                  error:(void (^)(NSError *error))errorBlock {
    
    NSData *bodyData = nil;
    if (parameterStr != nil) {
        bodyData = [parameterStr dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    [self HTTPPostWithUrl:url bodyData:bodyData completion:completionBlock error:errorBlock];
}

+ (void)HTTPPostWithUrl:(NSString *)url
               bodyData:(NSData *)bodyData
             completion:(void (^)(id responseObject))completionBlock
                  error:(void (^)(NSError *error))errorBlock {
    
    if (url == nil || [url isEqualToString:@""]) {
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    if (bodyData != nil) {
       request.HTTPBody = bodyData;
    }
    request.HTTPMethod = @"POST";
    
    AdsforceHttpDnsSession *session = [[AdsforceHttpDnsSession alloc] init];
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            errorBlock(error);
        }
        else {
            id responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingAllowFragments
                                                                  error:nil];
            
            NSNumber *state = responseObject ? [responseObject objectForKey:@"ret"] : nil;
            if (state && state.intValue == 200) {
//                NSDictionary *data = [responseObject objectForKey:@"data"];
//                completionBlock(data);
                completionBlock(responseObject);
            }
            else {
                NSInteger code = 0;
                if ([[responseObject allKeys] containsObject:@"code"]) {
                    code = ((NSNumber *)[responseObject objectForKey:@"code"]).integerValue;
                }
                NSError *nError = [NSError errorWithDomain:@"AdsforceHttpSession" code:code userInfo:responseObject];
                errorBlock(nError);
            }
        }
    }];
}

@end
