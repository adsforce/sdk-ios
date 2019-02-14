//
//  AdsforceAppleSearchManager.h
//  AdsforceSDK
//
//  Created by steve on 2019/1/22.
//  Copyright © 2019 liuguojun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdsforceAppleSearchManager : NSObject

+ (void)getAppleSearchAdData:(void (^)(NSString *referrerStr))completionBlock errorBlock:(void (^)(NSError *error))errorBlock;
+ (void)retryGetAppleSearchAdDataWithRetryTimes:(int)retryTimes uuid:(NSString *)uuid completion:(void (^)(NSString *referrerStr))completionBlock errorBlock:(void (^)(NSString *referrerStr))errorBlock;

@end

NS_ASSUME_NONNULL_END
