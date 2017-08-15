//
//  WYPageConfig.h
//  WYPageController
//
//  Created by lwy1218 on 2017/8/10.
//  Copyright © 2017年 lwy1218. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define WYDebug


#undef	RGB
#define RGB(R,G,B)		[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#undef	RGBA
#define RGBA(R,G,B,A)	[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]



@interface WYPageConfig : NSObject
/**
 是否显示下滑块 默认显示‘YES’
 */
@property (nonatomic , assign) BOOL showLine;

/**
 下滑块高度 默认‘2’
 */
@property (nonatomic , assign) CGFloat downLineHeight;

/**
 下滑块颜色 默认红色
 */
@property (nonatomic , strong) UIColor *downLineColor;

/**
 标题之间的间隔 默认‘15’
 */
@property (nonatomic , assign) CGFloat titleMargin;

/**
 标题字体大小 默认‘14’
 */
@property (nonatomic , strong) UIFont *titleFont;

/**
 标题是否可以缩放 默认NO
 */
@property (nonatomic , assign) BOOL canZoomTitle;

/**
 字体缩放比例 默认‘1.3’
 */
@property (nonatomic , assign) CGFloat titleZoomMultiple;

/**
 标题正常状态下字体颜色
 */
@property (nonatomic , strong) UIColor *normalTitleColor;

/**
 标题选中状态下字体颜色
 */
@property (nonatomic , strong) UIColor *selectedTitleColor;

/**
 标题按钮的背景颜色 默认‘nil’
 */
@property (nonatomic , strong) UIColor *titleItemBackgroundColor;

/**
 titleView的背景颜色 默认‘whiteColor’
 */
@property (nonatomic , strong) UIColor *titleViewBackgroundColor;

/**
 标题高度 默认‘44’
 */
@property (nonatomic , assign) CGFloat titleViewHeight;

/**
 是否渐变字体颜色 默认‘YES’
 */
@property (nonatomic , assign) BOOL gradientTitleColor;

/**
 当偏移量超过titleView宽度的比例时开始偏移 默认‘0.5’，即当标题偏移时，总会偏移到中间位置
 */
@property (nonatomic , assign) CGFloat paginationScale;

/**
 标题的动画时间（点击时滑块移动、字体缩放时间）默认‘0.25’
 */
@property (nonatomic , assign) NSTimeInterval titleAnimationDuration;

/**
 是否开启debug 默认NO，开启之后会检查传入的数据（vc是否包含导航栏，vc数量是否与title数量一致等）
 */
@property (nonatomic , assign) BOOL onDebug;

/**
 titleView的边缘按钮距离view的距离 即首个item的x值、最后一个item距离view的间距 默认‘15’
 */
@property (nonatomic , assign) CGFloat titleEdgeItemDistanceOfView;

/**
 当按钮的总宽度小于titleView的宽度时，按钮是否等距分布
 */
@property (nonatomic , assign) BOOL equallySpaceWhenItemsWidthLessThanTitleWidth;


/**
 contentView的滚动动画
 */
@property (nonatomic , assign) BOOL contentScrollAnimated;

@end
