//
//  BaseNavigationController.m
//  CodingRank
//
//  Created by 吴家振 on 15/7/13.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.statusBarStyle = UIStatusBarStyleLightContent;
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyle;
}


@end
