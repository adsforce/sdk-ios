//
//  XhanceCustomEventSend.m
//  XhanceSDK
//
//

#import "XhanceCustomEventSend.h"
#import "XhanceRSA.h"
#import "XhanceAES.h"
#import "XhanceHttpUrl.h"
#import "XhanceHttpManager.h"
#import "XhanceFileCache.h"

@implementation XhanceCustomEventSend

+ (void)sendAdvertiserCustomEvent:(XhanceCustomEventModel *)model {
    NSString *aesKey = [XhanceUtil get16RandomStr];
    NSString *aesEncodeKey = [XhanceRSA encryptString:aesKey publicKey:[XhanceCpParameter shareinstance].publicKey];
    XhanceCustomEventParameter *customEventParameter = [[XhanceCustomEventParameter alloc] initWithCustomEventModel:model];
    // The main parameters
    NSString *dataStrForAdvertiser = customEventParameter.dataStrForAdvertiser;
    
    // AES encryption
    NSString *enString = [XhanceAES EnAESandBase64EnToString:dataStrForAdvertiser key:aesKey];
    
    // Get the domain name path url
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getCustomEventUrlForAdvertiser];
    
    // Stitching parameter into url
    NSString *jointParmeterUrlStr = [XhanceHttpUrl jointAdvertiserUrl:urlStr
                                                         aesEncodeKey:aesEncodeKey
                                               enDataStrForAdvertiser:enString
                                                       parameterModel:customEventParameter];
    
    [XhanceHttpManager sendCustomEventForAdvertiser:jointParmeterUrlStr retryCount:0 completion:^(id responseObject) {
        NSDictionary *dic = [XhanceCustomEventModel convertDicWithModel:model];
        [[XhanceFileCache shareInstance] removeDic:dic
                                       channelType:XhanceFileCacheChannelTypeAdvertiser
                                          pathType:XhanceFileCachePathTypeCustomEvent];
    } error:^(NSError *error) {}];
}

+ (void)sendXhanceCustomEvent:(XhanceCustomEventModel *)model {
    XhanceCustomEventParameter *customEventParameter = [[XhanceCustomEventParameter alloc] initWithCustomEventModel:model];
    // The main parameters
    NSString *dataStrForXhance = customEventParameter.dataStrForXhance;
    
    // Get the domain name path url
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getCustomEventUrlForXhance];
    
    // Stitching parameter into url
    NSString *jointParameterUrlStr = [XhanceHttpUrl jointXhanceUrl:urlStr
                                                  dataStrForXhance:dataStrForXhance
                                                     parameterModel:customEventParameter];
    
    [XhanceHttpManager sendCustomEventForXhance:jointParameterUrlStr retryCount:0 completion:^(id responseObject) {
        NSDictionary *dic = [XhanceCustomEventModel convertDicWithModel:model];
        [[XhanceFileCache shareInstance] removeDic:dic
                                       channelType:XhanceFileCacheChannelTypeXhance
                                          pathType:XhanceFileCachePathTypeCustomEvent];
    } error:^(NSError *error) {}];
}

@end
