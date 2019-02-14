//
//  AdsforceEncryptModel.h
//  AdsforceSDK
//
//  Created by steve on 2019/1/18.
//  Copyright © 2019 liuguojun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdsforceEncryptModel : NSObject

@property (nonatomic,copy) NSString *aesKey;
@property (nonatomic,copy) NSString *aesEncodeKey;

+ (instancetype)getModel;

- (BOOL)available;

@end

NS_ASSUME_NONNULL_END
