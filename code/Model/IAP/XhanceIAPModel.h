//
//  XhanceIAPModel.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>
#import "XhanceBaseModel.h"

@interface XhanceIAPModel : XhanceBaseModel

@property (nonatomic) NSNumber *productPrice;
@property (nonatomic,copy) NSString *productCurrencyCode;
@property (nonatomic,copy) NSString *productIdentifier;
@property (nonatomic,copy) NSString *productCategory;
@property (nonatomic,copy) NSString *receiptDataString;
@property (nonatomic,copy) NSString *pubkey;
@property (nonatomic,copy) NSDictionary *params;
@property (nonatomic) BOOL isThirdPay;

- (instancetype)initWithProductPrice:(NSNumber *)productPrice
                 productCurrencyCode:(NSString *)productCurrencyCode
                   productIdentifier:(NSString *)productIdentifier
                     productCategory:(NSString *)productCategory
                   receiptDataString:(NSString *)receiptDataString
                              pubkey:(NSString *)pubkey
                              params:(NSDictionary *)params
                          isThirdPay:(BOOL)isThirdPay;

#pragma mark - Util

+ (NSDictionary *)convertDicWithModel:(XhanceIAPModel *)model;

+ (XhanceIAPModel *)convertModelWithDic:(NSDictionary *)dic;

@end
