//
//  DemoViewController.m
//  WYPageView
//
//  Created by lwy1218 on 2017/9/7.
//
//
/*
 ********************************************************
 *
 * GitHub: https://github.com/lwy121810
 * 简书地址: http://www.jianshu.com/u/308baa12e8b5
 *
 ********************************************************
 */
#import "DemoViewController.h"
#import "WYPageView.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"
#import "SixViewController.h"

#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})


@interface DemoViewController ()<WYPageTitleViewDataSource>
 
@property (nonatomic , strong) WYPageView *pageView;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];

    NSArray *vcs = [self setupChildVc];
    
    CGRect frame = self.view.frame;
    if (self.navigationController) {
        CGFloat y = 64;
        frame.origin.y = y;
    }
    frame.size.height -= frame.origin.y;
    //初始化1 给一个空的frame
    //WYPageView *page = [[WYPageView alloc] initWithFrame:CGRectZero childVcs:vcs parentViewController:self pageConfig:_config];
    
    //初始化2 初始化的时候就赋值frame
    //WYPageView *page = [[WYPageView alloc] initWithFrame:frame childVcs:vcs parentViewController:self pageConfig:_config];
    //初始化3 没有frame的初始化方法
    WYPageView *page = [[WYPageView alloc] initWithChildVcs:vcs parentViewController:self pageConfig:_config];
    
    [self.view addSubview:page];
    
    self.pageView = page;
    if (@available(iOS 11.0, *)) {
        // 在‘viewSafeAreaInsetsDidChange’方法里根据‘safeAreaInsets’赋值frame
    } else {
        // Fallback on earlier versions
        self.pageView.frame = frame;
    }
    
    [self setupBarItems];
}

//适配iOS 11
//- (void)viewSafeAreaInsetsDidChange在UIViewController中第一次调用的时间是在- (void)viewWillAppear:(BOOL)animated调用之后, 在- (void)viewWillLayoutSubviews调用之前.
// 旋转屏幕之后也会调用该方法
- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    [self setupFullFrameWithView:self.pageView];
}
- (void)setupBarItems
{
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithTitle:@"随机数量" style:UIBarButtonItemStyleDone target:self action:@selector(randomReloadAction)];
    
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithTitle:@"其他" style:UIBarButtonItemStyleDone target:self action:@selector(otherAction)];
    
    
    //    UIBarButtonItem *right3 = [[UIBarButtonItem alloc] initWithTitle:@"changeFrame" style:UIBarButtonItemStyleDone target:self action:@selector(changeFrame)];
    
    self.navigationItem.rightBarButtonItems = @[right1, right2];
}
- (void)changeFrame
{
    CGRect frame = self.pageView.frame;
    frame.size.height = 400;
    self.pageView.frame = frame;
}


- (NSArray *)setupChildVc {
    
    
    NSMutableArray *childs = @[].mutableCopy;
    OneViewController *vc1 = [[OneViewController alloc] init];
    vc1.title = @"vc1";
    [childs addObject:vc1];
    
    TwoViewController *vc2 = [[TwoViewController alloc] init];
    vc2.title = @"vc2";
    [childs addObject:vc2];
    
    ThreeViewController *vc3 = [[ThreeViewController alloc] init];
    vc3.title = @"vc3";
    [childs addObject:vc3];
    
    FourViewController *vc4 = [[FourViewController alloc] init];
    vc4.title = @"vc4";
    
    __weak typeof(self)weakSelf = self;
    vc4.fourVcSelectedIndex = ^(NSInteger index) {
        weakSelf.pageView.currentSelectedIndex = index;
    };
    [childs addObject:vc4];
    
    FiveViewController *vc5 = [[FiveViewController alloc] init];
    vc5.title = @"vc5";
    [childs addObject:vc5];
    
    SixViewController *vc6 = [[SixViewController alloc] init];
    vc6.title = @"vc6";
    [childs addObject:vc6];
    
    return childs;
}

