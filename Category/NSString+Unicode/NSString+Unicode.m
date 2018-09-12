//
//  NSString+Unicode.m
//  CodeLibary
//
//  Created by zichaochu on 16/9/2.
//  Copyright © 2016年 linxun. All rights reserved.
//

#import "NSString+Unicode.h"
#import <objc/runtime.h>

@implementation NSString (Unicode)

+ (NSString *)stringByReplacingUnicodeString:(NSString *)origin {
    NSMutableString *string = [origin mutableCopy];
    if (string.length > 0) {
        [string replaceOccurrencesOfString:@"\\U" withString:@"\\u" options:0 range:NSMakeRange(0, string.length)];
        CFStringRef transform = CFSTR("Any-Hex/Java");
        CFStringTransform((__bridge CFMutableStringRef)string, NULL, transform, YES);
    }
    return string;
}

@end

@implementation NSArray (Unicode)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(description)), class_getInstanceMethod([self class], @selector(replaceDescription)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(descriptionWithLocale:)), class_getInstanceMethod([self class], @selector(replaceDescriptionWithLocale:)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(descriptionWithLocale:indent:)), class_getInstanceMethod([self class], @selector(replaceDescriptionWithLocale:indent:)));
}

- (NSString *)replaceDescription {
    return [NSString stringByReplacingUnicodeString:[self replaceDescription]];
}

- (NSString *)replaceDescriptionWithLocale:(nullable id)locale {
    return [NSString stringByReplacingUnicodeString:[self replaceDescriptionWithLocale:locale]];
}

- (NSString *)replaceDescriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    return [NSString stringByReplacingUnicodeString:[self replaceDescriptionWithLocale:locale indent:level]];
}

@end

@implementation NSDictionary (Unicode)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(description)), class_getInstanceMethod([self class], @selector(replaceDescription)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(descriptionWithLocale:)), class_getInstanceMethod([self class], @selector(replaceDescriptionWithLocale:)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(descriptionWithLocale:indent:)), class_getInstanceMethod([self class], @selector(replaceDescriptionWithLocale:indent:)));
}

- (NSString *)replaceDescription {
    return [NSString stringByReplacingUnicodeString:[self replaceDescription]];
}

- (NSString *)replaceDescriptionWithLocale:(nullable id)locale {
    return [NSString stringByReplacingUnicodeString:[self replaceDescriptionWithLocale:locale]];
}

- (NSString *)replaceDescriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    return [NSString stringByReplacingUnicodeString:[self replaceDescriptionWithLocale:locale indent:level]];
}

@end

@implementation NSSet (Unicode)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(description)), class_getInstanceMethod([self class], @selector(replaceDescription)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(descriptionWithLocale:)), class_getInstanceMethod([self class], @selector(replaceDescriptionWithLocale:)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(descriptionWithLocale:indent:)), class_getInstanceMethod([self class], @selector(replaceDescriptionWithLocale:indent:)));
}

- (NSString *)replaceDescription {
    return [NSString stringByReplacingUnicodeString:[self replaceDescription]];
}

- (NSString *)replaceDescriptionWithLocale:(nullable id)locale {
    return [NSString stringByReplacingUnicodeString:[self replaceDescriptionWithLocale:locale]];
}

- (NSString *)replaceDescriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    return [NSString stringByReplacingUnicodeString:[self replaceDescriptionWithLocale:locale indent:level]];
}

@end
