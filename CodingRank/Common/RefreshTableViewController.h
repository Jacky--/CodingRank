//
//  RefreshTableViewController.h
//  CodingRank
//
//  Created by 吴家振 on 15/7/15.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRefreshHeader.h"
#import "JRefreshFooter.h"

@interface RefreshTableViewController : UITableViewController

/** 下拉刷新控件 */
@property (strong, nonatomic) JRefreshHeader *header;
/** 上拉刷新控件 */
@property (strong, nonatomic) JRefreshFooter *footer;

@end