#pragma mark - WYPageTitleViewDataSource
// 实现该方法 自定义指示器样式
- (UIView *)customIndicatorViewForPageTitleView:(WYPageTitleView *)pageTitleView
{
    UIView *customView = [[UIView alloc] init];
    switch (self.customStyle) {
        case WYCustomIndicatorViewStyle1://遮罩模式
        {
         // 这里之所以设置宽度为0 是因为设置了config的指示器宽度等于按钮的宽度 如果没有设置的话 可以在这里赋值宽度 如果为宽度<=0的话 会按照config里的itemW 赋值
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

- (void)otherAction
{
    NSArray *childVcs = [self getChildrenVcs];
    
    [self.pageView reloadChildrenControllers:childVcs];
}
- (NSArray *)getChildrenVcs
{
    UIViewController *vc1 = [UIViewController new];
    vc1.view.backgroundColor = [UIColor redColor];
    vc1.title = @"头条";
    
    UIViewController *vc2 = [UIViewController new];
    vc2.view.backgroundColor = [UIColor greenColor];
    vc2.title = @"人走茶就凉了";
    
    UIViewController *vc3 = [UIViewController new];
    vc3.view.backgroundColor = [UIColor yellowColor];
    vc3.title = @"娱乐";
    
    UIViewController *vc4 = [UIViewController new];
    vc4.view.backgroundColor = [UIColor brownColor];
    vc4.title = @"中国足球";
    //
    UIViewController *vc5 = [UIViewController new];
    vc5.view.backgroundColor = [UIColor lightGrayColor];
    vc5.title = @"网易号";
    //
    UIViewController *vc6 = [UIViewController new];
    vc6.view.backgroundColor = [UIColor orangeColor];
    vc6.title = @"轻松一刻";
    
    UIViewController *vc7 = [UIViewController new];
    vc7.view.backgroundColor = [UIColor cyanColor];
    vc7.title = @"态度公开课";
    
    UIViewController *vc8 = [UIViewController new];
    vc8.view.backgroundColor = [UIColor blueColor];
    vc8.title = @"易城live";
    
    NSArray *childVcs = [NSArray arrayWithObjects:vc1, vc2, vc3, vc4, vc5, vc6, vc7,vc8,nil];
    return childVcs;
}
#pragma mark - 设置随机数量的vc
- (void)randomReloadAction
{
    NSMutableArray *vcs = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    
    NSInteger count = arc4random() % 8 + 5;

    for (int i = 0; i < count; i++) {
        UIViewController *contentVc = [[UIViewController alloc] init];
        NSString *title = [NSString stringWithFormat:@"标题%d", i];
        [vcs addObject:contentVc];
        contentVc.view.backgroundColor = [self randomColor];
        [titles addObject:title];
    }
    // 在relaod之前 可以通过获取到config 修改对应的值 来重新设置基本信息
//    WYPageConfig *config = self.pageView.config;
//    config.titleMargin = 20;
    [self.pageView reloadChildrenControllers:vcs titles:titles];
}


- (UIColor *)randomColor {
    
    return [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0];
    
}

- (NSArray *)setupChildVcAndTitle {
    
    NSMutableArray *childs = @[].mutableCopy;
    OneViewController *vc1 = [[OneViewController alloc] init];
    //    vc1.title = @"头条";
    vc1.title = @"vc1";
    [childs addObject:vc1];
    
    TwoViewController *vc2 = [[TwoViewController alloc] init];
    //    vc2.title = @"人走茶就凉了";
    vc2.title = @"vc2";
    [childs addObject:vc2];
    
    ThreeViewController *vc3 = [[ThreeViewController alloc] init];
    vc3.title = @"vc3";
    [childs addObject:vc3];
    
    FourViewController *vc4 = [[FourViewController alloc] init];
    vc4.title = @"vc4";
    
    __weak typeof(self)weakSelf = self;
    vc4.fourVcSelectedIndex = ^(NSInteger index) {
        weakSelf.pageView.currentSelectedIndex = index;
    };
    
    [childs addObject:vc4];
    
    FiveViewController *vc5 = [[FiveViewController alloc] init];
    vc5.title = @"vc5";
    [childs addObject:vc5];
    
    SixViewController *vc6 = [[SixViewController alloc] init];
    vc6.title = @"vc6";
    [childs addObject:vc6];
    
    
    return childs;
}


@end

