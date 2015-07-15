//
//  JRefreshComponent.h
//  CodingRank
//
//  Created by 吴家振 on 15/7/14.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import "JRefreshComponent.h"

@interface JRefreshFooter : JRefreshComponent

//显示刷新状态的label
@property (strong, nonatomic) UILabel *stateLabel;

@property (strong, nonatomic) UIImageView *arrowView;
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

//设置state状态下的文字
- (void)setTitle:(NSString *)title forState:(JRefreshState)state;

//创建footer
+ (id)footerWithRefreshingBlock:(JRefreshingBlock)refreshingBlock;
//创建footer
+ (id)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

//提示没有更多的数据
- (void)noticeNoMoreData;
//重置没有更多的数据（消除没有更多数据的状态）
- (void)resetNoMoreData;

//设置state状态下的动画图片images 动画持续时间duration
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(JRefreshState)state;
- (void)setImages:(NSArray *)images forState:(JRefreshState)state;

@end
