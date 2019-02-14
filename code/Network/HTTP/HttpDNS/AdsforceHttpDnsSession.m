//
//  AdsforceHttpDnsSession.m
//  AdsforceSDK
//
//  Created by steve on 2019/1/11.
//  Copyright © 2019 liuguojun. All rights reserved.
//

#import "AdsforceHttpDnsSession.h"
#import "AdsforceHttpDnsManager.h"
#import "AdsforceCpParameter.h"
#import "AdsforceUtil.h"

@interface AdsforceHttpDnsSession () {
    BOOL _isLoadIP; //-1003错误之后已经尝试使用ip地址load
    NSString *_uuid;    //用来区分不同的请求，主要用于测试时打印log用
    NSArray <NSString *> *_ipList;
    NSArray <NSString *> *_ipRandomList;
}
@end

@implementation AdsforceHttpDnsSession

- (instancetype)init {
    self = [super init];
    if (self) {
        _isLoadIP = NO;
        _uuid = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    //    NSLog(@"http开始 :%p url:%@",self,request.URL.absoluteString);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL enable = [[AdsforceHttpDnsManager shareInstance] getEnableDnsMode];
        if (!enable) {
            completionHandler(data,response,error);
        } else {
            if (error.code == NSURLErrorCannotFindHost || error.code == NSURLErrorCannotConnectToHost) {  //表示DNS解析失败
                BOOL shouldReplaceHost = NO;
                NSString *oldHost = request.URL.host;
                NSArray *hostArray = [[AdsforceHttpDnsManager shareInstance] getDnsServerAddressAllHost];
                for (int i = 0; i<hostArray.count; i++) {
                    NSString *replaceHost = [hostArray objectAtIndex:i];
                    if ([oldHost isEqualToString:replaceHost]) {
                        shouldReplaceHost = YES;
                        break;
                    }
                }
                if (shouldReplaceHost) {
                    // NSLog(@"准备使用IP替换host :%p url:%@",self,request.URL.absoluteString);
                    if (!_isLoadIP) {
                        _isLoadIP = YES;
                        // NSLog(@"获取IP :%p url:%@",self,request.URL.absoluteString);
                        [[AdsforceHttpGetIPListSession alloc] getIpWithHost:request.URL.host completion:^(NSArray <NSString *> *ipList) {
                            if (ipList != nil) {
                                _ipList = ipList;
                                _ipRandomList = [AdsforceUtil randamArry:_ipList];
                                [self againDataTaskWithOldRequest:request
                                                       retryTimes:0
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    completionHandler(data,response,error);
                                                }];
                                //  [self analysisWithKey:_NEW_WEBDNS_USED hostName:request.URL.host hostIP:responseObject];
                            }
                            else {
                                //  [self analysisWithKey:_NEW_WEBDNS_NO_OK hostName:request.URL.host hostIP:@"null"];
                                completionHandler(data,response,error);
                            }
                            
                        } error:^(NSError *error) {
                            //  [self analysisWithKey:_NEW_WEBDNS_NO_OK hostName:request.URL.host hostIP:@"null"];
                            completionHandler(data,response,error);
                        }];
                    }
                    else {
                        completionHandler(data,response,error);
                    }
                }
                else {
                    completionHandler(data,response,error);
                }
            }
            else {
                completionHandler(data,response,error);
            }
        }
    }];
    [dataTask resume];
    
    return dataTask;
}

#define AgainDataTaskWith_IP_Times_Max 3
//ip替换host之后重试
- (NSURLSessionDataTask *)againDataTaskWithOldRequest:(NSURLRequest *)request
                                           retryTimes:(int)retryTimes
                                    completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    
    if (_ipRandomList == nil || _ipRandomList.count == 0) {
        NSError *error = [NSError errorWithDomain:@"AdsforceHttpDnsSession"
                                             code:0
                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"ip random list is nil",@"message", nil]];
        completionHandler(nil,nil,error);
        return nil;
    }
    
    if (retryTimes >= _ipRandomList.count) {
        NSError *error = [NSError errorWithDomain:@"AdsforceHttpDnsSession"
                                             code:0
                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"retry times is max",@"message", nil]];
        completionHandler(nil,nil,error);
        return nil;
    }
    NSString *ip = [_ipRandomList objectAtIndex:retryTimes];
    
    NSString *ipUrl = [request.URL.absoluteString stringByReplacingOccurrencesOfString:request.URL.host withString:ip];
    NSString *httpIpUrl = [ipUrl stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
    NSMutableURLRequest *ipRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:httpIpUrl]
                                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                         timeoutInterval:30.0];
    ipRequest.HTTPBody = request.HTTPBody;
    ipRequest.HTTPMethod = request.HTTPMethod;
    [ipRequest setValue:request.URL.host forHTTPHeaderField:@"host"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:ipRequest
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (retryTimes >= AgainDataTaskWith_IP_Times_Max-1) {
                completionHandler(data,response,error);
            } else {
                [self againDataTaskWithOldRequest:request retryTimes:retryTimes+1 completionHandler:completionHandler];
            }
        }
        else {
            completionHandler(data,response,error);
        }
    }];
    [dataTask resume];
    
    return dataTask;
}

@end
