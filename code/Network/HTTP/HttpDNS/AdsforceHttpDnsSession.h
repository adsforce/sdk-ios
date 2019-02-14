//
//  AdsforceHttpDnsSession.h
//  AdsforceSDK
//
//  Created by steve on 2019/1/11.
//  Copyright © 2019 liuguojun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdsforceHttpDnsSession : NSObject

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@end

NS_ASSUME_NONNULL_END
