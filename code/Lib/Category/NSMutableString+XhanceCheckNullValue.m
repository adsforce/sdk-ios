//
//  NSMutableString+XhanceCheckNullValue.m
//  XhanceSDK
//
//

#import "NSMutableString+XhanceCheckNullValue.h"

@implementation NSMutableString (XhanceCheckNullValue)

- (void)appendAndCheckString:(NSString *)aString {
    
    if (aString == nil) {
        return;
    }
    [self appendString:aString];
}

@end
