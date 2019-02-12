//
//  STStatisticalUtil.h
//  HolaStatistical
//
//

#import <Foundation/Foundation.h>

@interface XhanceUtil : NSObject

#pragma mark - timeStamp
+ (NSString *)getDateTimeStamp;

+ (NSString *)getDateTimeStampWithDate:(NSDate *)date;

#pragma mark - networkStatus
+ (NSString *)getNetworkStatus;

#pragma mark - deviceInfo
+ (NSString *)getAppVersion;

+ (NSString *)getAppBundle;

+ (NSString *)idfv;

+ (NSString *)idfa;

+ (NSString *)deviceId;

+ (NSString *)platform;

#pragma mark - convert
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

+ (NSString *)arrayToJson:(NSArray *)array;

#pragma mark - URLEncoded
+ (NSString *)URLEncodedString:(NSString *)str;

#pragma mark - sort
+ (NSArray *)sortWithArray:(NSArray <NSString *> *)array;

#pragma mark - url
+ (NSString *)urlWithDomain:(NSString *)domain path:(NSString *)path;

#pragma mark - randomStr
+ (NSString *)get16RandomStr;

#pragma mark - CPU
+ (NSString *)getCPUCores;

#pragma mark - Storage
+ (NSString *)getTotalDiskSpace;

+ (NSString *)getRemainingDiskSpace;

#pragma mark - GoogleBuild
+ (NSString *)getGoogleBuild;

@end
