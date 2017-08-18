//
//  NSArray+Extension.m
//  Objective-C Method Swizzling
//
//  Created by 方冬冬 on 2017/8/18.
//  Copyright © 2017年 方冬冬. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
        Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(fd_objectAtIndex:));
        method_exchangeImplementations(fromMethod, toMethod);
        
    });
}
//写在 NSArray的类目里边
- (id)fd_objectAtIndex:(NSUInteger)index {
    if (self.count-1 < index) {
        // 这里做一下异常处理，不然都不知道出错了。
        @try {
            return [self fd_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息，方便我们调试。
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    } else {
        return [self fd_objectAtIndex:index];
    }
}



@end
