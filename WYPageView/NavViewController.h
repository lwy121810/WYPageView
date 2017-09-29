//
//  NavViewController.h
//  WYPageView
//
//  Created by lwy1218 on 2017/9/29.
//

#import "DemoBaseViewController.h"
#import "WYPageConfig.h"
@interface NavViewController : DemoBaseViewController

@property (nonatomic , assign) WYCustomIndicatorViewStyle customStyle;
@property (nonatomic , strong) WYPageConfig *config;
@end
