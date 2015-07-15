//
//  JRefreshComponent.m
//  CodingRank
//
//  Created by 吴家振 on 15/7/14.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import "JRefreshComponent.h"

@interface JRefreshComponent()

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation JRefreshComponent
#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 准备工作
        [self prepare];
        // 默认是普通状态
        self.state = JRefreshStateNormal;
    }
    return self;
}

- (void)prepare
{
    // 基本属性
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self placeSubviews];
}

- (void)placeSubviews
{
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    // 旧的父控件移除监听
    [self removeObservers];
    if (newSuperview) { // 新的父控件
        // 设置宽度
        self.width = newSuperview.width;
        // 设置位置
        self.originX = 0;
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = self.scrollView.contentInset;
        // 添加监听
        [self addObservers];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.state == JRefreshStateWillRefresh) {
        // 预防view还没显示出来就调用了beginRefreshing
        self.state = JRefreshStateRefreshing;
    }
}

#pragma mark - KVO监听
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:@"contentSize" options:options context:nil];
    self.panGestureRecognizer = self.scrollView.panGestureRecognizer;
    [self.panGestureRecognizer addObserver:self forKeyPath:@"panState" options:options context:nil];
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    [self.superview removeObserver:self forKeyPath:@"contentSize"];;
    [self.panGestureRecognizer removeObserver:self forKeyPath:@"panState"];
    self.panGestureRecognizer = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled || self.hidden) {
        return;
    }
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        [self scrollViewContentSizeDidChange:change];
    } else if ([keyPath isEqualToString:@"contentInset"]) {
        [self scrollViewContentInsetDidChange:change];
    } else if ([keyPath isEqualToString:@"panState"]) {
        [self scrollViewPanStateDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    
}

- (void)scrollViewContentInsetDidChange:(NSDictionary *)change
{
    
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    
}

#pragma mark - 公共方法
#pragma mark 设置回调对象和回调方法
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    self.refreshingTarget = target;
    self.refreshingAction = action;
}

#pragma mark 进入刷新状态
- (void)beginRefreshing
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    }];
    self.pullingPercent = 1.0;
    // 只要正在刷新，就完全显示
    if (self.window) {
        self.state = JRefreshStateRefreshing;
    } else {
        self.state = JRefreshStateWillRefresh;
        // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
        [self setNeedsDisplay];
    }
}

#pragma mark 结束刷新状态
- (void)endRefreshing
{
    self.state = JRefreshStateNormal;
}

#pragma mark 是否正在刷新
- (BOOL)isRefreshing
{
    return self.state == JRefreshStateRefreshing || self.state == JRefreshStateWillRefresh;
}

#pragma mark 自动切换透明度
- (void)setAutoChangeAlpha:(BOOL)autoChangeAlpha
{
    _autoChangeAlpha = autoChangeAlpha;
    if (self.isRefreshing) {
        return;
    }
    if (autoChangeAlpha) {
        self.alpha = self.pullingPercent;
    } else {
        self.alpha = 1.0;
    }
}

#pragma mark 根据拖拽进度设置透明度
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    _pullingPercent = pullingPercent;
    if (self.isRefreshing) {
        return;
    }
    if (self.isAutoChangeAlpha) {
        self.alpha = pullingPercent;
    }
}

#pragma mark - 内部方法
- (void)executeRefreshingCallback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
            ((void(*)(void *, SEL, UIView *))objc_msgSend)((__bridge void *)(self.refreshingTarget), self.refreshingAction, self);
        }
    });
}
@end