//
//  ViewController.m
//  Objective-C Method Swizzling
//
//  Created by 方冬冬 on 2017/8/1.
//  Copyright © 2017年 方冬冬. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+Tracking.h"
#import "Car.h"
#import "NSDictionary+Test.h"
#import <objc/runtime.h>
#import "NSArray+Extension.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Car *car = [[Car alloc] init];
    
    [car run:110];
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    
//    [NSDictionary custome_dictionary];
    
    NSArray *arr  =@[@"0",@"1"];
    //数组越界但是不会奔溃
    [arr objectAtIndex:3];

    
}


+ (void)swizzWithClass:(Class)class originSel:(SEL)originSel newSel:(SEL)newSel{
    
    Method originM = class_getInstanceMethod(class, originSel);
    Method newM = class_getInstanceMethod(class, newSel);
    
    IMP newImp =  method_getImplementation(newM);
    
    BOOL addMethodSucess = class_addMethod(class, newSel, newImp, method_getTypeEncoding(newM));
    
    if (addMethodSucess) {
        class_replaceMethod(class, originSel, newImp, method_getTypeEncoding(newM));
    }else{
        method_exchangeImplementations(originM, newM);
    }
}

+ (void)load{
//    需要保证只执行一次，多次，容易出现不可预知的错误
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzWithClass:[self class] originSel:NSSelectorFromString(@"dealloc") newSel:@selector(swizz_dealloc)];
    });
}
//需要统计事件，或者需要输出Log的时候，可以使用。比如在delloc中，输出log。告诉我们哪个类释放了。
//这样你控制器的释放一目了然。 思路方法如上，你可以根据你自己的需求修改，来达到目的。

- (void)swizz_dealloc{
    
    NSLog(@"%@ 释放 %s",NSStringFromClass([self class]),__func__);
    
    [self swizz_dealloc];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

@end
