//
//  XhanceCpParameter.h
//  XhanceSDK
//
//

#import <Foundation/Foundation.h>

@interface XhanceCpParameter : NSObject

@property(nonatomic,copy) NSString *appId;
@property(nonatomic,copy) NSString *devKey;
@property(nonatomic,copy) NSString *publicKey;
@property(nonatomic,copy) NSString *trackUrl;
@property(nonatomic,copy) NSString *channelId;

+ (instancetype)shareinstance;

@end
