//
//  JRefreshComponent.h
//  CodingRank
//
//  Created by 吴家振 on 15/7/14.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import "JRefreshFooter.h"

@interface JRefreshFooter()
{
    BOOL hasGifView;
}

@property (assign, nonatomic) NSInteger lastRefreshCount;
@property (assign, nonatomic) CGFloat lastBottomDelta;
@property (strong, nonatomic) NSMutableDictionary *stateTitles;     //所有状态对应的文字
@property (strong, nonatomic) UIActivityIndicatorView *loadingView;
@property (strong, nonatomic) UIImageView *gifView;
@property (strong, nonatomic) NSMutableDictionary *stateImages;     //所有状态对应的动画图片
@property (strong, nonatomic) NSMutableDictionary *stateDurations;  //所有状态对应的动画时间

@end

@implementation JRefreshFooter

#pragma mark - 构造方法
+ (id)footerWithRefreshingBlock:(JRefreshingBlock)refreshingBlock
{
    JRefreshFooter *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}

- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont boldSystemFontOfSize:14];
        _stateLabel.textColor = [UIColor colorWithRed:(90)/255.0 green:(90)/255.0 blue:(90)/255.0 alpha:1.0];
        _stateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_stateLabel];
    }
    return _stateLabel;
}

- (UIImageView *)arrowView
{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    }
    return _arrowView;
}

- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _loadingView.hidesWhenStopped = YES;
    }
    return _loadingView;
}

- (UIImageView *)gifView
{
    if (!_gifView) {
        _gifView = [[UIImageView alloc] init];
    }
    return _gifView;
}

- (NSMutableDictionary *)stateImages
{
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    // 设置自己的高度
    self.height = 44.0;
    // 初始化文字
    [self setTitle:@"上拉可以加载更多" forState:JRefreshStateNormal];
    [self setTitle:@"松开立即加载更多" forState:JRefreshStatePulling];
    [self setTitle:@"正在加载更多的数据..." forState:JRefreshStateRefreshing];
    [self setTitle:@"已经全部加载完毕" forState:JRefreshStateNoMoreData];
    
    //    // 设置普通状态的动画图片
    //    NSMutableArray *idleImages = [NSMutableArray array];
    //    for (NSUInteger i = 1; i<=60; i++) {
    //        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
    //        [idleImages addObject:image];
    //    }
    //    [self setImages:idleImages forState:JRefreshStateNormal];
    //
    //    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    //    NSMutableArray *refreshingImages = [NSMutableArray array];
    //    for (NSUInteger i = 1; i<=3; i++) {
    //        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
    //        [refreshingImages addObject:image];
    //    }
    //    [self setImages:refreshingImages forState:JRefreshStatePulling];
    //
    //    // 设置正在刷新状态的动画图片
    //    [self setImages:refreshingImages forState:JRefreshStateRefreshing];
    
    NSArray *images = self.stateImages[@(JRefreshStateNormal)];
    if (images.count == 0) {
        hasGifView = NO;
        [self addSubview:self.arrowView];
        [self addSubview:self.loadingView];
    }else {
        hasGifView = YES;
        [self addSubview:self.gifView];
    }
}

- (void)placeSubviews
{
    [super placeSubviews];
    // 状态标签
    self.stateLabel.frame = self.bounds;
    if (hasGifView) {
        self.gifView.frame = self.bounds;
        if (self.stateLabel.hidden) {
            self.gifView.contentMode = UIViewContentModeCenter;
        } else {
            self.gifView.contentMode = UIViewContentModeRight;
            self.gifView.width = self.width * 0.5 - 90;
        }
    }else {
        // 箭头
        self.arrowView.size = self.arrowView.image.size;
        CGFloat arrowCenterX = self.width * 0.5;
        if (!self.stateLabel.hidden) {
            arrowCenterX -= 100;
        }
        CGFloat arrowCenterY = self.height * 0.5;
        self.arrowView.center = CGPointMake(arrowCenterX, arrowCenterY);
        // 圈圈
        self.loadingView.frame = self.arrowView.frame;
    }
}

#pragma mark - 公共方法
- (void)noticeNoMoreData
{
    self.state = JRefreshStateNoMoreData;
}

- (void)resetNoMoreData
{
    self.state = JRefreshStateNormal;
}

- (void)endRefreshing
{
    if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [super endRefreshing];
        });
    } else {
        [super endRefreshing];
    }
}

