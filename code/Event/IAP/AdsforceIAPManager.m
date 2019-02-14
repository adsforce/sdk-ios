//
//  AdsforceIAPManager.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/30.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import "AdsforceIAPManager.h"
#import "AdsforceIAPSend.h"
#import "AdsforceIAPParameter.h"
#import "AdsforceIAPModel.h"
#import "AdsforceFileCache.h"

@interface AdsforceIAPManager ()

@end

@implementation AdsforceIAPManager

+ (void)appStoreWithProductPrice:(NSNumber *)productPrice
             productCurrencyCode:(NSString *)productCurrencyCode
               receiptDataString:(NSString *)receiptDataString
                          pubkey:(NSString *)pubkey
                          params:(NSDictionary *)params {
    AdsforceIAPModel *model = [[AdsforceIAPModel alloc] initWithProductPrice:productPrice
                                                     productCurrencyCode:productCurrencyCode
                                                       productIdentifier:@""
                                                         productCategory:@""
                                                       receiptDataString:receiptDataString
                                                                  pubkey:pubkey
                                                                  params:params
                                                              isThirdPay:NO];
    [self sendModel:model];
}

+ (void)thirdPayWithProductPrice:(NSNumber *)productPrice
             productCurrencyCode:(NSString *)productCurrencyCode
               productIdentifier:(NSString *)productIdentifier
                 productCategory:(NSString *)productCategory {
    AdsforceIAPModel *model = [[AdsforceIAPModel alloc] initWithProductPrice:productPrice
                                                     productCurrencyCode:productCurrencyCode
                                                       productIdentifier:productIdentifier
                                                         productCategory:productCategory
                                                       receiptDataString:@""
                                                                  pubkey:@""
                                                                  params:nil
                                                              isThirdPay:YES];
    [self sendModel:model];
}

#pragma mark - CacheModel

+ (void)cacheModel:(AdsforceIAPModel *)model {
    // Write session model to file chache
    NSDictionary *sessionDic = [AdsforceIAPModel convertDicWithModel:model];
    [[AdsforceFileCache shareInstance] writeDic:sessionDic
                                  channelType:AdsforceFileCacheChannelTypeAdvertiser
                                     pathType:AdsforceFileCachePathTypeIAP];
    [[AdsforceFileCache shareInstance] writeDic:sessionDic
                                  channelType:AdsforceFileCacheChannelTypeAdsforce
                                     pathType:AdsforceFileCachePathTypeIAP];
}

#pragma mark - sendModel

+ (void)sendModel:(AdsforceIAPModel *)model {
    [self cacheModel:model];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self sendAdvertiserIAP:model];
        [self sendAdsforceIAP:model];
    });
}

+ (void)sendAdvertiserIAP:(AdsforceIAPModel *)model {
    [AdsforceIAPSend sendAdvertiserIAP:model];
}

+ (void)sendAdsforceIAP:(AdsforceIAPModel *)model {
    [AdsforceIAPSend sendAdsforceIAP:model];
}

#pragma mark - checkDefeatedIAPAndSend

+ (void)checkDefeatedIAPAndSend {
    // Get the advertiser model that failed to send before and send.
    NSArray *defeatedAdvertiserIAPDics = [[AdsforceFileCache shareInstance] getArrayWithChannelType:AdsforceFileCacheChannelTypeAdvertiser
                                                                                                 pathType:AdsforceFileCachePathTypeIAP];
    for (int i = 0; i < defeatedAdvertiserIAPDics.count; i++) {
        NSDictionary *IAPDic = [defeatedAdvertiserIAPDics objectAtIndex:i];
        AdsforceIAPModel *IAPModel = [AdsforceIAPModel convertModelWithDic:IAPDic];
        if (IAPModel == nil) {
            continue;
        }
        [self sendAdvertiserIAP:IAPModel];
    }
    
    // Get the adsforce model that failed to send before and send.
    NSArray *defeatedAdsforceIAPDics = [[AdsforceFileCache shareInstance] getArrayWithChannelType:AdsforceFileCacheChannelTypeAdsforce
                                                                                              pathType:AdsforceFileCachePathTypeIAP];
    for (int i = 0; i < defeatedAdsforceIAPDics.count; i++) {
        NSDictionary *IAPDic = [defeatedAdsforceIAPDics objectAtIndex:i];
        AdsforceIAPModel *IAPModel = [AdsforceIAPModel convertModelWithDic:IAPDic];
        if (IAPModel == nil) {
            continue;
        }
        [self sendAdsforceIAP:IAPModel];
    }
}

+ (void)checkDefeatedIAPAndSendWithChildThread {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self checkDefeatedIAPAndSend];
    });
}

@end
