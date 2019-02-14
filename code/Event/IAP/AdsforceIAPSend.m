//
//  AdsforceIAPSend.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/5/31.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import "AdsforceIAPSend.h"
#import "AdsforceHttpManager.h"
#import "AdsforceAES.h"
#import "AdsforceIAPParameter.h"
#import "AdsforceHttpUrl.h"
#import "AdsforceUtil.h"
#import "AdsforceRSA.h"
#import "AdsforceCpParameter.h"
#import "AdsforceIAPModel.h"
#import "AdsforceFileCache.h"
#import "AdsforceEncryptModel.h"

@implementation AdsforceIAPSend

+ (void)sendAdvertiserIAP:(AdsforceIAPModel *)iapModel {
//    NSString *aesKey = [AdsforceUtil get16RandomStr];
//    NSString *aesEncodeKey = [AdsforceRSA encryptString:aesKey publicKey:[AdsforceCpParameter shareinstance].publicKey];
    AdsforceEncryptModel *encryptModel = [AdsforceEncryptModel getModel];
    if (![encryptModel available]) {
        return;
    }
    NSString *aesKey = encryptModel.aesKey;
    NSString *aesEncodeKey = encryptModel.aesEncodeKey;
    
    AdsforceIAPParameter *iapParameter = [[AdsforceIAPParameter alloc] initWithIAPModel:iapModel];
    // The main parameters
    NSString *dataStrForAdvertiser = iapParameter.dataStrForAdvertiser;
    
    // AES encryption
    NSString *enString = [AdsforceAES EnAESandBase64EnToString:dataStrForAdvertiser key:aesKey];
    
    // Get the domain name path url
    NSString *urlStr = [[AdsforceHttpUrl shareInstance] getIAPUrlForAdvertiser];
    
    // Stitching ahs into url
    NSString *ahs = [AdsforceMd5Utils MD5OfString:[AdsforceCpParameter shareinstance].appId];
    urlStr = [NSString stringWithFormat:@"%@/%@",urlStr,ahs];
    
    // Because IAP parameters are longer, the parameters are placed in the body of the post.
    NSString *parameterStr = [AdsforceHttpUrl getAdvertiserParameterStrWithAesEncodeKey:aesEncodeKey
                                                               enDataStrForAdvertiser:enString
                                                                       parameterModel:iapParameter];
    [AdsforceHttpManager sendIAPForAdvertiser:urlStr parameterStr:parameterStr retryCount:0 completion:^(id responseObject) {
        NSDictionary *dic = [AdsforceIAPModel convertDicWithModel:iapModel];
        [[AdsforceFileCache shareInstance] removeDic:dic
                                       channelType:AdsforceFileCacheChannelTypeAdvertiser
                                          pathType:AdsforceFileCachePathTypeIAP];
    } error:^(NSError *error) {}];
}

+ (void)sendAdsforceIAP:(AdsforceIAPModel *)iapModel {
    AdsforceIAPParameter *iapParameter = [[AdsforceIAPParameter alloc] initWithIAPModel:iapModel];
    // The main parameters
    NSString *dataStrForAdsforce = iapParameter.dataStrForAdsforce;
    
    // Get the domain name path url
    NSString *urlStr = [[AdsforceHttpUrl shareInstance] getIAPUrlForAdsforce];
    // Stitching ahs into url
    NSString *ahs = [AdsforceMd5Utils MD5OfString:[AdsforceCpParameter shareinstance].appId];
    urlStr = [NSString stringWithFormat:@"%@/%@",urlStr,ahs];
    
    // Because IAP parameters are longer, the parameters are placed in the body of the post.
    NSString *parameterStr = [AdsforceHttpUrl getAdsforceParameterStrWithDataStrForAdsforce:dataStrForAdsforce
                                                                         parameterModel:iapParameter];
    [AdsforceHttpManager sendIAPForAdsforce:urlStr parameterStr:parameterStr retryCount:0  completion:^(id responseObject) {
        NSDictionary *dic = [AdsforceIAPModel convertDicWithModel:iapModel];
        [[AdsforceFileCache shareInstance] removeDic:dic
                                       channelType:AdsforceFileCacheChannelTypeAdsforce
                                          pathType:AdsforceFileCachePathTypeIAP];
    } error:^(NSError *error) {}];
}

@end
