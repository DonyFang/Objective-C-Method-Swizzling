//
//  NSDictionary+Test.m
//  Objective-C Method Swizzling
//
//  Created by 方冬冬 on 2017/8/1.
//  Copyright © 2017年 方冬冬. All rights reserved.
//

#import "NSDictionary+Test.h"
#import <objc/runtime.h>
@implementation NSDictionary (Test)
+ (void)load {
    Class cls = [self class];
    SEL originalSelector = @selector(dictionary);
    SEL swizzledSelector = @selector(custome_dictionary);
    
    // 使用class_getClassMethod来获取类方法的Method
    Method originalMethod = class_getClassMethod(cls, originalSelector);
    Method swizzledMethod = class_getClassMethod(cls, swizzledSelector);
    if (!originalMethod || !swizzledMethod) {
        return;
    }
    
    IMP originalIMP = method_getImplementation(originalMethod);
    IMP swizzledIMP = method_getImplementation(swizzledMethod);
    const char *originalType = method_getTypeEncoding(originalMethod);
    const char *swizzledType = method_getTypeEncoding(swizzledMethod);
    
    // 类方法添加,需要将方法添加到MetaClass中
    Class metaClass = objc_getMetaClass(class_getName(cls));
    class_replaceMethod(metaClass,swizzledSelector,originalIMP,originalType);
    class_replaceMethod(metaClass,originalSelector,swizzledIMP,swizzledType);
}
+ (id)custome_dictionary {
    id result = [self custome_dictionary];
    return result;
}
@end
