//
//  XhanceIAPParameter.m
//  XhanceSDK
//
//

#import "XhanceIAPParameter.h"
#import "XhanceSessionManager.h"
#import "XhanceUtil.h"

@interface XhanceIAPParameter ()
{
    XhanceIAPModel *_model;
}
@end

@implementation XhanceIAPParameter

- (instancetype)initWithIAPModel:(XhanceIAPModel *)model {
    NSString *timeStamp = [XhanceUtil getDateTimeStampWithDate:model.timeStamp];
    NSString *uuid = model.uuid;
    self = [super initWithTimeStamp:timeStamp uuid:uuid];
    if (self) {
        _model = model;
        if (model.isThirdPay) {
            [self createDataForAdvertiserWithThirdPay];
        }
        else {
            [self createDataForAdvertiserWithAppStore];
        }
        
        [self createDataForXhance];
    }
    return self;
}

- (void)createDataForAdvertiserWithAppStore {
    NSString *paramsStr = @"";
    if (_model.params) {
        paramsStr = [XhanceUtil dictionaryToJson:_model.params];
        if (paramsStr != nil && ![paramsStr isEqualToString:@""]) {
            NSString *str = [XhanceUtil URLEncodedString:paramsStr];
            paramsStr = str;
        }
    }
    
    /*
     @param cat Short name of category, indicating the classification of events, session cat=revenue_verify
     @param revn Revenue in-app purchases, the unit is the amount, the type is long
     @param revn_curr Revenue_currency Abbreviation for the currency of the purchase of the purchase, three uppercase English characters
     @param pubkey If it is Android, pass the payment public key of gp, if it is ios, pass the shared key.
     @param sign If it is Android, the signature verification returned after gp payment, if it is ios, it will receive receipt
     @param params Json type, cp is set according to map
     */
    NSString *cat = @"revenue_verify";
    NSNumber *revn = _model.productPrice;
    NSString *revn_curr = _model.productCurrencyCode;
    NSString *pubkey = _model.pubkey;
    NSString *sign = _model.receiptDataString;
    NSString *params = paramsStr;
    
    // set IAP parameters
    [self.dataForAdvertiser setCheckObject:cat forKey:@"cat"];
    [self.dataForAdvertiser setCheckObject:revn forKey:@"revn"];
    [self.dataForAdvertiser setCheckObject:revn_curr forKey:@"revn_curr"];
    [self.dataForAdvertiser setCheckObject:pubkey forKey:@"pubkey"];
    [self.dataForAdvertiser setCheckObject:sign forKey:@"sign"];
    [self.dataForAdvertiser setCheckObject:params forKey:@"params"];
    
    [super createDataForAdvertiser];
}

- (void)createDataForAdvertiserWithThirdPay {
    
    /*
     @param cat Short name of category, indicating the classification of events, revenue cat=revenue
     @param revn Revenue in-app purchases, the unit is the amount, the type is long
     @param revn_curr Revenue_currency Abbreviation for the currency of the purchase of the purchase, three uppercase English characters
     @param item_id The id mark of the goods purchased by the in-app purchase
     @param item_cat Classification of goods purchased by pay-per-use
     */
    NSString *cat = @"revenue";
    NSNumber *revn = _model.productPrice;
    NSString *revn_curr = _model.productCurrencyCode;
    NSString *item_id = _model.productIdentifier;
    NSString *item_cat = _model.productCategory;
    
    // set IAP parameters
    [self.dataForAdvertiser setCheckObject:cat forKey:@"cat"];
    [self.dataForAdvertiser setCheckObject:revn forKey:@"revn"];
    [self.dataForAdvertiser setCheckObject:revn_curr forKey:@"revn_curr"];
    [self.dataForAdvertiser setCheckObject:item_id forKey:@"item_id"];
    [self.dataForAdvertiser setCheckObject:item_cat forKey:@"item_cat"];
    
    [super createDataForAdvertiser];
}

- (void)createDataForXhance {
    [super createDataForXhance];
}

@end
