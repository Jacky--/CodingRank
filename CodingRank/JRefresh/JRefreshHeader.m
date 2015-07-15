//
//  JRefreshComponent.h
//  CodingRank
//
//  Created by 吴家振 on 15/7/14.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import "JRefreshHeader.h"

@interface JRefreshHeader()
{
    BOOL hasGifView;
}
//所有状态对应的文字
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@property (strong, nonatomic) UIActivityIndicatorView *loadingView;
@property (strong, nonatomic) UIImageView *gifView;
@property (strong, nonatomic) NSMutableDictionary *stateImages;     //所有状态对应的动画图片
@property (strong, nonatomic) NSMutableDictionary *stateDurations;  //所有状态对应的动画时间

@end

@implementation JRefreshHeader

#pragma mark - 构造方法
+ (id)headerWithRefreshingBlock:(JRefreshingBlock)refreshingBlock
{
    JRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}

+ (id)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    JRefreshHeader *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
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

- (UILabel *)lastUpdatedTimeLabel
{
    if (!_lastUpdatedTimeLabel) {
        _lastUpdatedTimeLabel = [[UILabel alloc] init];
        _lastUpdatedTimeLabel.font = [UIFont boldSystemFontOfSize:14];
        _lastUpdatedTimeLabel.textColor = [UIColor colorWithRed:(90)/255.0 green:(90)/255.0 blue:(90)/255.0 alpha:1.0];
        _lastUpdatedTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _lastUpdatedTimeLabel.textAlignment = NSTextAlignmentCenter;
        _lastUpdatedTimeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_lastUpdatedTimeLabel];
    }
    return _lastUpdatedTimeLabel;
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
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
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

#pragma mark - 覆盖父类的方法
- (void)prepare
{
    [super prepare];
    // 设置key
    self.lastUpdatedTimeKey = @"JRefreshHeaderLastUpdatedTimeKey";
    // 设置高度
    self.height = 54.0;
    // 初始化文字
    [self setTitle:@"下拉可以刷新" forState:JRefreshStateNormal];
    [self setTitle:@"松开立即刷新" forState:JRefreshStatePulling];
    [self setTitle:@"正在刷新数据中..." forState:JRefreshStateRefreshing];
    
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
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }else {
        hasGifView = YES;
        [self addSubview:self.gifView];
    }
}

