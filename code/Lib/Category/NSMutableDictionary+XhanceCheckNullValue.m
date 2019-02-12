//
//  NSMutableDictionary+XhanceCheckKeyAndValue.m
//  HolaStatistical
//
//

#import "NSMutableDictionary+XhanceCheckNullValue.h"

@implementation NSMutableDictionary (XhanceCheckKeyAndValue)

- (void)setCheckValue:(id)value forKey:(NSString *)key {
    if (key == nil) {
        return;
    }
    
    if (value == nil) {
        [self setValue:@"" forKey:key];
    }
    else {
       [self setValue:value forKey:key];
    }
}

- (void)setCheckObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (aKey == nil) {
        return;
    }
    
    if (anObject == nil) {
        [self setObject:@"" forKey:aKey];
    }
    else {
        [self setObject:anObject forKey:aKey];
    }
}

- (id)objectForCheckKey:(NSString *)aKey {
    if (aKey == nil || [aKey isEqualToString:@""]) {
        return nil;
    }
    if ([self allKeys].count <= 0) {
        return nil;
    }
    if (![[self allKeys] containsObject:aKey]) {
        return nil;
    }
    id obj = [self objectForKey:aKey];
    return obj;
}

@end

@implementation NSDictionary (XhanceCheckKeyAndValue)

- (id)objectForCheckKey:(NSString *)aKey {
    if (aKey == nil || [aKey isEqualToString:@""]) {
        return nil;
    }
    if ([self allKeys].count <= 0) {
        return nil;
    }
    if (![[self allKeys] containsObject:aKey]) {
        return nil;
    }
    id obj = [self objectForKey:aKey];
    return obj;
}

@end
