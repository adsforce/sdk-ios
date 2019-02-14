//
//  AdsforceHttpDnsManager.m
//  AdsforceSDK
//
//  Created by steve on 2019/1/11.
//  Copyright © 2019 liuguojun. All rights reserved.
//

#import "AdsforceHttpDnsManager.h"
#import "AdsforceUtil.h"

#define GetIp_Times_Max 3
#define IpList_ExpirationTime (60*10)   //10min

@interface AdsforceHttpDnsManager () {
    
    BOOL _enable;
    
    NSMutableDictionary *_dnsServerAddressListDic; //  <host <get ip server address list>>
    NSMutableDictionary *_dnsIPDic; //  <host <<@"saveDate",NSDate>,@"ipList",<ip address list>>>
}
@end

@implementation AdsforceHttpDnsManager

static AdsforceHttpDnsManager *manager;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(manager == nil) {
            manager = [[AdsforceHttpDnsManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _enable = NO;
        _dnsIPDic = [[NSMutableDictionary alloc] init];
        _dnsServerAddressListDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - enable

- (void)setEnableDnsMode:(BOOL)enable {
    _enable = enable;
}

- (BOOL)getEnableDnsMode {
    return _enable;
}

#pragma mark - host

- (NSArray <NSString *> *)getDnsServerAddressAllHost {
    if (_dnsServerAddressListDic == nil || [_dnsServerAddressListDic allKeys].count == 0) {
        return nil;
    }
    NSArray *arr = [_dnsServerAddressListDic allKeys];
    if (arr == nil || arr.count == 0) {
        return nil;
    }
    return arr;
}

#pragma mark - dnsServerAddress

- (void)setDnsServerAddressList:(NSArray <NSString *> *)dnsServerAddressList host:(NSString *)host {
    if (host == nil || [host isEqualToString:@""]) {
        return;
    }
    if (dnsServerAddressList == nil || dnsServerAddressList.count == 0) {
        return;
    }
    [_dnsServerAddressListDic setObject:dnsServerAddressList forKey:host];
}

- (NSArray <NSString *> *)getDnsServerAddressListWithHost:(NSString *)host {
    if (host == nil || [host isEqualToString:@""]) {
        return nil;
    }
    if (_dnsServerAddressListDic == nil || [_dnsServerAddressListDic allKeys].count == 0) {
        return nil;
    }
    if (![[_dnsServerAddressListDic allKeys] containsObject:host]) {
        return nil;
    }
    
    NSArray *dnsServerAddressList = [_dnsServerAddressListDic objectForKey:host];
    if (dnsServerAddressList == nil || dnsServerAddressList.count == 0) {
        return nil;
    }
    
    return dnsServerAddressList;
}

#pragma mark - dnsIP

- (void)setDnsIPArray:(NSArray <NSString *> *)dnsIPArray host:(NSString *)host {
    if (host == nil || [host isEqualToString:@""]) {
        return;
    }
    if (dnsIPArray == nil || dnsIPArray.count == 0) {
        return;
    }
    
    NSDate *saveDate = [NSDate date];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:saveDate forKey:@"saveDate"];
    [dic setObject:dnsIPArray forKey:@"ipList"];
    
    [_dnsIPDic setObject:dic forKey:host];
}

- (NSArray <NSString *> *)getDnsIPArrayWithHost:(NSString *)host {
    if (host == nil || [host isEqualToString:@""]) {
        return nil;
    }
    if (_dnsIPDic == nil || [_dnsIPDic allKeys].count == 0) {
        return nil;
    }
    if (![[_dnsIPDic allKeys] containsObject:host]) {
        return nil;
    }
    
    // check interval
    NSDictionary *dic = [_dnsIPDic objectForKey:host];
    NSDate *saveDate = [dic objectForKey:@"saveDate"];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:saveDate];
    if (interval > IpList_ExpirationTime) {
        return nil;
    }
    
    NSArray *dnsIPArr = [dic objectForKey:@"ipList"];
    if (dnsIPArr == nil || dnsIPArr.count == 0) {
        return nil;
    }
    
    return dnsIPArr;
}

@end


@interface AdsforceHttpGetIPListSession () {
    NSMutableArray *_dnsServerRandomList;
}
@end

@implementation AdsforceHttpGetIPListSession

- (void)getIpWithHost:(NSString *)host
           completion:(void (^)(NSArray <NSString *> *ipList))completionBlock
                error:(void (^)(NSError *error))errorBlock {
    
    //get local cache ip list
    NSArray *ipList = [[AdsforceHttpDnsManager shareInstance] getDnsIPArrayWithHost:host];
    if (ipList) {
        completionBlock(ipList);
        return ;
    }
    
    NSArray *array = [[AdsforceHttpDnsManager shareInstance] getDnsServerAddressListWithHost:host];
    NSArray *randamArry = [AdsforceUtil randamArry:array];
    _dnsServerRandomList = [[NSMutableArray alloc] initWithArray:randamArry];
    
    if (_dnsServerRandomList == nil || _dnsServerRandomList.count == 0) {
        NSError *error = [NSError errorWithDomain:@"AdsforceHttpGetIPListSession"
                                             code:0
                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Server address is nil",@"message", nil]];
        errorBlock(error);
        return;
    }
    
    [self getIpWithHost:host retryTimes:0 completion:completionBlock error:errorBlock];
}

- (void)getIpWithHost:(NSString *)host
           retryTimes:(int)retryTimes
           completion:(void (^)(id responseObject))completionBlock
                error:(void (^)(NSError *error))errorBlock {
    
    // server address url
    if (retryTimes >= _dnsServerRandomList.count) {
        NSError *error = [NSError errorWithDomain:@"AdsforceHttpGetIPListSession"
                                             code:0
                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"retry times is max",@"message", nil]];
        errorBlock(error);
        return;
    }
    
    NSString *url = [_dnsServerRandomList objectAtIndex:retryTimes];
    
    //request ip list
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    request.HTTPMethod = @"GET";
    
    //创建连接并发送异步请求
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            if (retryTimes >= GetIp_Times_Max-1) {
                errorBlock(error);
            } else {
                [self getIpWithHost:host retryTimes:retryTimes+1 completion:completionBlock error:errorBlock];
            }
        } else {
            id responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingAllowFragments error:nil];
            if (responseObject) {
                NSArray *answerArr = [responseObject objectForKey:@"answer"];
                if (answerArr) {    //将此次获取的存在内存中
                    NSMutableArray *ipList = [[NSMutableArray alloc] init];
                    for (NSDictionary *dic in answerArr) {
                        NSString *type = [dic objectForKey:@"type"];
                        if ([type isEqualToString:@"A"]) {
                            NSString *rdata = [dic objectForKey:@"rdata"];
                            if (rdata != nil && ![rdata isEqualToString:@""]) {
                                [ipList addObject:rdata];
                            }
                        }
                    }
                    if (ipList != nil && ipList.count != 0) {
                        [[AdsforceHttpDnsManager shareInstance] setDnsIPArray:ipList host:host];
                        completionBlock(ipList);
                        return ;
                    }
                }
                
                if (retryTimes >= GetIp_Times_Max-1) {
                    NSError *nError = [NSError errorWithDomain:@"AdsforceHttpDns"
                                                          code:0
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"no ip address", @"message", nil]];
                    errorBlock(nError);
                } else {
                    [self getIpWithHost:host retryTimes:retryTimes+1 completion:completionBlock error:errorBlock];
                }
            }
            else {
                if (retryTimes >= GetIp_Times_Max-1) {
                    NSError *nError = [NSError errorWithDomain:@"AdsforceHttpDns"
                                                          code:0
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"responseObject is nil", @"message", nil]];
                    errorBlock(nError);
                } else {
                    [self getIpWithHost:host retryTimes:retryTimes+1 completion:completionBlock error:errorBlock];
                }
            }
        }
    }];
    [dataTask resume];
}

@end
