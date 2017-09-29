//
//  WYPageConetentView.m
//  WYPageController
//
//  Created by lwy1218 on 2017/8/10.
//  Copyright © 2017年 lwy1218. All rights reserved.
//

#import "WYPageConetentView.h"
#import "WYPageConfig.h"

#define kWYMainViewTag 1000
@interface WYPageConetentView ()<UIScrollViewDelegate>
@property (nonatomic , strong) NSMutableDictionary<NSNumber*,UIViewController *> *displayChildVcData;
@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , assign) NSInteger currentIndex;
@property (nonatomic , strong) NSMutableArray *viewControllers;
@property (nonatomic , weak) UIViewController *parentController;
/**
 标记是不是点击事件
 */
@property (nonatomic , assign) BOOL isForbidScrollDelegate;

/**
 开始的偏移量
 */
@property (nonatomic , assign) CGFloat startOffsetX;


@property (nonatomic , strong) WYPageConfig *config;

@end
@implementation WYPageConetentView
- (NSMutableDictionary<NSNumber *,UIViewController *> *)displayChildVcData
{
    if (!_displayChildVcData) {
        _displayChildVcData = [NSMutableDictionary dictionary];
    }
    return _displayChildVcData;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self addSubview:scrollView];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.tag = kWYMainViewTag;
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (NSMutableArray *)viewControllers
{
    if (!_viewControllers) {
        NSMutableArray *arr = [NSMutableArray array];
        self.viewControllers = arr;
    }
    return _viewControllers;
}

/**
 初始化

 @param frame frame 可以为zero 在后续某个时间再赋值
 @param childrenVcs 子控制器数组
 @param parentViewController 父控制器
 @param config 配置信息 可为nil
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
      childrenViewControllers:(NSArray <UIViewController *> *)childrenVcs
             parentController:(UIViewController *)parentViewController
                       config:(WYPageConfig *)config
{
    if (self = [super initWithFrame:frame]) {
        [self setupInitDataWithChildrenVcs:childrenVcs parentController:parentViewController config:config];
    }
    return self;
}

/**
 初始化

 @param childrenVcs 子控制器数组
 @param parentViewController 父控制器
 @param config 配置信息 可以为nil
 @return self
 */
- (instancetype)initWithChildrenViewControllers:(NSArray <UIViewController *>*)childrenVcs
                               parentController:(UIViewController *)parentViewController
                                         config:(WYPageConfig *)config
{
    if (self = [super init]) {
        [self setupInitDataWithChildrenVcs:childrenVcs parentController:parentViewController config:config];
    }
    return self;
}
- (void)setupInitDataWithChildrenVcs:(NSArray *)childrenVcs
                    parentController:(UIViewController *)parentViewController
                              config:(WYPageConfig *)config
{
    self.viewControllers = [childrenVcs mutableCopy];
    self.parentController = parentViewController;
    if (config == nil) {
        config = [[WYPageConfig alloc] init];
    }
    if (parentViewController.automaticallyAdjustsScrollViewInsets) {
        parentViewController.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (childrenVcs == nil || childrenVcs.count == 0) {
        return;
    }
    self.config = config;
    self.currentIndex = self.config.defaultSelectedIndex;
    [self setupView];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    if (_currentIndex < 0) {
        _currentIndex = 0;
    }
    
    if (_currentIndex > self.viewControllers.count - 1) {
        _currentIndex = self.viewControllers.count - 1;
    }
}

- (void)setupView
{
    self.scrollView.frame = self.bounds;

    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    CGFloat contentSize = self.viewControllers.count * self.scrollView.frame.size.width;
    
    self.scrollView.contentSize = CGSizeMake(contentSize, 0);
    
    self.scrollView.scrollEnabled = self.config.contentScrollEnabled;
    
    CGFloat offset = _currentIndex * CGRectGetWidth(self.scrollView.frame);
    
    //手动设置contentOffset会出发其代理方法 会导致手动设置index不准确 应该禁止其代理方法实现
    _isForbidScrollDelegate = YES;
    self.scrollView.contentOffset = CGPointMake(offset, 0);
    
    UIViewController *vc = [self getChildrenControllerWithIndex:_currentIndex];

    [self addChildViewController:vc atIndex:_currentIndex];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
 
    [self resetLayout];
}
- (void)resetLayout
{
    self.scrollView.frame = self.bounds;
    
    CGFloat contentSize = self.viewControllers.count * self.scrollView.frame.size.width;
    
    self.scrollView.contentSize = CGSizeMake(contentSize, 0);
    
    CGFloat offset = _currentIndex * CGRectGetWidth(self.scrollView.frame);
    
    //手动设置contentOffset会出发其代理方法 会导致手动设置index不准确 应该禁止其代理方法实现
    self.scrollView.contentOffset = CGPointMake(offset, 0);
    
    //获取到当前的控制器 调整控制器view的frame
    UIViewController *childController = [self getCurrentController];
    CGRect frame = self.scrollView.bounds;
    frame.origin.x = _currentIndex * self.scrollView.frame.size.width;
    childController.view.frame = frame;
}

/**
 移除控制器，且从display中移除
 
 @param viewController 子控制器
 @param index 下标
 */
- (void)removeChildViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    if (viewController == nil) return;
    [viewController.view removeFromSuperview];
    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
    [self.displayChildVcData removeObjectForKey:@(index)];
}

