//
//  XhanceParameter.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>
#import "XhanceBaseParameter.h"
#import "XhanceSessionModel.h"

@interface XhanceSessionParameter : XhanceBaseParameter

- (instancetype)initWithSession:(XhanceSessionModel *)session;

@end
