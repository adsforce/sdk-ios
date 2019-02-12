//
//  XhanceSessionModel.m
//  XhanceSDK
//
//

#import "XhanceSessionModel.h"

@implementation XhanceSessionModel

#pragma mark - init

- (instancetype)initWithSessionId:(NSString *)sessionId type:(XhanceSessionModelType)type uuid:(NSString *)uuid {
    self = [super initWithTimeStampAndUUID];
    if (self) {
        _sessionID = sessionId;
        _dataType = type;
    }
    return self;
}

#pragma mark - Util

+ (NSDictionary *)convertDicWithModel:(XhanceSessionModel *)model {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [XhanceBaseModel convertToDic:dic withModel:model];
    
    NSString *sessionID = [model.sessionID copy];
    XhanceSessionModelType dataType = model.dataType;
    if (sessionID != nil) {
        [dic setObject:sessionID forKey:@"sessionID"];
    }
    if (dataType == XhanceSessionModelTypeStart
        || dataType == XhanceSessionModelTypeTimer
        || dataType == XhanceSessionModelTypeEnd) {
        NSString *strDataType = [NSString stringWithFormat:@"%i",(int)dataType];
        [dic setObject:strDataType forKey:@"dataType"];
    }
    
    return dic;
}

+ (XhanceSessionModel *)convertModelWithDic:(NSDictionary *)dic {
    XhanceSessionModel *model = [[XhanceSessionModel alloc] init];
    [XhanceBaseModel convertToModel:model withDic:dic];
    
    if ([[dic allKeys] containsObject:@"sessionID"]) {
        model.sessionID = [dic objectForKey:@"sessionID"];
    }
    if ([[dic allKeys] containsObject:@"dataType"]) {
        NSString *strDataType = [dic objectForKey:@"dataType"];
        model.dataType = strDataType.intValue;
    }
    return model;
}

@end
