//
//  WYPageView.h
//  WYPageController
//
//  Created by lwy1218 on 2017/8/10.
//  Copyright © 2017年 lwy1218. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPageConfig.h"
#import "WYPageTitleView.h"

@interface WYPageView : UIView

@property (nonatomic , strong, readonly) WYPageConfig *config;
/**
 当前选中下标
 */
@property (nonatomic , assign) NSInteger currentSelectedIndex;
/**
 初始化 每个控制器需要有自己的标题 默认配置

 @param frame frame
 @param childVcs 子控制器数组
 @param parentViewController 父控制器
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                     childVcs:(NSArray *)childVcs
         parentViewController:(UIViewController *)parentViewController;

/**
 初始化 每个控制器需要有自己的标题

 @param frame frame
 @param childVcs 子控制器数组
 @param parentViewController 父控制器
 @param config 配置 可以为nil 当为nil时会使用默认配置
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                     childVcs:(NSArray *)childVcs
         parentViewController:(UIViewController *)parentViewController
                   pageConfig:(WYPageConfig *)config;

/**
 初始化

 @param frame frame
 @param childVcs 子控制器数组
 @param titles  标题数组
 @param parentViewController 父控制器
 @param config 配置 可以为nil 当为nil时会使用默认配置
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                     childVcs:(NSArray *)childVcs
                       titles:(NSArray *)titles
         parentViewController:(UIViewController *)parentViewController
                   pageConfig:(WYPageConfig *)config;

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
         parentViewController:(UIViewController *)parentViewController;

/**
 获取子控制器
 
 @param index index
 @return 子控制器
 */
- (UIViewController *)getChildrenControllerWithIndex:(NSInteger)index;

/**
 获取当前控制器所在下标
 
 @return index
 */
- (NSInteger)getCurrentControllerIndex;


/**
 获取当前的控制器
 
 @return vc
 */
- (UIViewController *)getCurrentController;

/**
 刷新页面数据 子控制器和标题数组分开传递
 
 @param childVcs 子控制器
 @param titles 标题数组
 */
- (void)reloadChildrenControllers:(NSArray *)childVcs titles:(NSArray *)titles;


/**
 刷新页面数据 子控制器需要有标题
 
 @param childVcs 子控制器
 */
- (void)reloadChildrenControllers:(NSArray *)childVcs;

@end
