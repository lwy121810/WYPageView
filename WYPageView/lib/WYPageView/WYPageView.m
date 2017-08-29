//
//  WYPageView.m
//  WYPageController
//
//  Created by lwy1218 on 2017/8/10.
//  Copyright © 2017年 lwy1218. All rights reserved.
//

#import "WYPageView.h"
#import "WYPageConetentView.h"
#import "WYPageTitleView.h"

@interface WYPageView ()<WYPageTitleViewDelegate, WYPageConetentViewDelegate>

@property (weak, nonatomic) WYPageTitleView *titleView;
@property (weak, nonatomic) WYPageConetentView *contentView;

@property (weak, nonatomic) UIViewController *parentViewController;
@property (strong, nonatomic) NSArray *childVcs;
@property (strong, nonatomic) NSArray *titlesArray;

@property (nonatomic , strong) WYPageConfig *config;

@end
@implementation WYPageView
- (WYPageTitleView *)titleView
{
    if (!_titleView) {
        CGFloat headerH = self.config.titleViewHeight;
        CGRect headerFrame = CGRectMake(0, 0, self.bounds.size.width, headerH);
        WYPageTitleView *headerView = [[WYPageTitleView alloc] initWithFrame:headerFrame titles:self.titlesArray config:self.config];
        
        [self addSubview:headerView];
        headerView.delegate = self;
        
        self.titleView = headerView;
    }
    return _titleView;
}
- (WYPageConetentView *)contentView
{
    if (!_contentView) {
        CGFloat contentY = CGRectGetMaxY(self.titleView.frame);
        CGFloat contentH = self.frame.size.height - contentY;
        CGRect frame = CGRectMake(0, contentY, self.frame.size.width, contentH);
        
        WYPageConetentView *contentView = [[WYPageConetentView alloc] initWithFrame:frame childrenViewControllers:self.childVcs parentController:self.parentViewController config:self.config];
        
        [self addSubview:contentView];
        contentView.delegate = self;
        self.contentView = contentView;
    }
    return _contentView;
}
- (instancetype)initWithFrame:(CGRect)frame
                     childVcs:(NSArray *)childVcs
         parentViewController:(UIViewController *)parentViewController
{
    if (self = [super initWithFrame:frame]) {
        [self setupWithChildVcs:childVcs titles:nil parentViewController:parentViewController pageConfig:nil];
    }
    return self;
}
- (void)dealloc {
    WYLog(@"WYPageView--销毁");
}
- (instancetype)initWithFrame:(CGRect)frame
                     childVcs:(NSArray *)childVcs
         parentViewController:(UIViewController *)parentViewController
                   pageConfig:(WYPageConfig *)config
{
    if (self = [super initWithFrame:frame]) {
        [self setupWithChildVcs:childVcs titles:nil parentViewController:parentViewController pageConfig:config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                     childVcs:(NSArray *)childVcs
                       titles:(NSArray *)titles
         parentViewController:(UIViewController *)parentViewController
                   pageConfig:(WYPageConfig *)config
{
    if (self = [super initWithFrame:frame]) {
        [self setupWithChildVcs:childVcs titles:titles parentViewController:parentViewController pageConfig:config];
    }
    return self;
}

/**
 初始化 默认配置
 
 @param frame frame
 @param childVcs 子控制器数组
 @param titles  标题数组
 @param parentViewController 父控制器
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                     childVcs:(NSArray *)childVcs
                       titles:(NSArray *)titles
         parentViewController:(UIViewController *)parentViewController
{
    if (self = [super initWithFrame:frame]) {
        [self setupWithChildVcs:childVcs titles:titles parentViewController:parentViewController pageConfig:nil];
    }
    return self;
}


/**
 获取子控制器
 
 @param index index
 @return 子控制器
 */
- (UIViewController *)getChildrenControllerWithIndex:(NSInteger)index
{
    return [self.contentView getChildrenControllerWithIndex:index];
}

/**
 获取控制器所在的下标

 @param vc 控制器
 @return 下标
 */
- (NSInteger)getIndexWithChildrenController:(UIViewController *)vc
{
    if ([self.childVcs containsObject:vc]) {
        return [self.childVcs indexOfObject:vc];
    }
    return 0;
}

/**
 获取当前控制器所在下标
 
 @return index
 */
- (NSInteger)getCurrentControllerIndex
{
    return  [self.contentView getCurrentControllerIndex];
}


/**
 获取当前的控制器
 
 @return vc
 */
- (UIViewController *)getCurrentController
{
    return  [self.contentView getCurrentController];
}

/**
 刷新页面数据 子控制器需要有标题

 @param childVcs 子控制器
 */
- (void)reloadChildrenControllers:(NSArray *)childVcs
{
    if (childVcs == nil || childVcs.count == 0) return;
    self.childVcs = childVcs;
    
    [self setupDataWithHaveTitles:NO];
    
    [self.titleView reloadTitles:self.titlesArray];
    [self.contentView reloadData:self.childVcs];
}

/**
 刷新页面数据 子控制器和标题数组分开传递

 @param childVcs 子控制器
 @param titles 标题数组
 */
- (void)reloadChildrenControllers:(NSArray *)childVcs titles:(NSArray *)titles
{
    if (childVcs == nil || childVcs.count == 0) return;
    if (titles == nil || titles.count == 0) return;
#ifdef WYDEBUG
    if (childVcs.count != titles.count) {
        NSAssert(NO, @"WYPageView==========>>>>>>>>标题数量与子控制器数量不一致");
    }
#endif
    
    self.childVcs = childVcs;
    self.titlesArray = titles;
    
    [self.titleView reloadTitles:titles];
    [self.contentView reloadData:self.childVcs];
}

- (void)setupWithChildVcs:(NSArray *)childVcs
                   titles:(NSArray *)titles
     parentViewController:(UIViewController *)parentViewController
               pageConfig:(WYPageConfig *)config
{
    self.childVcs = childVcs;
    self.parentViewController = parentViewController;
    if (parentViewController.automaticallyAdjustsScrollViewInsets) {
        parentViewController.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (config == nil) {
        config = [[WYPageConfig alloc] init];
    }
    self.config = config;
    
    BOOL haveTitle = NO;
    if (titles) {
        haveTitle = YES;
        self.titlesArray = titles;
    }
    
    [self setupDataWithHaveTitles:haveTitle];
    [self setupView];
}
- (void)setupDataWithHaveTitles:(BOOL)haveTitles {
    NSMutableArray *tempTitles = [NSMutableArray array];
    for (UIViewController *childVc in self.childVcs) {
#ifdef WYDEBUG
        if ([childVc isKindOfClass:[UINavigationController class]]) {
            NSAssert(NO, @"WYPageView==========>>>>>>>>不要添加含有导航栏的子控制器！");
        }
        if (haveTitles == NO) {//标题与vc一起传进来的 获取vc的标题
            NSAssert(childVc.title, @"WYPageView==========>>>>>>>>子控制器的title没有正确设置!!");
        }
#endif
        
        if (haveTitles == NO) {//标题与vc一起传进来的 获取vc的标题
            if (childVc.title) {
                [tempTitles addObject:childVc.title];
            }
        }
    }
    
    if (haveTitles == NO) {//标题与vc一起传进来的 获取vc的标题
        self.titlesArray = [NSArray arrayWithArray:tempTitles];
    }
  
#ifdef WYDEBUG
    NSAssert(self.titlesArray.count == self.childVcs.count, @"WYPageView==========>>>>>>>>标题数量与子控制器数量不一致");
#endif
}
- (void)setupView
{
    [self titleView];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - WYPageTitleViewDelegate
- (void)pageTitleView:(WYPageTitleView *)pageTitleView selectdIndexItem:(NSInteger)selectdIndex oldIndex:(NSInteger)oldIndex
{
    BOOL animated = self.config.contentAnimationEnable;
    int difference = abs((int)selectdIndex - (int)oldIndex);
    if (animated) {
        //当点击的item不相邻的时候 不显示滚动效果
        animated = difference <= 1;
    }
    [self.contentView setContentOffsetWithCurrentIndex:selectdIndex animated:animated];
}

#pragma mark - WYPageConetentViewDelegate
- (void)pageContentView:(WYPageConetentView *)pageContentView scrollWithProgress:(double)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex
{
    [self.titleView setTitleWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}
- (void)scrollViewDidEndAtIndex:(NSInteger)currentIndex
{
    [self.titleView setHeaderContentOffsetWithCurrentIndex:currentIndex];
}
@end
