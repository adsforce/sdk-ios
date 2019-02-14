//
//  AdsforceAppleSearchManager.m
//  AdsforceSDK
//
//  Created by steve on 2019/1/22.
//  Copyright © 2019 liuguojun. All rights reserved.
//

#import "AdsforceAppleSearchManager.h"
#import <iAd/iAd.h>
#import "AdsforceUtil.h"
#import "NSMutableDictionary+AdsforceCheckNullValue.h"

@implementation AdsforceAppleSearchManager

+ (void)getAppleSearchAdData:(void (^)(NSString *referrerStr))completionBlock errorBlock:(void (^)(NSError *error))errorBlock {
    // Get parameters
    __block NSString *referrerJson = @"";
    if ([[ADClient sharedClient] respondsToSelector:@selector(requestAttributionDetailsWithBlock:)]) {
        [[ADClient sharedClient] requestAttributionDetailsWithBlock:^(NSDictionary *attributionDetails, NSError *error) {
            if (error) {
                errorBlock(error);
            }
            else {
                NSString *referrerStr = nil;
                if (attributionDetails != nil) {
                    NSString *jsonStr = [AdsforceUtil dictionaryToJson:attributionDetails];
                    referrerJson = [jsonStr copy];
                    if (referrerJson != nil && ![referrerJson isEqualToString:@""]) {
                        NSString *str = [NSString stringWithFormat:@"_apple_search:%@",referrerJson];
                        NSString *referrer = [AdsforceUtil URLEncodedString:str];
                        referrerStr = [referrer copy];
                    }
                }
                completionBlock(referrerStr);
            }
        }];
    }
    else {
        completionBlock(nil);
    }
}

#define AppleSearchRetryTimesMax 3

+ (void)retryGetAppleSearchAdDataWithRetryTimes:(int)retryTimes uuid:(NSString *)uuid completion:(void (^)(NSString *referrerStr))completionBlock errorBlock:(void (^)(NSString *referrerStr))errorBlock {
    
    if (retryTimes > AppleSearchRetryTimesMax) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setCheckValue:uuid forKey:@"_uuid"];
        [dic setCheckValue:@"The maximum number of retries has been completed" forKey:@"_error_msg"];
        [dic setCheckValue:[NSNumber numberWithInt:retryTimes] forKey:@"_retry_times"];
        NSString *jsonStr = [AdsforceUtil dictionaryToJson:dic];
        NSString *referrerJson = [jsonStr copy];
        errorBlock(referrerJson);
        return;
    }
    
    // Get parameters
    __block NSString *referrerJson = @"";
    if ([[ADClient sharedClient] respondsToSelector:@selector(requestAttributionDetailsWithBlock:)]) {
        [[ADClient sharedClient] requestAttributionDetailsWithBlock:^(NSDictionary *attributionDetails, NSError *error) {
            if (error) {
                if (retryTimes >= AppleSearchRetryTimesMax) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setCheckValue:uuid forKey:@"_uuid"];
                    [dic setCheckValue:[AdsforceUtil dictionaryToJson:error.userInfo] forKey:@"_error_msg"];
                    [dic setCheckValue:[NSNumber numberWithInt:retryTimes] forKey:@"_retry_times"];
                    NSString *jsonStr = [AdsforceUtil dictionaryToJson:dic];
                    NSString *referrerJson = [jsonStr copy];
                    errorBlock(referrerJson);
                }
                else {
                    [self retryGetAppleSearchAdDataWithRetryTimes:retryTimes+1 uuid:uuid completion:completionBlock errorBlock:errorBlock];
                }
            }
            else {
                if (attributionDetails != nil) {
                    NSString *referrerStr = @"";
                    NSString *jsonStr = [AdsforceUtil dictionaryToJson:attributionDetails];
                    referrerJson = [jsonStr copy];
                    if (referrerJson != nil && ![referrerJson isEqualToString:@""]) {
                        NSString *str = [NSString stringWithFormat:@"_apple_search:%@",referrerJson];
                        NSString *referrer = [AdsforceUtil URLEncodedString:str];
                        referrerStr = [referrer copy];
                    }
                    completionBlock(referrerStr);
                }
                else {
                    if (retryTimes >= AppleSearchRetryTimesMax) {
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        [dic setCheckValue:uuid forKey:@"_uuid"];
                        [dic setCheckValue:@"server attributionDetails is nil" forKey:@"_error_msg"];
                        [dic setCheckValue:[NSNumber numberWithInt:retryTimes] forKey:@"_retry_times"];
                        NSString *jsonStr = [AdsforceUtil dictionaryToJson:dic];
                        NSString *referrerJson = [jsonStr copy];
                        errorBlock(referrerJson);
                    }
                    else {
                        [self retryGetAppleSearchAdDataWithRetryTimes:retryTimes+1 uuid:uuid completion:completionBlock errorBlock:errorBlock];
                    }
                }
            }
        }];
    }
    else {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setCheckValue:uuid forKey:@"_uuid"];
        [dic setCheckValue:@"AppleSearch is not supported" forKey:@"_error_msg"];
        [dic setCheckValue:[NSNumber numberWithInt:retryTimes] forKey:@"_retry_times"];
        NSString *jsonStr = [AdsforceUtil dictionaryToJson:dic];
        NSString *referrerJson = [jsonStr copy];
        errorBlock(referrerJson);
    }
}

@end
