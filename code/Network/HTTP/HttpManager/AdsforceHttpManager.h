//
//  AdsforceHttpManager.h
//  AdsforceSDK
//
//  Created by liuguojun on 2018/4/12.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdsforceSessionModel.h"

@interface AdsforceHttpManager : NSObject

#pragma mark - Session

+ (void)sendSessionForAdvertiser:(NSString *)url
                      retryCount:(int)retryCount
                      completion:(void (^)(id responseObject))completionBlock
                           error:(void (^)(NSError *error))errorBlock;

+ (void)sendSessionForAdsforce:(NSString *)url
                   retryCount:(int)retryCount
                   completion:(void (^)(id responseObject))completionBlock
                        error:(void (^)(NSError *error))errorBlock;

#pragma mark - IAP

+ (void)sendIAPForAdvertiser:(NSString *)url
                parameterStr:(NSString *)parameterStr
                  retryCount:(int)retryCount
                  completion:(void (^)(id responseObject))completionBlock
                       error:(void (^)(NSError *error))errorBlock;

+ (void)sendIAPForAdsforce:(NSString *)url
             parameterStr:(NSString *)parameterStr
               retryCount:(int)retryCount
               completion:(void (^)(id responseObject))completionBlock
                    error:(void (^)(NSError *error))errorBlock;

#pragma mark - DeepLink

+ (void)getDeepLink:(NSString *)url
         retryCount:(int)retryCount
         completion:(void (^)(id responseObject))completionBlock
              error:(void (^)(NSError *error))errorBlock;

#pragma mark - CustomEvent

+ (void)sendCustomEventForAdvertiser:(NSString *)url
                          retryCount:(int)retryCount
                          completion:(void (^)(id responseObject))completionBlock
                               error:(void (^)(NSError *error))errorBlock;

+ (void)sendCustomEventForAdsforce:(NSString *)url
                       retryCount:(int)retryCount
                       completion:(void (^)(id responseObject))completionBlock
                            error:(void (^)(NSError *error))errorBlock;

@end
