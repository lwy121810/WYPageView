//
//  WYPageConetentView.h
//  WYPageController
//
//  Created by lwy1218 on 2017/8/10.
//  Copyright © 2017年 lwy1218. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYPageConetentView,WYPageConfig;
@protocol WYPageConetentViewDelegate <NSObject>
@required

/**
 拖拽view的代理

 @param pageContentView self
 @param progress progress
 @param sourceIndex sourceIndex
 @param targetIndex targetIndex
 */
- (void)pageContentView:(WYPageConetentView *)pageContentView
     scrollWithProgress:(double)progress
            sourceIndex:(NSInteger)sourceIndex
            targetIndex:(NSInteger)targetIndex;


/**
 拖拽结束的代理

 @param currentIndex 当前停留的页面下标
 */
- (void)scrollViewDidEndDeceleratingAtIndex:(NSInteger)currentIndex;

@end
@interface WYPageConetentView : UIView

/**
 代理
 */
@property (nonatomic , weak) id<WYPageConetentViewDelegate> delegate;

/**
 初始化

 @param frame frame 可以为zero 在合适的时间赋值frame
 @param childrenVcs 子控制器数组
 @param parentViewController 父控制器
 @param config 配置
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
      childrenViewControllers:(NSArray <UIViewController *> *)childrenVcs
             parentController:(UIViewController *)parentViewController
                       config:(WYPageConfig *)config;

/**
 初始化 在合适的时间赋值frame
 
 @param childrenVcs 子控制器数组
 @param parentViewController 父控制器
 @param config 配置信息 可以为nil
 @return self
 */
- (instancetype)initWithChildrenViewControllers:(NSArray <UIViewController *>*)childrenVcs
                               parentController:(UIViewController *)parentViewController
                                         config:(WYPageConfig *)config;

/**
 设置内容视图偏移量

 @param index 偏移量
 @param animated animated
 */
- (void)setContentOffsetWithCurrentIndex:(NSInteger)index animated:(BOOL)animated;


/**
 刷新数据

 @param childVcs 子控制器数组
 */
- (void)reloadData:(NSArray *)childVcs;


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

@end
