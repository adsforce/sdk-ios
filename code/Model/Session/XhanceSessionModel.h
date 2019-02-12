//
//  XhanceSessionModel.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>
#import "XhanceBaseModel.h"

typedef NS_ENUM (NSInteger, XhanceSessionModelType) {
    XhanceSessionModelTypeStart = 0,
    XhanceSessionModelTypeTimer = 1,
    XhanceSessionModelTypeEnd = 2,
};

@interface XhanceSessionModel : XhanceBaseModel

@property (nonatomic,copy) NSString *sessionID;
@property (nonatomic) XhanceSessionModelType dataType;

- (instancetype)initWithSessionId:(NSString *)sessionId type:(XhanceSessionModelType)type uuid:(NSString *)uuid;

#pragma mark - Util

+ (NSDictionary *)convertDicWithModel:(XhanceSessionModel *)model;

+ (XhanceSessionModel *)convertModelWithDic:(NSDictionary *)dic;

@end
