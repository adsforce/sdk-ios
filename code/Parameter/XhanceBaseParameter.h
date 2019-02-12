//
//  XhanceBaseParameter.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XhanceUtil.h"
#import "XhanceMd5Utils.h"
#import "XhanceCpParameter.h"
#import "NSMutableDictionary+XhanceCheckNullValue.h"

@interface XhanceBaseParameter : NSObject

@property(nonatomic,copy) NSString *timeStamp;      //Timestamp, globally use this one to ensure that each API is unique
@property(nonatomic,copy) NSString *uuid;           //Uuid after md5 encryption

@property(nonatomic) NSMutableDictionary *dataForAdvertiser;    //Attribution data is sent to the advertiser
@property(nonatomic) NSMutableDictionary *dataForXhance;       //Attribution summary data sent to the Xhance

@property(nonatomic,copy) NSString *dataStrForAdvertiser;       //Attribution data str is sent to the advertiser
@property(nonatomic,copy) NSString *dataStrForXhance;          //Attribution summary data str sent to the Xhance

@property(nonatomic) NSMutableDictionary *baseParameterDic;     //Common parameter map

- (instancetype)initWithTimeStamp:(NSString *)timeStamp uuid:(NSString *)uuid;

- (void)createDataForAdvertiser;

- (void)createDataForXhance;

#pragma mark - Util

- (NSString *)sortParameter:(NSMutableDictionary *)parameters;

@end
