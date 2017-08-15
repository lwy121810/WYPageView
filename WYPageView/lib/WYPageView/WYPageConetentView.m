//
//  WYPageConetentView.m
//  WYPageController
//
//  Created by lwy1218 on 2017/8/10.
//  Copyright © 2017年 lwy1218. All rights reserved.
//

#import "WYPageConetentView.h"

static NSString *identifier = @"WYNavManagerCell";
@interface WYPageConetentView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic , weak) UICollectionView *collectionView;
@property (nonatomic , weak) UICollectionViewFlowLayout *flowLayout;

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

@end
@implementation WYPageConetentView
- (NSMutableArray *)viewControllers
{
    if (!_viewControllers) {
        NSMutableArray *arr = [NSMutableArray array];
        self.viewControllers = arr;
    }
    return _viewControllers;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
        collectionView.pagingEnabled = YES;
        collectionView.bounces = NO;
        collectionView.contentInset = UIEdgeInsetsZero;
        collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:collectionView];
        self.flowLayout = flowLayout;
        self.collectionView = collectionView;
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
      childrenViewControllers:(NSArray <UIViewController *> *)childrenVcs
             parentController:(UIViewController *)parentViewController
{
    if (self = [super initWithFrame:frame]) {
        self.viewControllers = [childrenVcs mutableCopy];
        self.parentController = parentViewController;
        
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    //1.设置collectionView的frame
    self.collectionView.frame = self.bounds;
    
    //2.设置子控制器
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.parentController) {
            [self.parentController addChildViewController:obj];
        }
    }];
}
#pragma mark - public method
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    _isForbidScrollDelegate = YES;
    [self.collectionView setContentOffset:contentOffset animated:animated];
}

/**
 刷新数据
 
 @param childVcs 子控制器数组
 */
- (void)reloadData:(NSArray *)childVcs
{
    
    [self.viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)obj;
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
        }
    }];
    
    [self.viewControllers removeAllObjects];
    
    [self.viewControllers addObjectsFromArray:childVcs];
    
    [self setupView];
    
    [self.collectionView reloadData];
    
    [self.collectionView setContentOffset:CGPointMake(0, 0)];
}

- (void)dealloc {
    self.parentController = nil;
    NSLog(@"WYPageContentView---销毁");
}

#pragma mark - private
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
    
    CGFloat progress = 0;
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
    
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    BOOL isSlipToRightPage = YES;
    if (_startOffsetX < currentOffsetX) {//左滑
        //0.标记滑动方向
        isSlipToRightPage = YES;
        
        // 1.计算progress floor函数是取整
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        
        // 2.计算sourceIndex
        sourceIndex = (NSInteger)(currentOffsetX / scrollViewW);
        
        // 3.计算targetIndex
        targetIndex = sourceIndex + 1; //因为是左滑 所以target是source ＋ 1
        if (targetIndex >= self.viewControllers.count) {
            targetIndex = self.viewControllers.count - 1;
        }
        // 4.如果完全滑过去
        if (currentOffsetX - _startOffsetX == scrollViewW ){
            progress = 1;
            targetIndex = sourceIndex;
        }
        
    }
    else {//右滑
        //0.标记滑动方向
        isSlipToRightPage = NO;
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
    
    if (_delegate && [_delegate respondsToSelector:@selector(pageContentView:scrollWithProgress:sourceIndex:targetIndex:)]) {
        [_delegate pageContentView:self scrollWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //标记不是点击事件
    _isForbidScrollDelegate = NO;
    
    //标记开始的偏移量
    _startOffsetX = scrollView.contentOffset.x;
}
//滑动停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //1.滑动停止，跟开始滑动的偏移量一致 说明还停留在当前页
    if (_startOffsetX == scrollView.contentOffset.x) return;
    
    NSInteger currentIndex = [self getCurrentIndex:scrollView];
    
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidEndAtIndex:)]) {
        [_delegate scrollViewDidEndAtIndex:currentIndex];
    }
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = self.bounds.size.width;
    CGFloat h = collectionView.bounds.size.height - self.flowLayout.minimumInteritemSpacing - collectionView.contentInset.top - collectionView.contentInset.bottom;
    CGSize size = CGSizeMake(w, h);
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIViewController *subVc = [self getChildrenControllerWithIndex:indexPath.row];
    subVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:subVc.view];
    
    [subVc didMoveToParentViewController:self.parentController];
    return cell;
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
    return [self getCurrentIndex:self.collectionView];
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
