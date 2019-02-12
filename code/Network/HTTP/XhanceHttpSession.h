//
//  XhanceHttpSession.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>

@interface XhanceHttpSession : NSObject

#pragma mark - Post (ret==200 is succeed)

+ (void)HTTPPostWithUrl:(NSString *)url
             completion:(void (^)(id responseObject))completionBlock
                  error:(void (^)(NSError *error))errorBlock;

+ (void)HTTPPostWithUrl:(NSString *)url
              parameter:(NSDictionary *)parameter
             completion:(void (^)(id responseObject))completionBlock
                  error:(void (^)(NSError *error))errorBlock;

+ (void)HTTPPostWithUrl:(NSString *)url
           parameterStr:(NSString *)parameterStr
             completion:(void (^)(id responseObject))completionBlock
                  error:(void (^)(NSError *error))errorBlock;

+ (void)HTTPPostWithUrl:(NSString *)url
               bodyData:(NSData *)bodyData
             completion:(void (^)(id responseObject))completionBlock
                  error:(void (^)(NSError *error))errorBlock;

@end
