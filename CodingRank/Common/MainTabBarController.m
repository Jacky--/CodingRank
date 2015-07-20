//
//  MainTabBarController.m
//  CodingRank
//
//  Created by 吴家振 on 15/7/16.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavigationController.h"
#import "UserRankViewController.h"
#import "RepositoryRankViewController.h"
#import "MoreViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (id)init
{
    if (self = [super init]) {
        [self setUpViewControllers];
        [self setUpItemView];
        self.tabBar.backgroundColor=[UIColor whiteColor];
        self.tabBar.tintColor = [UIColor blackColor];
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpItemView
{
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    tabBarItem1.title = @"Users";
    tabBarItem1.image = [UIImage imageNamed:@"github60"];
    tabBarItem2.title = @"Repositories";
    tabBarItem2.image = [UIImage imageNamed:@"github160"];
    tabBarItem3.title = @"More";
    tabBarItem3.image = [UIImage imageNamed:@"more"];
}

- (void)setUpViewControllers
{
    UserRankViewController *userRankController = [[UserRankViewController alloc] initWithStyle:UITableViewStyleGrouped];
    BaseNavigationController *userRank = [[BaseNavigationController alloc] initWithRootViewController:userRankController];
    
    RepositoryRankViewController *repositoryRankController = [[RepositoryRankViewController alloc] initWithStyle:UITableViewStyleGrouped];
    BaseNavigationController *repositoryRank = [[BaseNavigationController alloc] initWithRootViewController:repositoryRankController];
    
    MoreViewController *moreController = [[MoreViewController alloc] init];
    BaseNavigationController *more = [[BaseNavigationController alloc] initWithRootViewController:moreController];
    
    self.viewControllers = @[userRank,repositoryRank,more];
}

@end
