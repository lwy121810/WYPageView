//
//  WYPageViewController.m
//  WYPageView
//
//  Created by lwy1218 on 2017/8/14.
//
//

#import "WYPageViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"
#import "SixViewController.h"

@interface WYPageViewController ()

@property (nonatomic , strong) WYPageView *pageView;
@end

@implementation WYPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *vcs = [self setupChildVcAndTitle];
    CGRect frame = self.view.frame;
    CGFloat y = 0;
    if (self.navigationController) {
        y = 64;
    }
    frame.origin.y = y;
    
    
    
    WYPageView *view = [[WYPageView alloc] initWithFrame:frame childVcs:vcs parentViewController:self pageConfig:_config];
    [self.view addSubview:view];
    self.pageView = view;
    
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithTitle:@"随机" style:UIBarButtonItemStyleDone target:self action:@selector(randomReloadAction)];
    
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithTitle:@"其他" style:UIBarButtonItemStyleDone target:self action:@selector(otherAction)];
    
    self.navigationItem.rightBarButtonItems = @[right1, right2];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}
- (void)tap
{
    if (!self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)dealloc
{
    NSLog(@"dealloc------");
}
- (void)otherAction
{
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
    [childs addObject:vc4];
    
    FiveViewController *vc5 = [[FiveViewController alloc] init];
    vc5.title = @"vc5";
    [childs addObject:vc5];
    
    SixViewController *vc6 = [[SixViewController alloc] init];
    vc6.title = @"vc6";
    [childs addObject:vc6];
    
    [self.pageView reloadChildrenControllers:childs];
}
- (void)randomReloadAction
{
    NSMutableArray *vcs = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    
    NSInteger count = arc4random() % 8 + 3;
    for (int i = 0; i < count; i++) {
        UIViewController *contentVc = [[UIViewController alloc] init];
        NSString *title = [NSString stringWithFormat:@"标题%d", i];
        [vcs addObject:contentVc];
        contentVc.view.backgroundColor = [self randomColor];
        [titles addObject:title];
    }
    
    [self.pageView reloadChildrenControllers:vcs titles:titles];
}

- (UIColor *)randomColor {
    
    return [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0];
    
}

- (NSArray *)setupChildVcAndTitle {
    
    UIViewController *vc1 = [UIViewController new];
    vc1.view.backgroundColor = [UIColor redColor];
    vc1.title = @"头条";
    
    UIViewController *vc2 = [UIViewController new];
    vc2.view.backgroundColor = [UIColor greenColor];
    vc2.title = @"视频";
    
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

@end
