//
//  AdsforceIapModel.m
//  AdsforceSDK
//
//  Created by liuguojun on 2018/8/28.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import "AdsforceIAPModel.h"
#import "NSMutableDictionary+AdsforceCheckNullValue.h"
#import "AdsforceUtil.h"

@implementation AdsforceIAPModel

- (instancetype)initWithProductPrice:(NSNumber *)productPrice
                 productCurrencyCode:(NSString *)productCurrencyCode
                   productIdentifier:(NSString *)productIdentifier
                     productCategory:(NSString *)productCategory
                   receiptDataString:(NSString *)receiptDataString
                              pubkey:(NSString *)pubkey
                              params:(NSDictionary *)params
                          isThirdPay:(BOOL)isThirdPay {
    self = [super initWithTimeStampAndUUID];
    if (self) {
        _productPrice = productPrice;
        _productCurrencyCode = [productCurrencyCode copy];
        _productIdentifier = [productIdentifier copy];
        _productCategory = [productCategory copy];
        _receiptDataString = [receiptDataString copy];
        _pubkey = [pubkey copy];
        _params = params;
        _isThirdPay = isThirdPay;
    }
    return self;
}

#pragma mark - Util

+ (NSDictionary *)convertDicWithModel:(AdsforceIAPModel *)model {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [AdsforceBaseModel convertToDic:dic withModel:model];
    
    [dic setCheckValue:model.productPrice forKey:@"productPrice"];
    [dic setCheckValue:model.productCurrencyCode forKey:@"productCurrencyCode"];
    [dic setCheckValue:model.productIdentifier forKey:@"productIdentifier"];
    [dic setCheckValue:model.productCategory forKey:@"productCategory"];
    [dic setCheckValue:model.receiptDataString forKey:@"receiptDataString"];
    [dic setCheckValue:model.pubkey forKey:@"pubkey"];
    [dic setCheckValue:model.params forKey:@"params"];
    [dic setCheckValue:[NSNumber numberWithBool:model.isThirdPay] forKey:@"isThirdPay"];
    
    return dic;
}

+ (AdsforceIAPModel *)convertModelWithDic:(NSDictionary *)dic {
    AdsforceIAPModel *model = [[AdsforceIAPModel alloc] init];
    [AdsforceBaseModel convertToModel:model withDic:dic];
    
    model.productPrice = [dic objectForCheckKey:@"productPrice"];
    model.productCurrencyCode = [dic objectForCheckKey:@"productCurrencyCode"];
    model.productIdentifier = [dic objectForCheckKey:@"productIdentifier"];
    model.productCategory = [dic objectForCheckKey:@"productCategory"];
    model.receiptDataString = [dic objectForCheckKey:@"receiptDataString"];
    model.pubkey = [dic objectForCheckKey:@"pubkey"];
    NSString *paramsStr = [dic objectForCheckKey:@"params"];
    NSDictionary *params = [AdsforceUtil dictionaryWithJsonString:paramsStr];
    model.params = params;
    NSNumber *isThirdPay = [dic objectForCheckKey:@"isThirdPay"];
    model.isThirdPay = isThirdPay.boolValue;
    
    return model;
}

@end
