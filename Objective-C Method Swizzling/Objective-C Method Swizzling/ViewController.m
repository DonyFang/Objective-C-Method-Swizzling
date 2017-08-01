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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Car *car = [[Car alloc] init];
    
    [car run:110];
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

@end
