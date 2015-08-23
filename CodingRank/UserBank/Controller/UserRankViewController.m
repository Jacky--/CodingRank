//
//  UserRankViewController.m
//  CodingRank
//
//  Created by 吴家振 on 15/7/16.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import "UserRankViewController.h"
#import "UsersApi.h"

@interface UserRankViewController ()

/** 下拉刷新控件 */
@property (strong, nonatomic) JRefreshHeader *header;
/** 上拉刷新控件 */
@property (strong, nonatomic) JRefreshFooter *footer;

@end

@implementation UserRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Users";
    self.header = [JRefreshHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    [self.tableView addSubview:self.header];
    [self refreshData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData
{
    UsersApi *api = [[UsersApi alloc] initWithLocation:@"china" andLanguage:@"" andPage:@"1"];
    [api startWithCompletionBlockWithSuccess:^(JBaseRequest *request) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.header endRefreshing];
    } failure:^(JBaseRequest *request) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
