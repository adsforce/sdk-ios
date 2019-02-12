//
//  XhanceSessionSend.m
//  XhanceSDK
//
//

#import "XhanceSessionSend.h"
#import "XhanceFileCache.h"
#import "XhanceHttpManager.h"
#import "XhanceAES.h"
#import "XhanceSessionParameter.h"
#import "XhanceHttpUrl.h"
#import "XhanceUtil.h"
#import "XhanceRSA.h"
#import "XhanceCpParameter.h"

@implementation XhanceSessionSend

+ (void)sendAdvertiserSession:(XhanceSessionModel *)sessionModel {
    NSString *aesKey = [XhanceUtil get16RandomStr];
    NSString *aesEncodeKey = [XhanceRSA encryptString:aesKey publicKey:[XhanceCpParameter shareinstance].publicKey];
    XhanceSessionParameter *sessionParameter = [[XhanceSessionParameter alloc] initWithSession:sessionModel];
    // The main parameters
    NSString *dataStrForAdvertiser = sessionParameter.dataStrForAdvertiser;
    
    // AES encryption
    NSString *enString = [XhanceAES EnAESandBase64EnToString:dataStrForAdvertiser key:aesKey];
    
    // Get the domain name path url
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getSessionUrlForAdvertiser];
    
    // Stitching parameter into url
    NSString *jointParmeterUrlStr = [XhanceHttpUrl jointAdvertiserUrl:urlStr
                                                         aesEncodeKey:aesEncodeKey
                                               enDataStrForAdvertiser:enString
                                                       parameterModel:sessionParameter];
    
    [XhanceHttpManager sendSessionForAdvertiser:jointParmeterUrlStr retryCount:0 completion:^(id responseObject) {
        NSDictionary *sessionDic = [XhanceSessionModel convertDicWithModel:sessionModel];
        [[XhanceFileCache shareInstance] removeDic:sessionDic
                                       channelType:XhanceFileCacheChannelTypeAdvertiser
                                          pathType:XhanceFileCachePathTypeSession];
    } error:^(NSError *error) {
    }];
}

+ (void)sendXhanceSession:(XhanceSessionModel *)sessionModel {
    XhanceSessionParameter *sessionParameter = [[XhanceSessionParameter alloc] initWithSession:sessionModel];
    // The main parameters
    NSString *dataStrForXhance = sessionParameter.dataStrForXhance;
    
    // Get the domain name path url
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getSessionUrlForXhance];
    
    // Stitching parameter into url
    NSString *jointParameterUrlStr = [XhanceHttpUrl jointXhanceUrl:urlStr
                                                  dataStrForXhance:dataStrForXhance
                                                     parameterModel:sessionParameter];
    
    [XhanceHttpManager sendSessionForXhance:jointParameterUrlStr retryCount:0 completion:^(id responseObject) {
        NSDictionary *sessionDic = [XhanceSessionModel convertDicWithModel:sessionModel];
        [[XhanceFileCache shareInstance] removeDic:sessionDic
                                       channelType:XhanceFileCacheChannelTypeXhance
                                          pathType:XhanceFileCachePathTypeSession];
    } error:^(NSError *error) {
    }];
}

@end
