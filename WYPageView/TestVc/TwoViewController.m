//
//  TwoViewController.m
//  WYPageController
//
//  Created by lwy1218 on 2017/8/17.
//  Copyright © 2017年 eastraycloud. All rights reserved.
//

#import "TwoViewController.h"
#import "WYPageView.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"
#import "SixViewController.h"

@interface TwoViewController ()

@property (nonatomic , strong) WYPageView *pageView;
@end

@implementation TwoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"viewDidLoad >>>>>>>>>>>>>>>>>> %@", NSStringFromClass([self class]));
    
    NSArray *vcs = [self setupChildVcAndTitle];
    
    CGRect frame = self.view.bounds;
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
    WYPageView *page = [[WYPageView alloc] initWithChildVcs:vcs parentViewController:self pageConfig:nil];
    
    [self.view addSubview:page];
    
    self.pageView = page;
    
    // viewDidLoad里没有赋值frame是因为在viewDidLoad里有可能view没有加载完成 获取不到正确的frame 可以在viewWillAppear或者viewDidLayoutSubviews里赋值frame
}
// 赋值frame 没有在viewWillAppear赋值是为了适配屏幕旋转 当屏幕旋转 self.view的frame放生变化时会调用该方法
- (void)viewDidLayoutSubviews
{
    [self setupFullFrameWithView:self.pageView];
}
- (NSArray *)setupChildVcAndTitle {
    
    NSMutableArray *childs = @[].mutableCopy;
    OneViewController *vc1 = [[OneViewController alloc] init];
    //    vc1.title = @"头条";
    vc1.title = @"vc1";
    [childs addObject:vc1];
    vc1.view.backgroundColor = [UIColor purpleColor];
    
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

- (void)dealloc
{
    NSLog(@"dealloc --------------  %@", NSStringFromClass([self class]));
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear =================== %@", NSStringFromClass([self class]));
    
    // 可以在这里赋值frame 也可以在viewDidLayoutSubviews
//    [self setupFullFrameWithView:self.pageView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear ***************  %@", NSStringFromClass([self class]));
}


@end
