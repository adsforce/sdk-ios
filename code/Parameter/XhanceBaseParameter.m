//
//  XhanceBaseParameter.m
//  XhanceSDK
//
//

#import "XhanceBaseParameter.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "XhanceSDKVersion.h"
#import "NSMutableString+XhanceCheckNullValue.h"
#import "XhanceBase64Utils.h"

@interface XhanceBaseParameter ()

@end

@implementation XhanceBaseParameter
@synthesize timeStamp = _timeStamp;
@synthesize uuid = _uuid;
@synthesize dataForAdvertiser = _dataForAdvertiser;
@synthesize dataForXhance = _dataForXhance;
@synthesize dataStrForAdvertiser = _dataStrForAdvertiser;
@synthesize dataStrForXhance = _dataStrForXhance;
@synthesize baseParameterDic = _baseParameterDic;

- (instancetype)initWithTimeStamp:(NSString *)timeStamp uuid:(NSString *)uuid {
    self = [super init];
    if (self) {
        _timeStamp = [timeStamp copy];
        _uuid = [uuid copy];
        [self createBaseParameter];
        _dataForAdvertiser = [[NSMutableDictionary alloc] init];
        _dataForXhance = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)createBaseParameter {
    UIDevice *device = [[UIDevice alloc] init];
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *ctcarrier = [networkInfo subscriberCellularProvider];
    
    /*
    @param cts UTC timestamp (ms)
    @param devkey CP incoming
    @param idfa idfa
    @param idf idfv
    @param d Device id
    @param aon System version number
    @param b Mobile phone brands
    @param n network status
    @param pkg pkg
    @param m phone model
    @param lang Mobile language
    @param pvc product versionCode
    @param pvn product versionName
    @param w Screen width
    @param h Screen height
    @param appid itunes connect appId
    @param local Device Local like : it_IT
    @param tz_abb Device timezone abbreviation: CEST
    @param tz Device timezone: Europe/Rome
    @param carrier Carrier name: vodafone IT
    @param density Device screen density: 2.00
    @param cpu_n  Number of CPU cores: 8
    @param ex_stg External storage size (GB): 10
    @param av_stg Available storage size (GB): 3
    @param f_cookie facebook cookie Starting from ios7 are nil
    @param build google build
    @param l_fp local fingerprint Locally generated device fingerprint information
    @param sdk_ver SDK version
    @param name Device name
    @param cid channel id
     */
    NSString *cts = _timeStamp;
    NSString *devkey = [XhanceCpParameter shareinstance].devKey;
    NSString *idfa = [XhanceUtil idfa];
    NSString *idfv = [XhanceUtil idfv];
    NSString *d = [XhanceUtil deviceId];
    NSString *aon = device.systemVersion;
    NSString *b = @"iOS";
    NSString *n = [XhanceUtil getNetworkStatus];
    NSString *pkg = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *m = device.model;
    NSString *lang = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *pvc = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *pvn = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *w = [NSString stringWithFormat:@"%.0f",[[UIScreen mainScreen] bounds].size.width * [[UIScreen mainScreen] scale]];
    NSString *h = [NSString stringWithFormat:@"%.0f",[[UIScreen mainScreen] bounds].size.height * [[UIScreen mainScreen] scale]];
    NSString *appid = [XhanceCpParameter shareinstance].appId;
    NSString *local = [[NSLocale currentLocale] localeIdentifier];
    NSString *tz_abb = [NSTimeZone systemTimeZone].abbreviation;
    NSString *tz = [NSTimeZone systemTimeZone].name;
    NSString *carrier = [ctcarrier carrierName]?[ctcarrier carrierName]:@"NoCarrier";
    NSString *density = [NSString stringWithFormat:@"%.02f",[UIScreen mainScreen].scale];
    NSString *cpu_n = [XhanceUtil getCPUCores];
    NSString *ex_stg = [XhanceUtil getTotalDiskSpace];
    NSString *av_stg = [XhanceUtil getRemainingDiskSpace];
    NSString *f_cookie = @"";
    NSString *build = [XhanceUtil getGoogleBuild];
    NSString *l_fp = @"";
    NSString *sdk_ver = XhanceSDK_VERSION;
    NSString *name = device.name;
    NSString *cid = [XhanceCpParameter shareinstance].channelId;
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setCheckObject:cts forKey:@"cts"];
    [parameters setCheckObject:devkey forKey:@"devkey"];
    [parameters setCheckObject:idfa forKey:@"idfa"];
    [parameters setCheckObject:idfv forKey:@"idfv"];
    [parameters setCheckObject:d forKey:@"d"];
    [parameters setCheckObject:aon forKey:@"aon"];
    [parameters setCheckObject:b forKey:@"b"];
    [parameters setCheckObject:n forKey:@"n"];
    [parameters setCheckObject:pkg forKey:@"pkg"];
    [parameters setCheckObject:m forKey:@"m"];
    [parameters setCheckObject:lang forKey:@"lang"];
    [parameters setCheckObject:pvc forKey:@"pvc"];
    [parameters setCheckObject:pvn forKey:@"pvn"];
    [parameters setCheckObject:w forKey:@"w"];
    [parameters setCheckObject:h forKey:@"h"];
    [parameters setCheckObject:appid forKey:@"appid"];
    [parameters setCheckObject:local forKey:@"local"];
    [parameters setCheckObject:tz_abb forKey:@"tz_abb"];
    [parameters setCheckObject:tz forKey:@"tz"];
    [parameters setCheckObject:carrier forKey:@"carrier"];
    [parameters setCheckObject:density forKey:@"density"];
    [parameters setCheckObject:cpu_n forKey:@"cpu_n"];
    [parameters setCheckObject:ex_stg forKey:@"ex_stg"];
    [parameters setCheckObject:av_stg forKey:@"av_stg"];
    [parameters setCheckObject:f_cookie forKey:@"f_cookie"];
    [parameters setCheckObject:build forKey:@"build"];
    [parameters setCheckObject:l_fp forKey:@"l_fp"];
    [parameters setCheckObject:sdk_ver forKey:@"sdk_ver"];
    [parameters setCheckObject:name forKey:@"name"];
    [parameters setCheckObject:cid forKey:@"cid"];
    
    _baseParameterDic = parameters;
}

