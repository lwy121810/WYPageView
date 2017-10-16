//
//  NavViewController.m
//  WYPageView
//
//  Created by lwy1218 on 2017/9/29.
//

#import "NavViewController.h"
#import "WYPageView.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"
#import "SixViewController.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface NavViewController ()<WYPageConetentViewDelegate, WYPageTitleViewDelegate, WYPageTitleViewDataSource>
@property (nonatomic , strong) WYPageTitleView *titleView;
@property (nonatomic , strong) WYPageConetentView *contentView;
@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupContentView];
    [self setupTitleView];
}
- (void)setupContentView
{
    NSArray *vcs = [self getChildrenVcs];
    CGRect frame = self.view.frame;
    if (self.navigationController) {
        CGFloat y = 64;
        frame.origin.y = y;
    }
    frame.size.height -= frame.origin.y;
    if (@available(iOS 11.0, *)) {
        // 在iOS 11 在‘viewSafeAreaInsetsDidChange’方法里赋值frame
        frame = CGRectZero;
    } else {
        // Fallback on earlier versions
    }
    // 初始化方法一 直接在初始化的时候赋值frame （frame也可以为zero）
//   WYPageConetentView *contentView = [[WYPageConetentView alloc] initWithFrame:frame childrenViewControllers:vcs parentController:self config:_config];
    // 初始化方法二 初始化的时候不赋值frame
    WYPageConetentView *contentView = [[WYPageConetentView alloc] initWithChildrenViewControllers:vcs parentController:self config:_config];
    if (@available(iOS 11.0, *)) {
        
    } else {
        // Fallback on earlier versions
        contentView.frame = frame;
    }
    //代理
    contentView.delegate = self;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}
- (void)setupTitleView
{
    
    CGRect titleFrame = CGRectMake(0, 0, 300, 40);
    
    NSArray *titles = [self getChildrenTitles];
    id<WYPageTitleViewDataSource> dataSource = nil;
    if (_config.indicatorStyle == WYPageTitleIndicatorViewStyleCustom) {
        dataSource = self;
    }
    // 初始化方法一 dataSource:数据源代理 在自定义指示器样式的时候遵守数据源 并实现数据源方法 否则可以为nil
    WYPageTitleView *titleView = [[WYPageTitleView alloc] initWithFrame:titleFrame titles:titles config:_config dataSource:dataSource];
    
    // 初始化方法二 数据源的设置与初始化方法分离 当然 也是只有在自定义指示器view的时候才设置数据源
    //    WYPageTitleView *titleView = [[WYPageTitleView alloc] initWithFrame:titleFrame titles:titles config:_config];
    //    titleView.dataSource = self;
    
    // 当然 也可以在初始化的时候frame传CGRectZero 然后在合适的时候赋值frame
//    titleView.frame = titleFrame;
    
    self.navigationItem.titleView = titleView;
    // 代理
    titleView.delegate = self;
    self.titleView = titleView;
    // 可以通过titleView获取到指示器view 从而可以自由的更改指示器view的颜色、圆角等等属性
//    titleView.indicatorView.backgroundColor = [UIColor greenColor];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
// 在iOS 11中 在该方法中可以获取和监测到view的safeAreaInsets变化 所以在这里赋值frame
- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets safe = self.view.safeAreaInsets;

    CGRect frame = self.view.frame;
    frame.origin.x = safe.left;
    frame.origin.y = safe.top;
    frame.size.width -= safe.left + safe.right;
    frame.size.height -= safe.top + safe.bottom;
    self.contentView.frame = frame;
}
#pragma mark - WYPageTitleViewDataSource
// 实现该方法 自定义指示器样式
- (UIView *)customIndicatorViewForPageTitleView:(WYPageTitleView *)pageTitleView
{
    UIView *customView = [[UIView alloc] init];
    switch (self.customStyle) {
        case WYCustomIndicatorViewStyle1://遮罩模式
        {
            // 这里之所以设置宽度为0 是因为设置了config的指示器宽度等于按钮的宽度 如果没有设置的话 可以在这里赋值宽度 如果为宽度<=0的话 会按照config里的itemW赋值
            customView.frame = CGRectMake(0, 0, 0, 30);
            customView.backgroundColor = [UIColor lightGrayColor];
            customView.layer.cornerRadius = 4;
        }
            break;
            
        case WYCustomIndicatorViewStyle2:// 小红点模式
        {
            customView.frame = CGRectMake(0, 0, 8, 8);
            customView.backgroundColor = [UIColor redColor];
            customView.layer.cornerRadius = 4;
        }
            break;
            
        default:
            break;
    }
    return customView;
}

#pragma mark - WYPageTitleViewDelegate
- (void)pageTitleView:(WYPageTitleView *)pageTitleView
     selectdIndexItem:(NSInteger)selectdIndex
             oldIndex:(NSInteger)oldIndex
{
    int difference = abs((int)selectdIndex - (int)oldIndex);
    BOOL animated = difference <= 1;//点击不相邻的按钮的话设置为没有动画
    [self.contentView setContentOffsetWithCurrentIndex:selectdIndex animated:animated];
}
#pragma mark - WYPageConetentViewDelegate
- (void)pageContentView:(WYPageConetentView *)pageContentView
     scrollWithProgress:(double)progress
            sourceIndex:(NSInteger)sourceIndex
            targetIndex:(NSInteger)targetIndex
{
    [self.titleView setTitleWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}

/**
 拖拽结束的代理
 
 @param currentIndex 当前停留的页面下标
 */
- (void)scrollViewDidEndDeceleratingAtIndex:(NSInteger)currentIndex
{
    [self.titleView setHeaderContentOffsetWithCurrentIndex:currentIndex];
}

- (NSArray *)getChildrenTitles
{
    return @[@"头条", @"人走茶就凉了",@"娱乐",@"中国足球",@"网易号",@"轻松一刻",@"态度公开课",@"易城live"];
}

- (NSArray *)getChildrenVcs
{
    OneViewController *vc1 = [OneViewController new];
    vc1.title = @"头条";
    
    UIViewController *vc2 = [UIViewController new];
    vc2.view.backgroundColor = [UIColor greenColor];
   
    
    UIViewController *vc3 = [UIViewController new];
    vc3.view.backgroundColor = [UIColor yellowColor];
   
    
    UIViewController *vc4 = [UIViewController new];
    vc4.view.backgroundColor = [UIColor brownColor];
   
    //
    UIViewController *vc5 = [UIViewController new];
    vc5.view.backgroundColor = [UIColor lightGrayColor];
   
    //
    UIViewController *vc6 = [UIViewController new];
    vc6.view.backgroundColor = [UIColor orangeColor];
   
    
    UIViewController *vc7 = [UIViewController new];
    vc7.view.backgroundColor = [UIColor cyanColor];
    
    
    UIViewController *vc8 = [UIViewController new];
    vc8.view.backgroundColor = [UIColor blueColor];
    
    NSArray *childVcs = [NSArray arrayWithObjects:vc1, vc2, vc3, vc4, vc5, vc6, vc7,vc8,nil];
    return childVcs;
}
@end
