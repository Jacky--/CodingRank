//
//  JRefreshComponent.h
//  CodingRank
//
//  Created by 吴家振 on 15/7/14.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import "JRefreshComponent.h"

@interface JRefreshHeader : JRefreshComponent

//创建header
+ (id)headerWithRefreshingBlock:(JRefreshingBlock)refreshingBlock;

//上一次下拉刷新成功的时间
@property (strong, nonatomic, readonly) NSDate *lastUpdatedTime;

#pragma mark - 刷新时间相关
//显示上一次刷新时间的label
@property (strong, nonatomic) UILabel *lastUpdatedTimeLabel;

@property (strong, nonatomic) UIImageView *arrowView;

#pragma mark - 状态相关
//显示刷新状态的label
@property (strong, nonatomic) UILabel *stateLabel;

//设置state状态下的文字
- (void)setTitle:(NSString *)title forState:(JRefreshState)state;
//设置state状态下的动画图片images 动画持续时间duration
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(JRefreshState)state;
- (void)setImages:(NSArray *)images forState:(JRefreshState)state;

@end
