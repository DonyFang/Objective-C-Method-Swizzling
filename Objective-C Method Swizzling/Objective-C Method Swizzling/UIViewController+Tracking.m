//
//  UIViewController+Tracking.m
//  Objective-C Method Swizzling
//
//  Created by 方冬冬 on 2017/8/1.
//  Copyright © 2017年 方冬冬. All rights reserved.


//   推荐文章。 http://blog.jobbole.com/79580/
//    http://blog.leichunfeng.com/blog/2015/06/14/objective-c-method-swizzling-best-practice/
//    http://yulingtianxia.com/blog/2017/04/17/Objective-C-Method-Swizzling/
//   http://www.tanhao.me/code/160723.html/#more


#import "UIViewController+Tracking.h"
#import <objc/runtime.h>

@implementation UIViewController (Tracking)
+ (void)load{
//。+load会在类初始加载时调用，+initialize会在第一次调用类的类方法或实例方法之前被调用。。+load能保证在类的初始化过程中被加载，
    //Method Swizzling最佳实现方案
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获取类
        Class class = [self class];
        //原始的方法选择器
        SEL originalSelector = @selector(viewWillAppear:);
        //交换后的方法选择器
        SEL swizzledSelector = @selector(FDD_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        //给类添加新方法
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        //交换方法
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        
    });

}

#pragma mark - Method Swizzling

- (void)FDD_viewWillAppear:(BOOL)animated {
    [self FDD_viewWillAppear:animated];
    NSLog(@"viewWillAppear: %@", self);
}

- (void)methods{
//    Runtime提供了一系列的方法来处理与方法相关的操作。包括方法本身及SEL。
    

    // 调用指定方法的实现
//    id method_invoke ( id receiver, Method m, ... );
    
    // 调用返回一个数据结构的方法的实现
//    void method_invoke_stret ( id receiver, Method m, ... );
    
    // 获取方法名
    SEL method_getName ( Method m );
    
    // 返回方法的实现
    IMP method_getImplementation ( Method m );
    
    // 获取描述方法参数和返回值类型的字符串
    const char * method_getTypeEncoding ( Method m );
    
    // 获取方法的返回值类型的字符串
    char * method_copyReturnType ( Method m );
    
    // 获取方法的指定位置参数的类型字符串
    char * method_copyArgumentType ( Method m, unsigned int index );
    
    // 通过引用返回方法的返回值类型字符串
    void method_getReturnType ( Method m, char *dst, size_t dst_len );
    
    // 返回方法的参数的个数
    unsigned int method_getNumberOfArguments ( Method m );
    
    // 通过引用返回方法指定位置参数的类型字符串
    void method_getArgumentType ( Method m, unsigned int index, char *dst, size_t dst_len );
    
    // 返回指定方法的方法描述结构体
    struct objc_method_description * method_getDescription ( Method m );
    
    // 设置方法的实现
    IMP method_setImplementation ( Method m, IMP imp );
    
    // 交换两个方法的实现
    void method_exchangeImplementations ( Method m1, Method m2 );

}

@end
