//
//  STStatisticalUtil.m
//  HolaStatistical
//
//

#import "XhanceUtil.h"
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/sysctl.h>
#import "XhanceStatisticalKeychainDeviceID.h"
#import "XhanceNetConnectionManager.h"

@implementation XhanceUtil

#pragma mark - DateTimeStamp

+ (NSString *)getDateTimeStamp {
    NSTimeInterval recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *str = [NSString stringWithFormat:@"%.0f",recordTime];
    return str;
}

+ (NSString *)getDateTimeStampWithDate:(NSDate *)date {
    NSTimeInterval recordTime = [date timeIntervalSince1970]*1000;
    NSString *str = [NSString stringWithFormat:@"%.0f",recordTime];
    return str;
}

#pragma mark - NetworkStatus

+ (NSString *)getNetworkStatus {
    NSString *str = [[NSString alloc] init];
    if ([[XhanceNetConnectionManager sharedInstance] isWifiConneted]) {
        str = @"1";
    }
    else {
        CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc]init];
        NSString *currentStatus  = networkStatus.currentRadioAccessTechnology;
        
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
            str = @"2";
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
            str = @"2";
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]) {
            str = @"3";
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]) {
            str = @"3";
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]) {
            str = @"3";
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]) {
            str = @"2";
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]) {
            str = @"3";
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]) {
            str = @"3";
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]) {
            str = @"3";
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]) {
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]) {
            str = @"4";
        }
        else {
            str = @"-1";
        }
    }
    
    if (str == nil || [str isEqualToString:@""]) {
        str = @"0";
    }
    
    return str;
}

#pragma mark - AppVersion

+ (NSString *)getAppVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    return app_Version;
}

+ (NSString *)getAppBundle {
    NSString *str = [[NSBundle mainBundle] bundleIdentifier];
    return str;
}

+ (NSString *)idfv {
    NSString *str = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return str;
}

+ (NSString *)idfa {
    NSString *str = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return str;
}

+ (NSString *)platform {
    return @"ios";
}

+ (NSString *)deviceId {
    NSString *str = [XhanceStatisticalKeychainDeviceID deviceID];
    return str;
}

#pragma makr - json

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
    }
    return dic;
}

+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    if (dic == nil || [dic allKeys].count == 0) {
        return @"";
    }

    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&parseError];
    if (parseError) {
        return @"";
    }
    
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (jsonStr == nil) {
        jsonStr = @"";
    }
    return jsonStr;
}

+ (NSString *)arrayToJson:(NSArray *)array {
    if (array == nil || array.count == 0) {
        return @"";
    }
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:kNilOptions error:&parseError];
    if (parseError) {
        return @"";
    }
    
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (jsonStr == nil) {
        jsonStr = @"";
    }
    return jsonStr;
}

#pragma mark - URLEncodedString

+ (NSString *)URLEncodedString:(NSString *)str {
    
    if (str == nil || [str isEqualToString:@""]) {
        return @"";
    }
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version < 9.0f) {
        NSString *encodedString = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes
                                                                 (kCFAllocatorDefault,
                                                                  (CFStringRef)str,
                                                                  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]{}\"",
                                                                  NULL,
                                                                  kCFStringEncodingUTF8));
        return encodedString;
    }
    else {
        NSString *charactersToEscape = @"!$&'()*+,-./:;=?@_~%#[]{}\"";
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
        NSString *encodedString = [str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        
        return encodedString;
    }
}

#pragma mark - sort
//sort key A-Z-a-z,First letter of the same, according to the second letter to the back in turn
+ (NSArray *)sortWithArray:(NSArray <NSString *> *)array {
    NSStringCompareOptions comparisonOptions = NSLiteralSearch|NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2) {
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    
    NSArray *resultArray = [array sortedArrayUsingComparator:sort];
    return resultArray;
}

#pragma mark - url

+ (NSString *)urlWithDomain:(NSString *)domain path:(NSString *)path {
    NSString *lastStr = [domain substringWithRange:NSMakeRange(domain.length-1, 1)];
    if ([lastStr isEqualToString:@"/"]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",domain,path];
        return urlStr;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",domain,path];
    return urlStr;
}

#pragma mark - randomStr
//Returns a string (length of 16 random lowercase letters and Numbers)
+ (NSString *)get16RandomStr {
    return [self getRandomStrWithLength:16];
}

//Returns a random string (lowercase letters and Numbers)
+ (NSString *)getRandomStrWithLength:(int)length {
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString * result = [[NSMutableString alloc]initWithCapacity:length];
    for (int i = 0; i < length; i++) {
        //获取随机数
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    
    return result;
}

#pragma mark - CPU

+ (NSString *)getCPUCores {
    int mib[2] = {CTL_HW, HW_AVAILCPU};
    uint value;
    size_t size = sizeof value;
    if (0 != sysctl(mib, sizeof(mib) / sizeof(mib[0]), &value, &size, NULL, 0)) {
        return @"0";
    }
    
    NSString *str = [NSString stringWithFormat:@"%i",value];
    return str;
    
}

#pragma mark - Storage
static const u_int Xhance_GIGABYTE = 1024 * 1024 * 1024;  // bytes
+ (NSString *)getTotalDiskSpace {
    NSDictionary *attrs = [[[NSFileManager alloc] init] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    float totalDiskSpace = [[attrs objectForKey:NSFileSystemSize] floatValue];
    unsigned long long totalDiskSpaceGB = (unsigned long long)round(totalDiskSpace / Xhance_GIGABYTE);
    NSString *str = [NSString stringWithFormat:@"%lld",totalDiskSpaceGB];
    return str;
}

+ (NSString *)getRemainingDiskSpace {
    NSDictionary *attrs = [[[NSFileManager alloc] init] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    float remainingDiskSpace = [[attrs objectForKey:NSFileSystemFreeSize] floatValue];
    unsigned long long remainingDiskSpaceGB = (unsigned long long)round(remainingDiskSpace / Xhance_GIGABYTE);
    NSString *str = [NSString stringWithFormat:@"%lld",remainingDiskSpaceGB];
    return str;
}

#pragma mark - GoogleBuild
+ (NSString *)getGoogleBuild {
    size_t bufferSize = 64;
    NSMutableData *buffer = [[NSMutableData alloc] initWithLength:bufferSize];
    int status = sysctlbyname("kern.osversion",
                              buffer.mutableBytes,
                              &bufferSize, NULL, 0);
    if (status != 0) {
        return nil;
    }
    NSString *build = [[NSString alloc] initWithCString:buffer.mutableBytes encoding:NSUTF8StringEncoding];
    NSString *str = [NSString stringWithFormat:@"Build/%@",build];
    return str;
}

@end
