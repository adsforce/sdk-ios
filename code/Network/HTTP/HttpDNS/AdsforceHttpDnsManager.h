//
//  AdsforceHttpDnsManager.h
//  AdsforceSDK
//
//  Created by steve on 2019/1/11.
//  Copyright © 2019 liuguojun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdsforceHttpDnsManager : NSObject

+ (instancetype)shareInstance;

#pragma mark - enable

- (void)setEnableDnsMode:(BOOL)enable;

- (BOOL)getEnableDnsMode;

#pragma mark - host

- (NSArray <NSString *> *)getDnsServerAddressAllHost;

#pragma mark - dnsServerAddress

- (void)setDnsServerAddressList:(NSArray <NSString *> *)dnsServerAddressList host:(NSString *)host;

- (NSArray <NSString *> *)getDnsServerAddressListWithHost:(NSString *)host;

#pragma mark - dnsIP

- (void)setDnsIPArray:(NSArray <NSString *> *)dnsIPArray host:(NSString *)host;

- (NSArray  <NSString *> *)getDnsIPArrayWithHost:(NSString *)host;

@end

@interface AdsforceHttpGetIPListSession : NSObject

//获取ip地址，用来替换host
- (void)getIpWithHost:(NSString *)host
           completion:(void (^)(NSArray <NSString *> *ipList))completionBlock
                error:(void (^)(NSError *error))errorBlock;

@end

NS_ASSUME_NONNULL_END
