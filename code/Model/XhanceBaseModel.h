//
//  XhanceBaseModel.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>

@interface XhanceBaseModel : NSObject

@property (nonatomic) NSDate *timeStamp;
@property (nonatomic,copy) NSString *uuid;

- (instancetype)initWithTimeStampAndUUID;

+ (void)convertToDic:(NSMutableDictionary *)dic withModel:(XhanceBaseModel *)model;

+ (void)convertToModel:(XhanceBaseModel *)model withDic:(NSDictionary *)dic;

@end
