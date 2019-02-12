//
//  XhanceHttpManager.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>
#import "XhanceSessionModel.h"

@interface XhanceHttpManager : NSObject

#pragma mark - Session

+ (void)sendSessionForAdvertiser:(NSString *)url
                      retryCount:(int)retryCount
                      completion:(void (^)(id responseObject))completionBlock
                           error:(void (^)(NSError *error))errorBlock;

+ (void)sendSessionForXhance:(NSString *)url
                   retryCount:(int)retryCount
                   completion:(void (^)(id responseObject))completionBlock
                        error:(void (^)(NSError *error))errorBlock;

#pragma mark - IAP

+ (void)sendIAPForAdvertiser:(NSString *)url
                parameterStr:(NSString *)parameterStr
                  retryCount:(int)retryCount
                  completion:(void (^)(id responseObject))completionBlock
                       error:(void (^)(NSError *error))errorBlock;

+ (void)sendIAPForXhance:(NSString *)url
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

+ (void)sendCustomEventForXhance:(NSString *)url
                       retryCount:(int)retryCount
                       completion:(void (^)(id responseObject))completionBlock
                            error:(void (^)(NSError *error))errorBlock;

@end