#pragma mark - public method
- (void)setContentOffsetWithCurrentIndex:(NSInteger)index animated:(BOOL)animated
{
    if (_currentIndex == index) return;
    
    _isForbidScrollDelegate = YES;
    
    CGFloat offset = index * self.scrollView.frame.size.width;
    
    [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:animated];
    
    UIViewController *subVc = [self getChildrenControllerWithIndex:index];
    
    [self addChildViewController:subVc atIndex:index];
    
    if (animated) return;
    // 没有动画
    // 移除上一个控制器
    UIViewController *currentViewController = self.displayChildVcData[@(_currentIndex)];
    if (currentViewController) {
        [self removeChildViewController:currentViewController atIndex:_currentIndex];
    }
    
    //标记当前的下标
    _currentIndex = index;
}

/**
 子控制器从父控制器移除
 
 @param childController 子控制器
 */
- (void)childControllerRemoveFromParentViewController:(UIViewController *)childController
{
    if (childController.isViewLoaded) {
        [childController.view removeFromSuperview];
        [childController willMoveToParentViewController:nil];
        [childController removeFromParentViewController];
    }
}
- (void)addChildControllerAtIndex:(NSInteger)index
{
    UIViewController *vc = [self getChildrenControllerWithIndex:index];
    [self addChildViewController:vc atIndex:index];
}
/**
 添加子控制器
 
 @param childController 子控制器
 @param index 下标
 */
- (void)addChildViewController:(UIViewController *)childController atIndex:(NSInteger)index
{
    if (self.parentController == nil) return;
    if (childController == nil) return;
    
    [self.parentController addChildViewController:childController];
    
    CGRect frame = self.scrollView.bounds;
    frame.origin.x = index * self.scrollView.frame.size.width;
    childController.view.frame = frame;
    
    [childController didMoveToParentViewController:self.parentController];
    [self.scrollView addSubview:childController.view];
    
    [self.displayChildVcData setObject:childController forKey:[NSNumber numberWithInteger:index]];
}

/**
 刷新数据
 
 @param childVcs 子控制器数组
 */
