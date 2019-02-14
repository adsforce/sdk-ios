//
//  AdsforceEncryptModel.m
//  AdsforceSDK
//
//  Created by steve on 2019/1/18.
//  Copyright © 2019 liuguojun. All rights reserved.
//

#import "AdsforceEncryptModel.h"
#import "AdsforceUtil.h"
#import "AdsforceRSA.h"
#import "AdsforceCpParameter.h"

BOOL haveUserDefaultsModel;

@implementation AdsforceEncryptModel

+ (instancetype)getModel {
    AdsforceEncryptModel *model = [[AdsforceEncryptModel alloc] init];
    if (model != nil) {
        BOOL available = [model available];
        if (available) {
            return model;
        }
    }
    
    NSLog(@"AdsforceEncryptModel error line:25");
    AdsforceEncryptModel *userDefaultsModel = [AdsforceEncryptModel getUserDefaultsModel];
    if (userDefaultsModel != nil) {
        BOOL userDefaultsModelAvailable = [userDefaultsModel available];
        if (userDefaultsModelAvailable) {
            return model;
        }
    }
    
    AdsforceEncryptModel *retryModel = [AdsforceEncryptModel getModelWithTryTimes:3];
    if (retryModel != nil) {
        BOOL retryModelAvailable = [retryModel available];
        if (retryModelAvailable) {
            return model;
        }
    }
    
    return nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initModel];
    }
    return self;
}

- (void)initModel {
    NSString *aesKey = [AdsforceUtil get16RandomStr];
    NSString *aesEncodeKey = [AdsforceRSA encryptString:aesKey publicKey:[AdsforceCpParameter shareinstance].publicKey];
    
    if (aesKey == nil || [aesKey isEqualToString:@""] || aesEncodeKey == nil || [aesEncodeKey isEqualToString:@""]) {
        
    } else {
        self.aesKey = [aesKey copy];
        self.aesEncodeKey = [aesEncodeKey copy];
        
        if (!haveUserDefaultsModel) {
            [AdsforceEncryptModel setUserDefaultsModelWithAesKey:self.aesKey aesEncodeKey:self.aesEncodeKey];
            haveUserDefaultsModel = YES;
        }
    }
}

- (BOOL)available {
    if (self.aesKey == nil || [self.aesKey isEqualToString:@""] || self.aesEncodeKey == nil || [self.aesEncodeKey isEqualToString:@""]) {
        return NO;
    } else {
        return YES;
    }
}

+ (instancetype)getUserDefaultsModel {
    NSString *aesKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"aesKey"];
    NSString *aesEncodeKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"aesEncodeKey"];
    
    if (aesKey == nil || [aesKey isEqualToString:@""] || aesEncodeKey == nil || [aesEncodeKey isEqualToString:@""]) {
        return nil;
    } else {
        AdsforceEncryptModel *model = [[AdsforceEncryptModel alloc] init];
        model.aesKey = aesKey;
        model.aesEncodeKey = aesEncodeKey;
        haveUserDefaultsModel = YES;
        return model;
    }
}

+ (void)setUserDefaultsModelWithAesKey:(NSString *)aesKey aesEncodeKey:(NSString *)aesEncodeKey {
    if (aesKey == nil || [aesKey isEqualToString:@""] || aesEncodeKey == nil || [aesEncodeKey isEqualToString:@""]) {
        return;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:aesKey forKey:@"aesKey"];
        [[NSUserDefaults standardUserDefaults] setObject:aesEncodeKey forKey:@"aesEncodeKey"];
    }
}

+ (instancetype)getModelWithTryTimes:(int)tryTime {
    for (int i = 0; i < tryTime; i++) {
        AdsforceEncryptModel *model = [[AdsforceEncryptModel alloc] init];
        BOOL available = [model available];
        if (available) {
            return model;
        }
    }
    return nil;
}

@end
