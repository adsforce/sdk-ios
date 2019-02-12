//
//  NSMutableDictionary+XhanceCheckKeyAndValue.h
//  HolaStatistical
//
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (XhanceCheckKeyAndValue)

- (void)setCheckValue:(id)value forKey:(NSString *)key;

- (void)setCheckObject:(id)anObject forKey:(id<NSCopying>)aKey;

- (id)objectForCheckKey:(NSString *)aKey;

@end

@interface NSDictionary (XhanceCheckKeyAndValue)

- (id)objectForCheckKey:(NSString *)aKey;

@end
