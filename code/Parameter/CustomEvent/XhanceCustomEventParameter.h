//
//  XhanceCustomEventParameter.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>
#import "XhanceBaseParameter.h"
#import "XhanceCustomEventModel.h"

@interface XhanceCustomEventParameter : XhanceBaseParameter

- (instancetype)initWithCustomEventModel:(XhanceCustomEventModel *)model;

@end
