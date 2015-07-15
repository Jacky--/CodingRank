//
//  JRefreshComponent.h
//  CodingRank
//
//  Created by 吴家振 on 15/7/14.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+JFoundation.h"

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger , JRefreshState){
    JRefreshStateNormal,       //普通闲置状态
    JRefreshStatePulling,      //松开就可以进行刷新的状态
    JRefreshStateRefreshing,   //正在刷新中的状态
    JRefreshStateWillRefresh,  //即将刷新的状态
    JRefreshStateNoMoreData    //所有数据加载完毕，没有更多的数据了
};

//进入刷新状态的回调
typedef void (^JRefreshingBlock)();

//刷新控件的基类
@interface JRefreshComponent : UIView
{
    UIEdgeInsets _scrollViewOriginalInset;  //记录scrollView刚开始的inset
    __weak UIScrollView *_scrollView;       //父控件
}

#pragma mark - 刷新回调
//正在刷新的回调
@property (copy, nonatomic) JRefreshingBlock refreshingBlock;
//设置回调对象和回调方法
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;
//回调对象
@property (weak, nonatomic) id refreshingTarget;
//回调方法
@property (assign, nonatomic) SEL refreshingAction;
//触发回调（交给子类去调用）
- (void)executeRefreshingCallback;

#pragma mark - 刷新状态控制
//进入刷新状态
- (void)beginRefreshing;
//结束刷新状态
- (void)endRefreshing;
//是否正在刷新
- (BOOL)isRefreshing;
//刷新状态 一般交给子类内部实现
@property (assign, nonatomic) JRefreshState state;

#pragma mark - 交给子类去访问
//记录scrollView刚开始的inset
@property (assign, nonatomic, readonly) UIEdgeInsets scrollViewOriginalInset;
//父控件
@property (weak, nonatomic, readonly) UIScrollView *scrollView;

#pragma mark - 交给子类们去实现
//初始化
- (void)prepare;
//摆放子控件frame
- (void)placeSubviews;
//当scrollView的contentOffset发生改变的时候调用
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change;
//当scrollView的contentSize发生改变的时候调用
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change;
//当scrollView的contentInset发生改变的时候调用
- (void)scrollViewContentInsetDidChange:(NSDictionary *)change;
//当scrollView的拖拽状态发生改变的时候调用
- (void)scrollViewPanStateDidChange:(NSDictionary *)change;

#pragma mark - 其他
//拉拽的百分比(交给子类重写)
@property (assign, nonatomic) CGFloat pullingPercent;
//根据拖拽比例自动切换透明度
@property (assign, nonatomic, getter=isAutoChangeAlpha) BOOL autoChangeAlpha;

@end
