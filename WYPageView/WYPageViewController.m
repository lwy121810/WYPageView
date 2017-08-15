//
//  WYPageViewController.m
//  WYPageView
//
//  Created by lwy1218 on 2017/8/14.
//
//

#import "WYPageViewController.h"

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
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"reload" style:UIBarButtonItemStyleDone target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = right;
    
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
- (void)rightAction
{
    
    NSMutableArray *viewCs = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    
    NSInteger count = arc4random() % 8 + 4;
    for (int i = 0; i < count; i++) {
        UIViewController *contentVc = [[UIViewController alloc] init];
        NSString *title = [NSString stringWithFormat:@"标题%d", i];
        [viewCs addObject:contentVc];
        contentVc.view.backgroundColor = [self randomColor];
        [titles addObject:title];
    }
    
    [self.pageView reloadChildrenControllers:viewCs titles:titles];
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
