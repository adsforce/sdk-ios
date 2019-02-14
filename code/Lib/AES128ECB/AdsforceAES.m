#import "AdsforceAES.h"
#import "AdsforceFBEncryptorAES.h"

@implementation AdsforceAES

#pragma mark - encode

+ (NSData *)EnAESandBase64ToData:(NSString *)str key:(NSString *)kKey {
    NSData *data_aes = [AdsforceFBEncryptorAES encryptData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                                     key:[kKey dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSString* encodeResult = [data_aes base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    return [[NSString stringWithFormat:@"%@",encodeResult] dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)EnAESandBase64EnToString:(NSString *)str key:(NSString *)kKey {
    NSData *data_aes = [AdsforceFBEncryptorAES encryptData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                                     key:[kKey dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSString* encodeResult = [data_aes base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    return [NSString stringWithFormat:@"%@",encodeResult];

}


#pragma mark - decode

+ (NSString *)DeBase64andAESDeToString:(NSString *)str key:(NSString *)kKey {
    
    NSData *data_dec = [AdsforceFBEncryptorAES decryptData:[[NSData alloc] initWithBase64EncodedString:str options:0]
                                                     key:[kKey dataUsingEncoding:NSASCIIStringEncoding]];

    return [[NSString alloc]initWithData:data_dec encoding:NSUTF8StringEncoding];
    
}

+ (NSData *)DeBase64andAESToData:(NSString *)str key:(NSString *)kKey {
    return [AdsforceFBEncryptorAES decryptData:[[NSData alloc] initWithBase64EncodedString:str options:0]
                                         key:[kKey dataUsingEncoding:NSASCIIStringEncoding]];
}

+ (NSDictionary *)DeBase64andAESToDictionary:(NSString *)str key:(NSString *)kKey {
    NSData *data_dec = [AdsforceFBEncryptorAES decryptData:[[NSData alloc] initWithBase64EncodedString:str options:0]
                                                     key:[kKey dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSString *str_dec = [[NSString alloc]initWithData:data_dec encoding:NSUTF8StringEncoding];
    if (!str_dec) {
        return nil;
    }

    NSDictionary *jsonObjects = nil;// [[NSDictionary alloc]init];
    NSError *error = nil;

    jsonObjects = [NSJSONSerialization JSONObjectWithData:[str_dec dataUsingEncoding:NSUTF8StringEncoding]
                                                  options:NSJSONReadingMutableContainers
                                                    error:&error];

    if (error) {
        return  nil;
    }

    return jsonObjects;
}

@end
