//
//  MyCar.m
//  Objective-C Method Swizzling
//
//  Created by 方冬冬 on 2017/8/1.
//  Copyright © 2017年 方冬冬. All rights reserved.
//

#import "MyCar.h"
#import <objc/runtime.h>

@implementation MyCar
- (void)carrun:(double)speed{    
    if (speed < 120) {
        [self carrun:speed];
    }

}

+ (void)load {
    Class originalClass = NSClassFromString(@"Car");
    Class swizzledClass = [self class];
    SEL originalSelector = NSSelectorFromString(@"run:");
    SEL swizzledSelector = @selector(carrun:);
    Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
    
    // 向Car类中新添加一个xxx_run:的方法
    BOOL registerMethod = class_addMethod(originalClass,
                                          swizzledSelector,
                                          method_getImplementation(swizzledMethod),
                                          method_getTypeEncoding(swizzledMethod));
    if (!registerMethod) {
        return;
    }
    
    // 需要更新swizzledMethod变量,获取当前Car类中xxx_run:的Method指针
    swizzledMethod = class_getInstanceMethod(originalClass, swizzledSelector);
    if (!swizzledMethod) {
        return;
    }
    
    // 后续流程与之前的一致
    BOOL didAddMethod = class_addMethod(originalClass,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(originalClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}



@end
