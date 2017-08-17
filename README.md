# WYPageView

## pod支持
> pod 'WYPageView'

## 使用
#### 更多自定义配置可以查看`WYPageConfig.h`
 ```
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
    // config为nil时，采用默认配置
    WYPageView *view = [[WYPageView alloc] initWithFrame:frame childVcs:childVcs parentViewController:self pageConfig:nil];
    [self.view addSubview:view];
 ```
 
 ## 效果
 
![效果图](https://github.com/lwy121810/WYPageView/blob/master/Image/效果图.gif)
