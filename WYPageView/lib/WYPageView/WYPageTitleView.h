//
//  WYNavHeaderView.h
//  NavDemo
//
//  Created by lwy1218 on 2017/8/9.
//  Copyright © 2017年 lwy1218. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPageConfig.h"
@class WYPageTitleView;

@protocol WYPageTitleViewDataSource <NSObject>

@required

/**
 自定义指示器view 在自定义指示器的时候需要实现该代理方法

 @param pageTitleView self
 @return 自定义view 如果没有frame 则会按照'config'的
 */
- (UIView *)customIndicatorViewForPageTitleView:(WYPageTitleView *)pageTitleView;

@optional

/**
 自定义指示器view的滚动效果

 @param indicatorView 指示器view
 @param progress 进度
 @param sourceIndex sourceIndex
 @param targetIndex targetIndex
 */
- (void)setCustomIndicatorViewScrollAnimation:(UIView *)indicatorView
                                     progress:(double)progress
                                  sourceIndex:(NSInteger)sourceIndex
                                  targetIndex:(NSInteger)targetIndex;
@end
@protocol WYPageTitleViewDelegate <NSObject>

/**
 按钮点击事件的代理

 @param pageTitleView pageTitleView
 @param selectdIndex 当前按钮下标
 @param oldIndex 上一次点击的按钮下标
 */
- (void)pageTitleView:(WYPageTitleView *)pageTitleView selectdIndexItem:(NSInteger)selectdIndex oldIndex:(NSInteger)oldIndex;

@end
@interface WYPageTitleView : UIView

@property (nonatomic , weak) id<WYPageTitleViewDelegate>delegate;

/** 自定义指示器的时候的数据源 */
@property (nonatomic , weak) id<WYPageTitleViewDataSource>dataSource;

@property (nonatomic , assign) WYPageTitleIndicatorViewStyle indicatorStyle;


/**
 初始化

 @param frame frame
 @param titles 标题数组
 @param config config
 @param dataSource 数据源
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles config:(WYPageConfig *)config dataSource:(id<WYPageTitleViewDataSource>)dataSource;



/**
 设置item的title
 
 @param progress 翻页进度
 @param sourceIndex 源index
 @param targetIndex 目标index
 */
- (void)setTitleWithProgress:(double)progress
                 sourceIndex:(NSInteger)sourceIndex
                 targetIndex:(NSInteger)targetIndex;


/**
 设置mainView的偏移量 contentView滚动结束后调用

 @param currentIndex 下标
 */
- (void)setHeaderContentOffsetWithCurrentIndex:(NSInteger)currentIndex;

/**
 设置对应下标的选中效果

 @param currentIndex 下标
 */
- (void)setupSelectedIndex:(NSInteger)currentIndex;

/**
 获取对应下标位置的按钮
 
 @param index 下标
 @return 按钮
 */
- (UIButton *)getItemWithIndex:(NSInteger)index;

/**
 刷新标题
 
 @param titles 标题组
 */
- (void)reloadTitles:(NSArray *)titles;

@end
