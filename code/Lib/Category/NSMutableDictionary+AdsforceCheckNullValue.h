//
//  NSMutableDictionary+AdsforceCheckKeyAndValue.h
//  HolaStatistical
//
//  Created by liuguojun on 2016/12/27.
//  Copyright © 2018 Adsforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (AdsforceCheckKeyAndValue)

- (void)setCheckValue:(id)value forKey:(NSString *)key;

- (void)setCheckObject:(id)anObject forKey:(id<NSCopying>)aKey;

- (id)objectForCheckKey:(NSString *)aKey;

@end

@interface NSDictionary (AdsforceCheckKeyAndValue)

- (id)objectForCheckKey:(NSString *)aKey;

@end