- (void)setTitle:(NSString *)title forState:(JRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(JRefreshState)state
{
    if (images == nil) return;
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    //根据图片设置控件的高度
    UIImage *image = [images firstObject];
    if (image.size.height > self.height) {
        self.height = image.size.height;
    }
}

- (void)setImages:(NSArray *)images forState:(JRefreshState)state
{
    [self setImages:images duration:images.count * 0.1 forState:state];
}


#pragma mark - 实现父类的方法
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    // 如果正在刷新，直接返回
    if (self.state == JRefreshStateRefreshing) {
        return;
    }
    _scrollViewOriginalInset = self.scrollView.contentInset;
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.contentOffset.y;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) {
        return;
    }
    CGFloat pullingPercent = (currentOffsetY - happenOffsetY) / self.height;
    // 如果已全部加载，仅设置pullingPercent，然后返回
    if (self.state == JRefreshStateNoMoreData) {
        self.pullingPercent = pullingPercent;
        return;
    }
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY + self.height;
        
        if (self.state == JRefreshStateNormal && currentOffsetY > normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = JRefreshStatePulling;
        } else if (self.state == JRefreshStatePulling && currentOffsetY <= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = JRefreshStateNormal;
        }
    } else if (self.state == JRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    // 内容的高度
    CGFloat contentHeight = self.scrollView.contentSize.height;
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom;
    // 这里一定是用：self.scrollView.mj_insetT 和 self.scrollViewOriginalInset.bottom;
    // 设置位置和尺寸
    self.originY = MAX(contentHeight, scrollHeight);
}

- (void)setState:(JRefreshState)state
{
    JRefreshState oldState = self.state;
    if (state == oldState) {
        return;
    }
    [super setState:state];
    // 根据状态来设置属性
    if (state == JRefreshStateNoMoreData || state == JRefreshStateNormal) {
        // 刷新完毕
        if (JRefreshStateRefreshing == oldState) {
            [UIView animateWithDuration:0.4 animations:^{
                UIEdgeInsets inset = self.scrollView.contentInset;
                inset.bottom -= self.lastBottomDelta;
                self.scrollView.contentInset = inset;
                // 自动调整透明度
                if (self.isAutoChangeAlpha) {
                    self.alpha = 0.0;
                }
            } completion:^(BOOL finished) {
                self.pullingPercent = 0.0;
            }];
            
            if (!hasGifView) {
                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
                [UIView animateWithDuration:0.4 animations:^{
                    self.loadingView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    self.loadingView.alpha = 1.0;
                    [self.loadingView stopAnimating];
                    self.arrowView.hidden = NO;
                }];
            }
        }else {
            if (!hasGifView) {
                self.arrowView.hidden = NO;
                [self.loadingView stopAnimating];
                [UIView animateWithDuration:0.25 animations:^{
                    self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
                }];
            }
        }
        
        CGFloat deltaH = [self heightForContentBreakView];
        NSInteger currentCount = [self totalDataCountInScrollView];
        // 刚刷新完毕
        if (JRefreshStateRefreshing == oldState && deltaH > 0 && currentCount != self.lastRefreshCount) {
            CGPoint offset = self.scrollView.contentOffset;
            offset.y = self.scrollView.contentOffset.y;
            self.scrollView.contentOffset = offset;
        }
        
        if (state == JRefreshStateNoMoreData) {
            if (!hasGifView) {
                self.arrowView.hidden = YES;
                [self.loadingView stopAnimating];
            }else {
                self.gifView.hidden = YES;
            }
        }else {
            if (hasGifView) {
                self.gifView.hidden = NO;
            }
        }
        
    } else if (state == JRefreshStateRefreshing) {
        // 记录刷新前的数量
        self.lastRefreshCount = [self totalDataCountInScrollView];
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat bottom = self.height + self.scrollViewOriginalInset.bottom;
            CGFloat deltaH = [self heightForContentBreakView];
            if (deltaH < 0) { // 如果内容高度小于view的高度
                bottom -= deltaH;
            }
            self.lastBottomDelta = bottom - self.scrollView.contentInset.bottom;
            UIEdgeInsets inset = self.scrollView.contentInset;
            inset.bottom = bottom;
            self.scrollView.contentInset = inset;
            CGPoint offset = self.scrollView.contentOffset;
            offset.y = [self happenOffsetY] + self.height;
            self.scrollView.contentOffset = offset;
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
        
        if (hasGifView) {
            NSArray *images = self.stateImages[@(state)];
            if (images.count == 0) {
                return;
            }
            self.gifView.hidden = NO;
            [self.gifView stopAnimating];
            if (images.count == 1) { // 单张图片
                self.gifView.image = [images lastObject];
            } else { // 多张图片
                self.gifView.animationImages = images;
                self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
                [self.gifView startAnimating];
            }
        }else {
            self.arrowView.hidden = YES;
            [self.loadingView startAnimating];
        }
    }else if (state == JRefreshStatePulling) {
        if (hasGifView) {
            NSArray *images = self.stateImages[@(state)];
            if (images.count == 0) {
                return;
            }
            self.gifView.hidden = NO;
            [self.gifView stopAnimating];
            if (images.count == 1) { // 单张图片
                self.gifView.image = [images lastObject];
            } else { // 多张图片
                self.gifView.animationImages = images;
                self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
                [self.gifView startAnimating];
            }
        }else {
            self.arrowView.hidden = NO;
            [self.loadingView stopAnimating];
            [UIView animateWithDuration:0.25 animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
        }
    }
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(JRefreshStateNormal)];
    if (self.state != JRefreshStateNormal || images.count == 0) {
        return;
    }
    [self.gifView stopAnimating];
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
}

#pragma mark - 私有方法
#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.y
- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}

- (NSInteger)totalDataCountInScrollView
{
    NSInteger totalCount = 0;
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.scrollView;
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self.scrollView;
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

@end