- (void)createDataForAdvertiser {
    [_dataForAdvertiser addEntriesFromDictionary:_baseParameterDic];
    _dataStrForAdvertiser = [self sortParameter:_dataForAdvertiser];
}

- (void)createDataForXhance {
    NSString *idfa = [XhanceUtil idfa];
    NSString *idfv = [XhanceUtil idfv];
    
    NSString *cts = self.timeStamp;
    NSString *ahs = [XhanceMd5Utils MD5OfString:[XhanceCpParameter shareinstance].appId];
    NSString *dvhs = [XhanceMd5Utils MD5OfString:[NSString stringWithFormat:@"idfa=%@&idfv=%@",idfa,idfv]];
    NSString *dths = [XhanceMd5Utils MD5OfString:_dataStrForAdvertiser];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setCheckObject:cts forKey:@"cts"];
    [parameters setCheckObject:ahs forKey:@"ahs"];
    [parameters setCheckObject:dvhs forKey:@"dvhs"];
    [parameters setCheckObject:dths forKey:@"dths"];
    
    _dataForXhance = parameters;
    _dataStrForXhance = [self sortParameter:_dataForXhance];
}

#pragma mark - Util

- (NSString *)sortParameter:(NSMutableDictionary *)parameters {
    NSMutableString *parametersStr = [[NSMutableString alloc] init];
    int i = 0;
    NSArray *sortArr = [XhanceUtil sortWithArray:[parameters allKeys]];
    for (NSString *key in sortArr) {
        NSString *value = [parameters objectForKey:key];
        if (i == 0) {
        }
        else {
            [parametersStr appendAndCheckString:@"&"];
        }
        [parametersStr appendFormat:@"%@=%@",key,value];
        i++;
    }
    
    NSString *str = [NSString stringWithFormat:@"%@",parametersStr];
    return str;
}

@end
