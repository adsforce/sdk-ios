//
//  AdsforceCustomEventSend.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/8/22.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import "AdsforceCustomEventSend.h"
#import "AdsforceRSA.h"
#import "AdsforceAES.h"
#import "AdsforceHttpUrl.h"
#import "AdsforceHttpManager.h"
#import "AdsforceFileCache.h"
#import "AdsforceEncryptModel.h"

@implementation AdsforceCustomEventSend

+ (void)sendAdvertiserCustomEvent:(AdsforceCustomEventModel *)model {
//    NSString *aesKey = [AdsforceUtil get16RandomStr];
//    NSString *aesEncodeKey = [AdsforceRSA encryptString:aesKey publicKey:[AdsforceCpParameter shareinstance].publicKey];
    AdsforceEncryptModel *encryptModel = [AdsforceEncryptModel getModel];
    if (![encryptModel available]) {
        return;
    }
    NSString *aesKey = encryptModel.aesKey;
    NSString *aesEncodeKey = encryptModel.aesEncodeKey;
    
    AdsforceCustomEventParameter *customEventParameter = [[AdsforceCustomEventParameter alloc] initWithCustomEventModel:model];
    // The main parameters
    NSString *dataStrForAdvertiser = customEventParameter.dataStrForAdvertiser;
    
    // AES encryption
    NSString *enString = [AdsforceAES EnAESandBase64EnToString:dataStrForAdvertiser key:aesKey];
    
    // Get the domain name path url
    NSString *urlStr = [[AdsforceHttpUrl shareInstance] getCustomEventUrlForAdvertiser];
    
    // Stitching parameter into url
    NSString *jointParmeterUrlStr = [AdsforceHttpUrl jointAdvertiserUrl:urlStr
                                                         aesEncodeKey:aesEncodeKey
                                               enDataStrForAdvertiser:enString
                                                       parameterModel:customEventParameter];
    
    [AdsforceHttpManager sendCustomEventForAdvertiser:jointParmeterUrlStr retryCount:0 completion:^(id responseObject) {
        NSDictionary *dic = [AdsforceCustomEventModel convertDicWithModel:model];
        [[AdsforceFileCache shareInstance] removeDic:dic
                                       channelType:AdsforceFileCacheChannelTypeAdvertiser
                                          pathType:AdsforceFileCachePathTypeCustomEvent];
    } error:^(NSError *error) {}];
}

+ (void)sendAdsforceCustomEvent:(AdsforceCustomEventModel *)model {
    AdsforceCustomEventParameter *customEventParameter = [[AdsforceCustomEventParameter alloc] initWithCustomEventModel:model];
    // The main parameters
    NSString *dataStrForAdsforce = customEventParameter.dataStrForAdsforce;
    
    // Get the domain name path url
    NSString *urlStr = [[AdsforceHttpUrl shareInstance] getCustomEventUrlForAdsforce];
    
    // Stitching parameter into url
    NSString *jointParameterUrlStr = [AdsforceHttpUrl jointAdsforceUrl:urlStr
                                                  dataStrForAdsforce:dataStrForAdsforce
                                                     parameterModel:customEventParameter];
    
    [AdsforceHttpManager sendCustomEventForAdsforce:jointParameterUrlStr retryCount:0 completion:^(id responseObject) {
        NSDictionary *dic = [AdsforceCustomEventModel convertDicWithModel:model];
        [[AdsforceFileCache shareInstance] removeDic:dic
                                       channelType:AdsforceFileCacheChannelTypeAdsforce
                                          pathType:AdsforceFileCachePathTypeCustomEvent];
    } error:^(NSError *error) {}];
}

@end
