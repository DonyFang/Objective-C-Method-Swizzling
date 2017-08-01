//
//  Car.m
//  Objective-C Method Swizzling
//
//  Created by 方冬冬 on 2017/8/1.
//  Copyright © 2017年 方冬冬. All rights reserved.
//

#import "Car.h"

@implementation Car
- (void)run:(double)speed{
    
    NSLog(@"%f",speed);

}
@end