- (void)placeSubviews
{
    [super placeSubviews];
    // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
    self.originY = - self.height;
    if (self.stateLabel.hidden) {
        return;
    }
    if (self.lastUpdatedTimeLabel.hidden) {
        // 状态
        self.stateLabel.frame = self.bounds;
    } else {
        // 状态
        self.stateLabel.originX = 0;
        self.stateLabel.originY = 0;
        self.stateLabel.width = self.width;
        self.stateLabel.height = self.height * 0.5;
        // 更新时间
        self.lastUpdatedTimeLabel.originX = 0;
        self.lastUpdatedTimeLabel.originY = self.stateLabel.height;
        self.lastUpdatedTimeLabel.width = self.width;
        self.lastUpdatedTimeLabel.height = self.height - self.lastUpdatedTimeLabel.originY;
    }
    if (hasGifView) {
        self.gifView.frame = self.bounds;
        if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
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

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    // 在刷新的refreshing状态
    if (self.state == JRefreshStateRefreshing) {
        // sectionheader停留解决
        return;
    }
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.contentInset;
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.contentOffset.y;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    // 如果是向上滚动到看不见头部控件，直接返回
    if (offsetY >= happenOffsetY) {
        return;
    }
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.height;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.height;
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.state == JRefreshStateNormal && offsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = JRefreshStatePulling;
        } else if (self.state == JRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
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

- (void)setState:(JRefreshState)state
{
    JRefreshState oldState = self.state;
    if (state == oldState) {
        return;
    }
    [super setState:state];
    // 根据状态做事情
    if (state == JRefreshStateNormal) {
        if (oldState != JRefreshStateRefreshing) {
            return;
        }
        if (!hasGifView) {
            if (oldState == JRefreshStateRefreshing) {
                self.arrowView.transform = CGAffineTransformIdentity;
                [UIView animateWithDuration:0.4 animations:^{
                    self.loadingView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    // 如果执行完动画发现不是normal状态，就直接返回，进入其他状态
                    if (self.state != JRefreshStateNormal) {
                        return;
                    }
                    self.loadingView.alpha = 1.0;
                    [self.loadingView stopAnimating];
                    self.arrowView.hidden = NO;
                }];
            }else {
                [self.loadingView stopAnimating];
                self.arrowView.hidden = NO;
                [UIView animateWithDuration:0.25 animations:^{
                    self.arrowView.transform = CGAffineTransformIdentity;
                }];
            }
        }
        // 保存刷新时间
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"JRefreshHeaderLastUpdatedTimeKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // 恢复inset和offset
        [UIView animateWithDuration:0.4 animations:^{
            UIEdgeInsets inset = self.scrollView.contentInset;
            inset.top -= self.height;
            self.scrollView.contentInset = inset;
            // 自动调整透明度
            if (self.isAutoChangeAlpha) {
                self.alpha = 0.0;
            }
        } completion:^(BOOL finished) {
            self.pullingPercent = 0.0;
        }];
    } else if (state == JRefreshStateRefreshing) {
        [UIView animateWithDuration:0.25 animations:^{
            // 增加滚动区域
            CGFloat top = self.scrollViewOriginalInset.top + self.height;
            UIEdgeInsets inset = self.scrollView.contentInset;
            inset.top = top;
            self.scrollView.contentInset = inset;
            // 设置滚动位置
            CGPoint offset = self.scrollView.contentOffset;
            offset.y = - top;
            self.scrollView.contentOffset = offset;
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
        if (hasGifView) {
            NSArray *images = self.stateImages[@(state)];
            if (images.count == 0) {
                return;
            }
            [self.gifView stopAnimating];
            if (images.count == 1) { // 单张图片
                self.gifView.image = [images lastObject];
            } else { // 多张图片
                self.gifView.animationImages = images;
                self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
                [self.gifView startAnimating];
            }
        }else {
            self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
            [self.loadingView startAnimating];
            self.arrowView.hidden = YES;
        }
    }else if (state == JRefreshStatePulling) {
        if (hasGifView) {
            NSArray *images = self.stateImages[@(state)];
            if (images.count == 0) {
                return;
            }
            [self.gifView stopAnimating];
            if (images.count == 1) { // 单张图片
                self.gifView.image = [images lastObject];
            } else { // 多张图片
                self.gifView.animationImages = images;
                self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
                [self.gifView startAnimating];
            }
        }else {
            [self.loadingView stopAnimating];
            self.arrowView.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
        }
    }
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
    // 重新设置key（重新显示时间）
    self.lastUpdatedTimeKey = @"JRefreshHeaderLastUpdatedTimeKey";
}

- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey
{
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:lastUpdatedTimeKey];
    // 如果有block
    if (self.lastUpdatedTimeText) {
        self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText(lastUpdatedTime);
        return;
    }
    if (lastUpdatedTime) {
        // 1.获得年月日
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        // 2.格式化日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if ([cmp1 day] == [cmp2 day]) { // 今天
            formatter.dateFormat = @"今天 HH:mm";
        } else if ([cmp1 year] == [cmp2 year]) { // 今年
            formatter.dateFormat = @"MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        // 3.显示日期
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
    } else {
        self.lastUpdatedTimeLabel.text = @"最后更新：无记录";
    }
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    self.loadingView = nil;
    [self setNeedsLayout];
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(JRefreshStateNormal)];
    if (self.state != JRefreshStateNormal || images.count == 0) {
        return;
    }
    // 停止动画
    [self.gifView stopAnimating];
    // 设置当前需要显示的图片
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
}

#pragma mark - 公共方法
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

- (NSDate *)lastUpdatedTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.lastUpdatedTimeKey];
}

- (void)setTitle:(NSString *)title forState:(JRefreshState)state
{
    if (title == nil) {
        return;
    }
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(JRefreshState)state
{
    if (images == nil) {
        return;
    }
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

@end
