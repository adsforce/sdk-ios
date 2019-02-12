//
//  XhanceIAPSend.m
//  XhanceSDK
//
//

#import "XhanceIAPSend.h"
#import "XhanceHttpManager.h"
#import "XhanceAES.h"
#import "XhanceIAPParameter.h"
#import "XhanceHttpUrl.h"
#import "XhanceUtil.h"
#import "XhanceRSA.h"
#import "XhanceCpParameter.h"
#import "XhanceIAPModel.h"
#import "XhanceFileCache.h"

@implementation XhanceIAPSend

+ (void)sendAdvertiserIAP:(XhanceIAPModel *)iapModel {
    NSString *aesKey = [XhanceUtil get16RandomStr];
    NSString *aesEncodeKey = [XhanceRSA encryptString:aesKey publicKey:[XhanceCpParameter shareinstance].publicKey];
    XhanceIAPParameter *iapParameter = [[XhanceIAPParameter alloc] initWithIAPModel:iapModel];
    // The main parameters
    NSString *dataStrForAdvertiser = iapParameter.dataStrForAdvertiser;
    
    // AES encryption
    NSString *enString = [XhanceAES EnAESandBase64EnToString:dataStrForAdvertiser key:aesKey];
    
    // Get the domain name path url
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getIAPUrlForAdvertiser];
    
    // Stitching ahs into url
    NSString *ahs = [XhanceMd5Utils MD5OfString:[XhanceCpParameter shareinstance].appId];
    urlStr = [NSString stringWithFormat:@"%@/%@",urlStr,ahs];
    
    // Because IAP parameters are longer, the parameters are placed in the body of the post.
    NSString *parameterStr = [XhanceHttpUrl getAdvertiserParameterStrWithAesEncodeKey:aesEncodeKey
                                                               enDataStrForAdvertiser:enString
                                                                       parameterModel:iapParameter];
    [XhanceHttpManager sendIAPForAdvertiser:urlStr parameterStr:parameterStr retryCount:0 completion:^(id responseObject) {
        NSDictionary *dic = [XhanceIAPModel convertDicWithModel:iapModel];
        [[XhanceFileCache shareInstance] removeDic:dic
                                       channelType:XhanceFileCacheChannelTypeAdvertiser
                                          pathType:XhanceFileCachePathTypeIAP];
    } error:^(NSError *error) {}];
}

+ (void)sendXhanceIAP:(XhanceIAPModel *)iapModel {
    XhanceIAPParameter *iapParameter = [[XhanceIAPParameter alloc] initWithIAPModel:iapModel];
    // The main parameters
    NSString *dataStrForXhance = iapParameter.dataStrForXhance;
    
    // Get the domain name path url
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getIAPUrlForXhance];
    // Stitching ahs into url
    NSString *ahs = [XhanceMd5Utils MD5OfString:[XhanceCpParameter shareinstance].appId];
    urlStr = [NSString stringWithFormat:@"%@/%@",urlStr,ahs];
    
    // Because IAP parameters are longer, the parameters are placed in the body of the post.
    NSString *parameterStr = [XhanceHttpUrl getXhanceParameterStrWithDataStrForXhance:dataStrForXhance
                                                                         parameterModel:iapParameter];
    [XhanceHttpManager sendIAPForXhance:urlStr parameterStr:parameterStr retryCount:0  completion:^(id responseObject) {
        NSDictionary *dic = [XhanceIAPModel convertDicWithModel:iapModel];
        [[XhanceFileCache shareInstance] removeDic:dic
                                       channelType:XhanceFileCacheChannelTypeXhance
                                          pathType:XhanceFileCachePathTypeIAP];
    } error:^(NSError *error) {}];
}

@end
