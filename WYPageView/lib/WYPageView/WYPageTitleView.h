//
//  WYNavHeaderView.h
//  NavDemo
//
//  Created by lwy1218 on 2017/8/9.
//  Copyright © 2017年 lwy1218. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYPageTitleView, WYPageConfig;

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


/**
 初始化

 @param frame frame
 @param titles 标题数组
 @param config 配置
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles config:(WYPageConfig *)config;

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
 设置mainView的偏移量

 @param currentIndex 下标
 */
- (void)setHeaderContentOffsetWithCurrentIndex:(NSInteger)currentIndex;

/**
 刷新标题
 
 @param titles 标题组
 */
- (void)reloadTitles:(NSArray *)titles;

@end