- (void)reloadData:(NSArray *)childVcs
{
    
    [self.viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIViewController class]]) {
            [self childControllerRemoveFromParentViewController:obj];
        }
    }];
    
    [self.displayChildVcData removeAllObjects];
    
    [self.viewControllers removeAllObjects];
    
    [self.viewControllers addObjectsFromArray:childVcs];
    
    [self removeAllSubViewsWithSuperView:self.scrollView];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    
    _currentIndex = 0;
    
    [self setupView];
}
- (void)removeAllSubViewsWithSuperView:(UIView *)superView
{
    if (superView == nil || superView.subviews.count == 0) return;
    
    [superView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
- (void)dealloc {
    WYLog(@"WYPageContentView ---> dealloc  销毁");
}

#pragma mark - private

/**
 获取当前下标
 
 @param scrollView scrollView
 @return index
 */
- (NSInteger)getCurrentIndex:(UIScrollView *)scrollView
{
    if (scrollView.frame.size.width == 0 || scrollView.frame.size.height == 0) return 0;
    
    NSInteger index = 0;
    
    index = (scrollView.contentOffset.x + scrollView.frame.size.width * 0.5) / scrollView.frame.size.width;
    
    return MAX(0, index);
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //0.判断是不是点击事件
    if (_isForbidScrollDelegate) return;
    
    if (scrollView.tag != kWYMainViewTag) return;
    
    CGFloat progress = 0;
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
    
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    if (_startOffsetX < currentOffsetX) {//左滑
        
        // 1.计算progress floor函数是取整
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        
        // 2.计算sourceIndex
        sourceIndex = (NSInteger)(currentOffsetX / scrollViewW);
        
        // 3.计算targetIndex
        targetIndex = sourceIndex + 1; //因为是左滑 所以target是source ＋ 1
        if (targetIndex >= self.viewControllers.count) {
            targetIndex = self.viewControllers.count - 1;
            progress = 1;
        }
        // 4.如果完全滑过去
        if (currentOffsetX - _startOffsetX == scrollViewW ){
            progress = 1;
            targetIndex = sourceIndex;
        }
    }
    else {//右滑
        // 1.计算progress
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        
        // 2.计算targetIndex
        targetIndex = (NSInteger)(currentOffsetX / scrollViewW);
        
        // 3.计算sourceIndex
        sourceIndex = targetIndex + 1;//因为这里是右滑 target比source小
        if (sourceIndex >= self.viewControllers.count) {
            sourceIndex = self.viewControllers.count - 1;
        }
    }
    
    [self fixChildrenViewControllerWithSourceIndex:sourceIndex targetIndex:targetIndex];
    
    if (_delegate && [_delegate respondsToSelector:@selector(pageContentView:scrollWithProgress:sourceIndex:targetIndex:)]) {
        [_delegate pageContentView:self scrollWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
}
- (void)fixChildrenViewControllerWithSourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex
{
    if (_currentIndex == targetIndex) return;
    _currentIndex = targetIndex;
    UIViewController *targetController = [self getChildrenControllerWithIndex:targetIndex];
    [self addChildViewController:targetController atIndex:targetIndex];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //标记不是点击事件
    _isForbidScrollDelegate = NO;
    _currentIndex = [self getCurrentIndex:scrollView];
    //标记开始的偏移量
    _startOffsetX = scrollView.contentOffset.x;
}
//滑动停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //1.获取当前下标
    NSInteger currentIndex = [self getCurrentIndex:scrollView];
    
    //2.移除其他vc
    NSDictionary *childData = self.displayChildVcData;
    BOOL contain = [[childData allKeys] containsObject:@(currentIndex)];
    
    if (contain) {
        [childData enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIViewController * _Nonnull obj, BOOL * _Nonnull stop) {
            if (![key isEqual:@(currentIndex)]) {
                [self removeChildViewController:obj atIndex:[key integerValue]];
            }
        }];
    }
    else {
        [childData enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIViewController * _Nonnull obj, BOOL * _Nonnull stop) {
            [self removeChildViewController:obj atIndex:[key integerValue]];
        }];
        
        [self addChildControllerAtIndex:currentIndex];
    }
 
    
    //3.滑动停止，跟开始滑动的偏移量一致 说明还停留在当前页
    if (_startOffsetX == scrollView.contentOffset.x) return;
    
    //4.代理
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidEndDeceleratingAtIndex:)]) {
        [_delegate scrollViewDidEndDeceleratingAtIndex:currentIndex];
    }
}
#pragma mark - scrollView动画结束之后 
//setContentOffset:animated: 方法animated为YES时会调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView.tag != kWYMainViewTag) return;
    //点击标题 scrollView动画结束之后 移除上一个控制器
    UIViewController *currentViewController = self.displayChildVcData[@(_currentIndex)];
    if (currentViewController) {
        [self removeChildViewController:currentViewController atIndex:_currentIndex];
    }
    NSInteger index = [self getCurrentIndex:scrollView];
    //标记当前的下标
    _currentIndex = index;
}

/**
 获取子控制器
 
 @param index index
 @return 子控制器
 */
- (UIViewController *)getChildrenControllerWithIndex:(NSInteger)index
{
    if (self.viewControllers == nil || self.viewControllers.count == 0) return nil;
    
    if (index > self.viewControllers.count - 1 || index < 0) return nil;
    
    UIViewController *subVc = self.viewControllers[index];
    
    return subVc;
}

/**
 获取当前控制器所在下标
 
 @return index
 */
- (NSInteger)getCurrentControllerIndex
{
    return [self getCurrentIndex:self.scrollView];
}

/**
 获取当前的控制器
 
 @return vc
 */
- (UIViewController *)getCurrentController
{
    NSInteger index = [self getCurrentControllerIndex];
    return [self getChildrenControllerWithIndex:index];
}

@end
