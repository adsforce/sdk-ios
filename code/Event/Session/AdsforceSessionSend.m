//
//  AdsforceSessionSend.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/17.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import "AdsforceSessionSend.h"
#import "AdsforceFileCache.h"
#import "AdsforceHttpManager.h"
#import "AdsforceAES.h"
#import "AdsforceSessionParameter.h"
#import "AdsforceHttpUrl.h"
#import "AdsforceUtil.h"
#import "AdsforceRSA.h"
#import "AdsforceCpParameter.h"
#import "AdsforceEncryptModel.h"

@implementation AdsforceSessionSend

+ (void)sendAdvertiserSession:(AdsforceSessionModel *)sessionModel {
//    NSString *aesKey = [AdsforceUtil get16RandomStr];
//    NSString *aesEncodeKey = [AdsforceRSA encryptString:aesKey publicKey:[AdsforceCpParameter shareinstance].publicKey];
    AdsforceEncryptModel *encryptModel = [AdsforceEncryptModel getModel];
    if (![encryptModel available]) {
        return;
    }
    NSString *aesKey = encryptModel.aesKey;
    NSString *aesEncodeKey = encryptModel.aesEncodeKey;
    
    AdsforceSessionParameter *sessionParameter = [[AdsforceSessionParameter alloc] initWithSession:sessionModel];
    // The main parameters
    NSString *dataStrForAdvertiser = sessionParameter.dataStrForAdvertiser;
    
    // AES encryption
    NSString *enString = [AdsforceAES EnAESandBase64EnToString:dataStrForAdvertiser key:aesKey];
    
    // Get the domain name path url
    NSString *urlStr = [[AdsforceHttpUrl shareInstance] getSessionUrlForAdvertiser];
    
    // Stitching parameter into url
    NSString *jointParmeterUrlStr = [AdsforceHttpUrl jointAdvertiserUrl:urlStr
                                                         aesEncodeKey:aesEncodeKey
                                               enDataStrForAdvertiser:enString
                                                       parameterModel:sessionParameter];
    
    [AdsforceHttpManager sendSessionForAdvertiser:jointParmeterUrlStr retryCount:0 completion:^(id responseObject) {
        NSDictionary *sessionDic = [AdsforceSessionModel convertDicWithModel:sessionModel];
        [[AdsforceFileCache shareInstance] removeDic:sessionDic
                                       channelType:AdsforceFileCacheChannelTypeAdvertiser
                                          pathType:AdsforceFileCachePathTypeSession];
    } error:^(NSError *error) {
    }];
}

+ (void)sendAdsforceSession:(AdsforceSessionModel *)sessionModel {
    AdsforceSessionParameter *sessionParameter = [[AdsforceSessionParameter alloc] initWithSession:sessionModel];
    // The main parameters
    NSString *dataStrForAdsforce = sessionParameter.dataStrForAdsforce;
    
    // Get the domain name path url
    NSString *urlStr = [[AdsforceHttpUrl shareInstance] getSessionUrlForAdsforce];
    
    // Stitching parameter into url
    NSString *jointParameterUrlStr = [AdsforceHttpUrl jointAdsforceUrl:urlStr
                                                  dataStrForAdsforce:dataStrForAdsforce
                                                     parameterModel:sessionParameter];
    
    [AdsforceHttpManager sendSessionForAdsforce:jointParameterUrlStr retryCount:0 completion:^(id responseObject) {
        NSDictionary *sessionDic = [AdsforceSessionModel convertDicWithModel:sessionModel];
        [[AdsforceFileCache shareInstance] removeDic:sessionDic
                                       channelType:AdsforceFileCacheChannelTypeAdsforce
                                          pathType:AdsforceFileCachePathTypeSession];
    } error:^(NSError *error) {
    }];
}

@end
