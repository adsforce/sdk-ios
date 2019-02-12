//
//  XhanceIAPManager.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>

@interface XhanceIAPManager : NSObject

+ (void)appStoreWithProductPrice:(NSNumber *)productPrice
             productCurrencyCode:(NSString *)productCurrencyCode
               receiptDataString:(NSString *)receiptDataString
                          pubkey:(NSString *)pubkey
                          params:(NSDictionary *)params;

+ (void)thirdPayWithProductPrice:(NSNumber *)productPrice
             productCurrencyCode:(NSString *)productCurrencyCode
               productIdentifier:(NSString *)productIdentifier
                 productCategory:(NSString *)productCategory;

+ (void)checkDefeatedIAPAndSendWithChildThread;

@end
