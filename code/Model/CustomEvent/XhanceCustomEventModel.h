//
//  XhanceCustomEventModel.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>
#import "XhanceBaseModel.h"

@interface XhanceCustomEventModel : XhanceBaseModel

@property (nonatomic,copy) NSString *key;
@property (nonatomic) NSObject *value;

- (instancetype)initWithKey:(NSString *)key value:(NSObject *)value;

#pragma mark - Util

+ (NSDictionary *)convertDicWithModel:(XhanceCustomEventModel *)model;

+ (XhanceCustomEventModel *)convertModelWithDic:(NSDictionary *)dic;

@end
