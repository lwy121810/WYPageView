//
//  WYNavHeaderView.m
//  NavDemo
//
//  Created by lwy1218 on 2017/8/9.
//  Copyright © 2017年 lwy1218. All rights reserved.
//

#import "WYPageTitleView.h"
typedef struct {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
}WYRGBNumber;

@interface WYPageTitleView ()
{
    NSInteger _currentIndex;
    UIButton *_currentItem;
}
/** scrollView */
@property (nonatomic , strong) UIScrollView *mainView;

/** 存放item的数组 */
@property (nonatomic , strong) NSMutableArray <UIButton *>* itemArray;

/** 标题数组 */
@property (nonatomic , strong) NSArray<NSString *> *titles;

/** 选中的字体颜色rgb值 */
@property (nonatomic , assign) WYRGBNumber selectColor;

/** normal状态下字体颜色rgb值 */
@property (nonatomic , assign) WYRGBNumber normalColor;

/** 字体颜色变化范围 */
@property (nonatomic , assign) WYRGBNumber colorRange;

@property (nonatomic , strong) WYPageConfig *config;
/** 指示器view */
@property (nonatomic , strong) UIView *indicatorView;

/** 指示器view的高 */
@property (nonatomic , assign) CGFloat indicatorHeight;

/** 指示器view的宽度 */
@property (nonatomic , assign) CGFloat indicatorWidth;

@property (nonatomic , assign) CGFloat itemsTotalWidth;

@end
@implementation WYPageTitleView
#pragma mark - 懒加载
- (NSMutableArray<UIButton *> *)itemArray
{
    if (!_itemArray) {
        self.itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
- (void)dealloc {
    WYLog(@"WYPageTitleView ---> dealloc 销毁");
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles config:(WYPageConfig *)config dataSource:(id<WYPageTitleViewDataSource>)dataSource
{
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        if (config == nil) {
            config = [[WYPageConfig alloc] init];
        }
        _config = config;
        _indicatorStyle = config.indicatorStyle;
        
        _indicatorHeight = config.indicatorViewHeight;
        _indicatorWidth = config.indicatorViewWidth;
        _dataSource = dataSource;
        [self setupDefaultValue];
        [self setupUI];
    }
    return self;
}

- (UIButton *)createButtonWithTitle:(NSString *)title tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = self.config.titleFont;
    [button setTitleColor:self.config.normalTitleColor forState:UIControlStateNormal];
    button.tag = tag;
    return button;
}
#pragma mark - 设置默认值
- (void)setupDefaultValue
{
    _currentIndex = self.config.defaultSelectedIndex;
    if (_currentIndex < 0) {
        _currentIndex = 0;
    }
    if (_currentIndex > self.titles.count - 1) {
        _currentIndex = self.titles.count - 1;
    }
    if (self.config.gradientTitleColor) {//字体颜色渐变
        WYRGBNumber selectedColor = [self getRGBColor:self.config.selectedTitleColor];
        WYRGBNumber normalColor = [self getRGBColor:self.config.normalTitleColor];
        
        self.selectColor = selectedColor;
        self.normalColor = normalColor;
        
        //计算变化范围
        WYRGBNumber colorRange = {_selectColor.red - _normalColor.red,_selectColor.green - _normalColor.green,_selectColor.blue - _normalColor.blue, _selectColor.alpha - _normalColor.alpha};
        self.colorRange = colorRange;
    }
}

/**
 根据rgb获取颜色
 
 @param rgb rgb
 @return color
 */
- (UIColor *)getColorWithColorNumber:(WYRGBNumber)rgb
{
    return [UIColor colorWithRed:rgb.red green:rgb.green blue:rgb.blue alpha:rgb.alpha];
}

/**
 根据颜色获取rgb值 此方法只能获取rgb空间的颜色值，其他的获取不到（如grayColor），因此改用下面的方法
 
 @param color color
 @return rgb
 */
//- (WYRGBNumber)getRGBWithColor:(UIColor *)color {
//    CGFloat numOfcomponents = CGColorGetNumberOfComponents(color.CGColor);
//    NSArray *rgbComponents;
//    if (numOfcomponents == 4) {
//        const CGFloat *components = CGColorGetComponents(color.CGColor);
//        rgbComponents = [NSArray arrayWithObjects:@(components[0]), @(components[1]), @(components[2]), nil];
//        WYRGBNumber color = {components[0],components[1],components[2], YES};
//        return color;
//    }
//#ifdef WYDEBUG
//    NSAssert(NO, @"WYPageTitleView==========>>>>>>>>设置字体颜色时应该使用具有rgb颜色空间的color");
//#endif
//    return (WYRGBNumber){0.0,0.0,0.0, NO};
//}

/**
 根据颜色获取rgb值
 
 @param color color
 @return rgb value
 */
- (WYRGBNumber)getRGBColor:(UIColor *)color
{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    return (WYRGBNumber){red,green,blue, alpha};
}
- (UIScrollView *)mainView
{
    if (!_mainView) {
        UIScrollView *mainView = [[UIScrollView alloc] init];
        [self addSubview:mainView];
        mainView.showsVerticalScrollIndicator = NO;
        mainView.showsHorizontalScrollIndicator = NO;
        self.mainView = mainView;
    }
    return _mainView;
}
-  (void)setIndicatorHeight:(CGFloat)indicatorHeight
{
    if (_indicatorHeight == indicatorHeight) return;
    _indicatorHeight = indicatorHeight;
    [self resetContentViewHeightWithIndicatorHeight:indicatorHeight];
}

/**
 重新设置按钮和指示器view的高度

 @param indicatorHeight 指示器view的高度
 */
- (void)resetContentViewHeightWithIndicatorHeight:(CGFloat)indicatorHeight
{
    CGRect indicatorFrame = self.indicatorView.frame;
    indicatorFrame.size.height = indicatorHeight;
    self.indicatorView.frame = indicatorFrame;
    
    CGFloat h = CGRectGetHeight(self.mainView.frame) - indicatorHeight;
    [self.itemArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = obj.frame;
        frame.size.height = h;
        obj.frame = frame;
    }];
}

/**
 设置标题按钮

 @param itemH 按钮高度
 @return 按钮总宽度
 */
- (CGFloat)setupItemsWithItemHeight:(CGFloat)itemH
{
    CGFloat y = 0;
    WYPageTitleIndicatorViewPositionStyle position = self.config.indicatorPositionStyle;
    if (position == WYPageTitleIndicatorViewPositionStyleTop) {//指示器在上面
        y =  _indicatorHeight;
    }
    
    CGFloat firstX = self.config.titleEdgeItemDistanceOfView;
    CGFloat itemMargin = self.config.titleMargin;
    
    __block UIButton *lastView = nil;
    __block CGFloat itemTotalWidth = 0.0;
    __block CGFloat itemW = 0;
    if (!self.config.autoCalculateTitleItemWidth) {
        itemW = self.config.itemWidth;
    }
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //0.计算宽度
        if (self.config.autoCalculateTitleItemWidth) {
            itemW = [self getTitleWidth:obj];
        }
        //1.创建
        UIButton *button = [self createButtonWithTitle:obj tag:(idx + 1000)];
        //2.设置frame
        if (lastView == nil) {
            button.frame = CGRectMake(firstX, y, itemW, itemH);
        }
        else {
            CGFloat x = CGRectGetMaxX(lastView.frame) + itemMargin;
            button.frame = CGRectMake(x, y, itemW, itemH);
        }
        
        //3.添加到view
        [self.mainView addSubview:button];
        //4.设置背景颜色
        if (self.config.titleItemBackgroundColor) {
            button.backgroundColor = self.config.titleItemBackgroundColor;
        }
        //5.处理选中状态
        if(idx == _currentIndex) {
            //1.设置选中状态字体颜色
            [button setTitleColor:self.config.selectedTitleColor forState:UIControlStateNormal];
            //2.记录当前item
            if (self.config.gradientTitleColor == NO) {//字体颜色不渐变
                _currentItem = button;
            }
            //3.放大字体
            if (self.config.canZoomTitle) {
                CGFloat zoom = self.config.titleZoomMultiple;
                [self zoomTitleWithSender:button scale:zoom];
            }
        }
        //6.计算总宽度
        itemTotalWidth += button.frame.size.width;
        //7.赋值
        lastView = button;
        //8.添加进数组
        [self.itemArray addObject:button];
    }];
    
    if (self.titles.count == 1) {
        WYPageSingleTitleTextAlignment alignment = self.config.singleTitleAlignment;
        if (alignment == WYPageSingleTitleTextAlignmentCenter) {
            CGPoint center = lastView.center;
            center.x = self.center.x;
            lastView.center = center;
        }
        else if (alignment == WYPageSingleTitleTextAlignmentRight) {
            CGRect frame = lastView.frame;
            CGFloat x = CGRectGetWidth(self.mainView.frame) - firstX - frame.size.width;
            frame.origin.x = x;
            lastView.frame = frame;
        }
    }
    CGFloat contentW = CGRectGetMaxX(lastView.frame) + firstX;
    self.mainView.contentSize = CGSizeMake(contentW, 0);
    _itemsTotalWidth = itemTotalWidth;
    return itemTotalWidth;
}

/**
 创建指示器view
 */
- (void)setupIndicatorView
{
    // 不显示指示器 直接返回
    if (_indicatorStyle == WYPageTitleIndicatorViewStyleNone) return;
    if (_indicatorStyle == WYPageTitleIndicatorViewStyleDownLine) {//下划线类型
        UIView *view = [[UIView alloc] init];
        [self.mainView addSubview:view];
        view.backgroundColor = self.config.indicatorViewColor;
        self.indicatorView = view;
    }
    else {
        UIView *view = [self getCustomIndicatorView];
        [self.mainView addSubview:view];
        CGFloat ch = CGRectGetHeight(view.frame);
        CGFloat cw = CGRectGetWidth(view.frame);
        if (ch <= 0) {
            ch = 0;
        }
        if (cw <= 0) {
            cw = 0;
        }
        
        _indicatorHeight = ch;
        _indicatorWidth = cw;
        
        self.indicatorView = view;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self resetLayout];
}
- (void)resetLayout
{
    //1.设置frame
    self.mainView.frame = self.bounds;
    //2.设置等距分布
    if (self.config.equallySpaceWhenItemsWidthLessThanTitleWidth) {
        [self setupItemEquallySpaceWithItemTotalWidth:_itemsTotalWidth];
    }
    //3.是否显示指示器
    BOOL showIndicator = self.indicatorStyle != WYPageTitleIndicatorViewStyleNone;
    //4.设置指示器view的frame
    if (showIndicator) {//显示指示器
        //设置指示器frame
        [self setupIndicatorViewFrameWithIndicatorW:_indicatorWidth];
    }
}

/**
 设置UI
 */
- (void)setupUI
{
    if (self.titles == nil || self.titles.count == 0) return;
    // 1.设置mainView的frame
    self.mainView.frame = self.bounds;
    if (@available(iOS 11.0, *)) {
        self.mainView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    // 2.按钮的高度
    CGFloat itemH = self.config.titleViewHeight;
   
    // 3.创建指示器
    if (_indicatorStyle != WYPageTitleIndicatorViewStyleNone) {
        // 3.1 创建指示器
        [self setupIndicatorView];
        
        if (_indicatorHeight <= 0) {
            _indicatorHeight = self.config.indicatorViewHeight;
        }
        if (_indicatorWidth <= 0) {
            _indicatorWidth = self.config.indicatorViewWidth;
        }
        
        // 3.2 根据指示器高度计算按钮的高度
        if (self.config.indicatorPositionStyle != WYPageTitleIndicatorViewPositionStyleCenter) {
            itemH = itemH - _indicatorHeight;
        }
    }
    // 4.创建标题 并计算按钮的总宽度
    CGFloat itemTotalWidth = [self setupItemsWithItemHeight:itemH];
    
    // 5.设置等距分布
    if (self.config.equallySpaceWhenItemsWidthLessThanTitleWidth) {
        [self setupItemEquallySpaceWithItemTotalWidth:itemTotalWidth];
    }
    // 6.是否显示指示器
    BOOL showIndicator = self.indicatorStyle != WYPageTitleIndicatorViewStyleNone;
    
    // 7.设置指示器view的frame
    if (showIndicator) {//显示指示器
        //设置指示器frame
        [self setupIndicatorViewFrameWithIndicatorW:_indicatorWidth];
    }
    // 8.调整指示器的位置
    if (self.config.canZoomTitle && showIndicator) {// 如果缩放了字体并且显示指示器 重新调整指示器位置
        [self adjustIndicatorOrigin];
    }
    // 9.设置默认背景颜色
    self.mainView.backgroundColor = self.config.titleViewBackgroundColor;
    self.backgroundColor = self.config.titleViewBackgroundColor;
}

/**
 调整指示器位置
 */
- (void)adjustIndicatorOrigin
{
    UIButton *currentItem = [self getItemWithIndex:_currentIndex];
    if (self.config.indicatorViewWidthEqualToItemWidth) {//指示器宽度等于按钮宽度
        [self resetIndicatorViewOriginWithSender:currentItem];
    }
    else {//手动设置指示器宽度
        // 调整指示器中心点等于按钮的中心点
        CGPoint center = self.indicatorView.center;
        center.x = currentItem.center.x;
        self.indicatorView.center = center;
    }
}

/**
 设置指示器frame

 @param indicatorW 指示器宽度
 */
- (void)setupIndicatorViewFrameWithIndicatorW:(CGFloat)indicatorW
{
    UIButton *currentItem = [self getItemWithIndex:_currentIndex];
    CGFloat originX = 0;
    if (self.config.indicatorViewWidthEqualToItemWidth) {//指示器view与item宽度相同
        indicatorW = currentItem.frame.size.width;
        originX = currentItem.frame.origin.x;
    }
    else {
        if (indicatorW == 0) {// 等于0 说明是下划线样式或者自定义view没有宽度
            indicatorW = self.config.indicatorViewWidth;
        }
        originX = currentItem.center.x - indicatorW * 0.5;
    }
    CGFloat indicatorH = _indicatorHeight;
    
    // 计算y
    CGFloat indicatorY = 0;
    CGFloat mainH = CGRectGetHeight(self.mainView.frame);
    WYPageTitleIndicatorViewPositionStyle position = self.config.indicatorPositionStyle;
    if (position == WYPageTitleIndicatorViewPositionStyleTop) {//指示器在上面 y = 0
        indicatorY = 0;
    }
    else if (position == WYPageTitleIndicatorViewPositionStyleBottom) {// 指示器view在下面
        indicatorY = mainH - indicatorH;
    }
    else {// 指示器在中间
        indicatorY = (mainH - indicatorH) * 0.5;
    }
    
    self.indicatorView.frame = CGRectMake(originX, indicatorY, indicatorW, indicatorH);
}

/**
 设置按钮的等距分布

 @param itemTotalWidth 按钮的总宽度
 */
- (void)setupItemEquallySpaceWithItemTotalWidth:(CGFloat)itemTotalWidth
{
    
    CGFloat firstX = self.config.titleEdgeItemDistanceOfView;
    
    CGFloat contentW = CGRectGetMaxX(self.itemArray.lastObject.frame) + firstX;
    
    CGFloat mainW = CGRectGetWidth(self.mainView.frame);
    
    if (contentW < mainW) {
        
        CGFloat residue = mainW - itemTotalWidth - self.itemArray.firstObject.frame.origin.x - firstX;
        
        CGFloat margin = residue / (self.itemArray.count - 1);
        
        [self resetItemMargin:margin];
    }
}

/**
 获取自定义的指示器view

 @return view
 */
- (UIView *)getCustomIndicatorView
{
    if ([_dataSource respondsToSelector:@selector(customIndicatorViewForPageTitleView:)]) {
        UIView *customView = [_dataSource customIndicatorViewForPageTitleView:self];
#ifdef WYDEBUG
        NSAssert(customView, @"自定义的指示器view不能为nil ！！！");
#endif
        return customView;
    }
#ifdef WYDEBUG
    NSAssert(NO, @"当自定义指示器view时、应当实现‘- (UIView *)customIndicatorViewForPageTitleView:(WYPageTitleView *)pageTitleView’代理方法");
#endif
    return nil;

}
/**
 重新设置item的间距

 @param margin 间距
 @return 最后一个item
 */
- (UIButton *)resetItemMargin:(CGFloat)margin
{
    __block UIButton *lastView = nil;
    [self.itemArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = obj.frame;
        if (lastView == nil) {
            obj.frame = frame;
        }
        else {
            CGFloat x = CGRectGetMaxX(lastView.frame) + margin;
            frame.origin.x = x;
            obj.frame = frame;
        }
        lastView = obj;
    }];
    return lastView;
}
/**
 根据标题获取宽度
 
 @param title 标题
 @return 标题宽度
 */
- (CGFloat)getTitleWidth:(NSString *)title
{
    UIFont *font = self.config.titleFont;
    CGFloat w = 0.0;
    if (font) {
        CGRect bounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
        w = bounds.size.width;
    }
    return w;
}
#pragma mark - buttn按钮的点击事件
- (void)buttonAction:(UIButton *)sender
{
    //0.是否禁止点击
    if (self.config.forbidTitleClick) return;
    //1.取出下标
    NSInteger index = sender.tag - 1000;
    //2.点击的同一个 直接返回
    if (index == _currentIndex) return;
    //3.取出上一个按钮
    UIButton *oldBtn = [self getItemWithIndex:_currentIndex];
    if (oldBtn == nil) return;
    //4.更换字体颜色
    //4.1 改变上一个按钮颜色
    UIColor *normalColor = self.config.normalTitleColor;
    [oldBtn setTitleColor:normalColor forState:UIControlStateNormal];
    //4.2 改变当前按钮的字体颜色
    UIColor *selectColor = self.config.selectedTitleColor;
    [sender setTitleColor:selectColor forState:UIControlStateNormal];
    
    
    //5.设置mainView的偏移量
    //5.1 计算开始偏移的最小值
    CGFloat paginationOrigin = self.mainView.frame.size.width * self.config.paginationScale;
    
    //5.2 计算center
    CGFloat centerX = sender.center.x;
    
    //5.3 判断是否应该偏移
    if (centerX > paginationOrigin) {
        CGFloat offset = centerX - paginationOrigin;
        [self resetContentOffset:offset];
    }
    else {
        [self resetContentOffset:0];
    }
    //6.变化字体大小
    if (self.config.canZoomTitle) {
        CGFloat zoom = self.config.titleZoomMultiple;
        BOOL animation = self.config.titleAnimationEnable;
        if (animation) {
            animation = self.config.titleAnimationDuration > 0.0;
        }
        
        if (animation) {
            [UIView animateWithDuration:self.config.titleAnimationDuration animations:^{
                [self zoomTitleWithSender:oldBtn scale:1.0];
                [self zoomTitleWithSender:sender scale:zoom];
            } completion:^(BOOL finished) {
              
            }];
        }
        else {
            [self zoomTitleWithSender:oldBtn scale:1.0];
            [self zoomTitleWithSender:sender scale:zoom];
        }
    }
    
    
    //7. 调整指示器位置
    if (_indicatorStyle != WYPageTitleIndicatorViewStyleNone) {
        BOOL animation = self.config.titleAnimationEnable;
        if (animation) {
            animation = self.config.titleAnimationDuration > 0.0;
        }
//        if (animation) {
//            [UIView animateWithDuration:self.config.titleAnimationDuration animations:^{
//                [self resetIndicatorViewOriginWithSender:sender];
//            }];
//        }
//        else {
//            [self resetIndicatorViewOriginWithSender:sender];
//        }
//
        [self setupClickIndicatorViewMoveAnimation:animation sourceBtn:oldBtn targetBtn:sender];
    }
    
    //8.记录当前item
    if (self.config.gradientTitleColor == NO) {//不渐变字体颜色
        //记录当前的item
        _currentItem = sender;
    }
    //9.记录当前item的index
    NSInteger oldIndex = _currentIndex;
    _currentIndex = index;
    
    //10. 代理
    if (_delegate && [_delegate respondsToSelector:@selector(pageTitleView:selectdIndexItem:oldIndex:)]) {
        [_delegate pageTitleView:self selectdIndexItem:_currentIndex oldIndex:oldIndex];
    }
}

/**
 设置按钮点击时指示器的value2滑动类型的滑动动画

 @param sourceBtn sourceBtn
 @param targetBtn targetBtn
 */
- (void)configClickItemAnimationValue2WithSourceBtn:(UIButton *)sourceBtn targetBtn:(UIButton *)targetBtn
{
    // 1.计算sourceW、targetW
    CGFloat sourceW = 0;
    CGFloat targetW = 0;
    if (self.config.indicatorViewWidthEqualToItemWidth) {
        // 指示器宽度等于按钮的宽度
        sourceW = sourceBtn.frame.size.width;
        targetW = targetBtn.frame.size.width;
    }
    else {
        // 自定义的宽度
        sourceW = targetW = _indicatorWidth;
    }
    // 2.获取originX
    CGFloat sourceBtnOrigin = sourceBtn.frame.origin.x;
    CGFloat targetBtnOrigin = targetBtn.frame.origin.x;
    
    // 3.指示器的最大宽度
    CGFloat maxIndicatorW = 0;
    // 4.获取动画时间
    NSTimeInterval duration = self.config.titleAnimationDuration;
    NSTimeInterval halfDuration = duration * 0.5;
    //5.滑向右边
    if (targetBtnOrigin > sourceBtnOrigin) {//向右移动
        //5.1 计算值
        CGFloat targetRight = targetBtn.center.x + targetW * 0.5;
        CGFloat sourceLeft = sourceBtn.center.x - sourceW * 0.5;
        
        //5.2 计算下划线最大宽度
        maxIndicatorW = targetRight - sourceLeft;
        //5.3 开始动画
        [UIView animateWithDuration:halfDuration animations:^{
            //指示器的变化: x不变 宽度增加
            CGRect frame = self.indicatorView.frame;
            frame.size.width = maxIndicatorW;
            self.indicatorView.frame = frame;
            
        } completion:^(BOOL finished) {
            //指示器的变化: maxX不变 宽度减小
            if (finished) {
                [UIView animateWithDuration:halfDuration animations:^{
                    CGRect frame = self.indicatorView.frame;
                    frame.size.width = targetW;
                    frame.origin.x = targetBtnOrigin;
                    self.indicatorView.frame = frame;
                }];
            }
        }];
    }
    else {//6. 向左移动
        
        //6.1 计算值
        CGFloat targetLeft = targetBtn.center.x - targetW * 0.5;
        CGFloat sourceRight = sourceBtn.center.x + sourceW * 0.5;
        
        //6.2 计算指示器最大宽度
        maxIndicatorW = sourceRight - targetLeft;
        
        CGFloat indicatorMaxX = CGRectGetMaxX(_indicatorView.frame);
        [UIView animateWithDuration:halfDuration animations:^{
            //指示器的变化: right不变 宽度增加
            CGRect frame = self.indicatorView.frame;
            frame.size.width = maxIndicatorW;
            frame.origin.x = indicatorMaxX - frame.size.width;
            self.indicatorView.frame = frame;
            
        } completion:^(BOOL finished) {
            //指示器的变化: x不变 宽度减小
            if (finished) {
                [UIView animateWithDuration:halfDuration animations:^{
                    CGRect frame = self.indicatorView.frame;
                    frame.size.width = targetW;
                    frame.origin.x = targetBtnOrigin;
                    self.indicatorView.frame = frame;
                }];
            }
        }];
    }
}

/**
 设置点击按钮时 指示器的滑动动画

 @param animation 是否有动画
 @param sourceBtn sourceBtn
 @param targetBtn targetBtn
 */
- (void)setupClickIndicatorViewMoveAnimation:(BOOL)animation
                              sourceBtn:(UIButton *)sourceBtn
                              targetBtn:(UIButton *)targetBtn
{
    // 1.获取滚动动画类型
    WYIndicatorScrollAnimation scrollAnimation = self.config.indicatorViewScrollAnimation;

    // 2.获取动画时间
    NSTimeInterval duration = self.config.titleAnimationDuration;
    
    // 3. 有动画
    if (animation) {
        // 3.1 动画二
        if (scrollAnimation == WYIndicatorScrollAnimationValue2) {
            [self configClickItemAnimationValue2WithSourceBtn:sourceBtn targetBtn:targetBtn];
            return;
        }
        // 3.2 动画一类型（默认类型 自定义类型都以这种发式实现）
        [UIView animateWithDuration:duration animations:^{
            [self resetIndicatorViewOriginWithSender:targetBtn];
        }];
    }
    else {
        // 没有动画
        [self resetIndicatorViewOriginWithSender:targetBtn];
    }
}
/**
 清除内容
 */
- (void)clearData
{
    [self.itemArray removeAllObjects];
    [self removeAllSubViewsWithSuperView:self.mainView];
    self.titles = nil;
    if (_indicatorView) {
        [_indicatorView removeFromSuperview];
        _indicatorView = nil;
    }
    
    _currentIndex = 0;
    
    if (_currentItem) {
        [_currentItem removeFromSuperview];
        _currentItem = nil;
    }
}

- (void)removeAllSubViewsWithSuperView:(UIView *)superView
{
    if (superView == nil || superView.subviews.count == 0) return;
    
    [superView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
/**
 刷新标题
 
 @param titles 标题组
 */
- (void)reloadTitles:(NSArray *)titles
{
    [self clearData];
    
    self.titles = titles;
    
    [self setupUI];
    
    [self resetContentOffset:0];
}

/**
 设置偏移量

 @param targetBtn targetBtn
 */
- (void)configContentOffsetWithTargetBtn:(UIButton *)targetBtn
{
    CGFloat paginationOrigin = self.mainView.frame.size.width * self.config.paginationScale;
    
    CGFloat centerX = targetBtn.center.x;
    
    if (centerX > paginationOrigin) {
        //把item移到中点
        CGFloat offset = centerX - paginationOrigin;
        [self resetContentOffset:offset];
    }
    else {
        [self resetContentOffset:0];
    }
}
/**
 设置item的title
 
 @param progress 翻页进度
 @param sourceIndex 源index
 @param targetIndex 目标index
 */
- (void)setTitleWithProgress:(double)progress
                 sourceIndex:(NSInteger)sourceIndex
                 targetIndex:(NSInteger)targetIndex

{
    //0.取出btn
    UIButton *sourceBtn = [self getItemWithIndex:sourceIndex];
    UIButton *targetBtn = [self getItemWithIndex:targetIndex];
  
    if (sourceBtn == nil || targetBtn == nil) return;
    
    //1.处理mainView的偏移量
    if (progress == 1.0) {
        [self configContentOffsetWithTargetBtn:targetBtn];
    }
    
    //2.处理字体颜色
    if (self.config.gradientTitleColor) {//渐变字体颜色
        [self gradientTitleColorWithProgress:progress sourceBtn:sourceBtn targetBtn:targetBtn];
    }
    
    //3.处理指示器
    if (_indicatorStyle != WYPageTitleIndicatorViewStyleNone) {// 有指示器
        [self configIndicatorAnimationWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
    
    //4.处理字体大小
    if (self.config.canZoomTitle) {//字体缩放
        [self zoomTitleWithProgress:progress sourceBtn:sourceBtn targetBtn:targetBtn];
    }
    
    //5.记录最新的index
    _currentIndex = targetIndex;
}
/**
 设置指示器滚动效果

 @param progress progress
 @param sourceIndex sourceIndex
 @param targetIndex targetIndex
 */
- (void)configIndicatorAnimationWithProgress:(double)progress
                                 sourceIndex:(NSInteger)sourceIndex
                                 targetIndex:(NSInteger)targetIndex
{
    
    UIButton *sourceBtn = [self getItemWithIndex:sourceIndex];
    UIButton *targetBtn = [self getItemWithIndex:targetIndex];
    
    switch (self.config.indicatorViewScrollAnimation) {//动画类型
        case WYIndicatorScrollAnimationValue1:// 效果1
        {
            [self configIndicatorAnimationValue1WithProgress:progress sourceBtn:sourceBtn targetBtn:targetBtn];
        }
            break;
        case WYIndicatorScrollAnimationValue2:// 效果2
        {
            [self configIndicatorAnimationValue2WithProgress:progress sourceBtn:sourceBtn targetBtn:targetBtn];
        }
            break;
        case WYIndicatorScrollAnimationNone: // 没效果
        {
            //在滑动结束之后处理
        }
            break;
            
        case WYIndicatorScrollAnimationCustom://自定义
        {
            if (_dataSource && [_dataSource respondsToSelector:@selector(setCustomIndicatorViewScrollAnimation:progress:sourceIndex:targetIndex:)]) {
                [_dataSource setCustomIndicatorViewScrollAnimation:self.indicatorView progress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
            }
            else {
#ifdef WYDEBUG
                NSAssert(NO, @"当自定义指示器的滚动效果时、应当在'pageView'所在的控制器中实现'setCustomIndicatorViewScrollAnimation:progress:sourceIndex:targetIndex:'数据源方法");
#endif
                [self configIndicatorAnimationValue1WithProgress:progress sourceBtn:sourceBtn targetBtn:targetBtn];
            }
        }
            break;
        default:
            
            break;
    }
}


/**
 缩放字体
 
 @param progress progress
 @param sourceBtn sourceBtn
 @param targetBtn targetBtn
 */
- (void)zoomTitleWithProgress:(double)progress
                    sourceBtn:(UIButton *)sourceBtn
                    targetBtn:(UIButton *)targetBtn
{
    //变化字体
    CGFloat zoomRange = self.config.titleZoomMultiple - 1.0;
    
    CGFloat sourceZoom = (1 - progress) * zoomRange + 1;
    
    sourceBtn.transform = CGAffineTransformMakeScale(sourceZoom, sourceZoom);
    
    CGFloat targetZoom = 1 + zoomRange * progress;
    
    targetBtn.transform = CGAffineTransformMakeScale(targetZoom, targetZoom);
}

- (void)zoomTitleWithSender:(UIButton *)sender scale:(CGFloat)scale
{
    sender.transform = CGAffineTransformMakeScale(scale, scale);
}

/**
 移动指示器 动画效果value2
 
 @param progress progress
 @param sourceBtn sourceBtn
 @param targetBtn targetBtn
 */
- (void)configIndicatorAnimationValue2WithProgress:(double)progress
                                        sourceBtn:(UIButton *)sourceBtn
                                        targetBtn:(UIButton *)targetBtn
{
    CGFloat sourceW = 0;
    CGFloat targetW = 0;
    
    if (self.config.indicatorViewWidthEqualToItemWidth) {
        sourceW = sourceBtn.frame.size.width;
        targetW = targetBtn.frame.size.width;
    }
    else {
        sourceW = targetW = _indicatorWidth;
    }
    
    CGFloat sourceBtnOrigin = sourceBtn.frame.origin.x;
    CGFloat targetBtnOrigin = targetBtn.frame.origin.x;
    
    //1.下划线的宽
    CGFloat lineW = 0;
    //2.下划线x
    CGFloat lineOriginX = 0;
    //3.下划线最大宽度
    CGFloat maxLineW = 0;
    //4.下划线宽度变化范围
    CGFloat widthChangeRange = 0;
    
    //5.滑向右边
    if (targetBtnOrigin > sourceBtnOrigin) {//向右移动
        //5.1 目标的right
        CGFloat targetRight = targetBtn.center.x + targetW * 0.5;
        CGFloat sourceLeft = sourceBtn.center.x - sourceW * 0.5;
        
        //5.2 计算下划线最大宽度
        maxLineW = targetRight - sourceLeft;
        
        //5.3 进度小于0.5 乘以2是为了在进度到达0.5时下划线宽度达到最大值
        if (progress < 0.5) {//下划线的变化: x不变 宽度增加
            // 5.3.1 计算宽度变化范围
            widthChangeRange = maxLineW - sourceW;
            // 5.3.2 计算下划线的x
            lineOriginX = self.indicatorView.frame.origin.x;
            // 5.3.3 计算下划线的宽度
            lineW = sourceW + progress * widthChangeRange * 2;
        }
        //5.4 进度大于0.5
        else {//下划线的变化: maxX不变 宽度减小
            // 5.4.1 计算宽度变化范围
            widthChangeRange = maxLineW - targetW;
            // 5.4.2 计算下划线的宽度
            lineW = widthChangeRange * (1 - progress) * 2 + targetW;
            // 5.4.3 计算x
            lineOriginX = targetRight - lineW;
        }
    }
    else {//6. 向左移动
        //6.1 计算目标最小x
        CGFloat targetLeft = targetBtn.center.x - targetW * 0.5;
        //6.2 计算下划线宽度最大值
        maxLineW = sourceBtn.center.x + sourceW * 0.5 - targetLeft;
        //6.3 进度小于0.5 乘以2是为了在进度到达0.5时下划线宽度达到最大值
        if (progress < 0.5) {//下划线的变化: right不变 宽度增加
            // 6.3.1 计算宽度变化范围
            widthChangeRange = maxLineW - sourceW;
            // 6.3.2 计算下划线的宽度
            lineW = sourceW + progress * widthChangeRange * 2;
            // 6.3.3 计算x
            lineOriginX = sourceBtn.center.x + sourceW * 0.5 - lineW;
        }
        //6.4 进度大于0.5
        else {//下划线的变化: x不变 宽度减小
            // 6.4.1 计算宽度变化范围
            widthChangeRange = maxLineW - targetW;
            // 6.4.2 计算下划线的宽度
            lineW = widthChangeRange * (1 - progress) * 2 + targetW;
            // 6.4.3 计算x
            lineOriginX = targetBtn.center.x - targetW * 0.5;
        }
    }
    
    //7. 改变下划线frame
    CGRect lineFrame = self.indicatorView.frame;
    lineFrame.size.width = lineW;
    lineFrame.origin.x = lineOriginX;
    self.indicatorView.frame = lineFrame;
}

/**
 移动指示器 动画效果value1 默认效果
 
 @param progress progress
 @param sourceBtn sourceBtn
 @param targetBtn targetBtn
 */
- (void)configIndicatorAnimationValue1WithProgress:(double)progress
                                         sourceBtn:(UIButton *)sourceBtn
                                         targetBtn:(UIButton *)targetBtn
{
    CGFloat sourceW = 0;
    CGFloat targetW = 0;
    
    if (self.config.indicatorViewWidthEqualToItemWidth) {
        sourceW = sourceBtn.frame.size.width;
        targetW = targetBtn.frame.size.width;
    }
    else {
        sourceW = targetW = _indicatorWidth;
    }
    
    CGFloat widthRange = targetW - sourceW;
    
    CGFloat lineW = sourceW + widthRange * progress;
    
    CGFloat sourceLineOrigin = sourceBtn.center.x - sourceW * 0.5;
    CGFloat targetLineOrigin = targetBtn.center.x - targetW * 0.5;
    
    CGFloat moveTotalX = targetLineOrigin - sourceLineOrigin;
    CGFloat moveX = moveTotalX * progress;
    CGFloat lineOriginX = moveX + sourceLineOrigin;
    
    CGRect lineFrame = self.indicatorView.frame;
    lineFrame.size.width = lineW;
    lineFrame.origin.x = lineOriginX;
    self.indicatorView.frame = lineFrame;
}
/**
 渐变字体颜色
 
 @param progress progress
 @param sourceBtn sourceBtn
 @param targetBtn targetBtn
 */
- (void)gradientTitleColorWithProgress:(double)progress
                             sourceBtn:(UIButton *)sourceBtn
                             targetBtn:(UIButton *)targetBtn
{
    
    //1 颜色变化范围
    WYRGBNumber colorRange = _colorRange;
    
    //2 变化sourceBtn
    WYRGBNumber progeressColor = {_selectColor.red - colorRange.red * progress, _selectColor.green - colorRange.green * progress, _selectColor.blue - colorRange.blue * progress, _selectColor.alpha - colorRange.alpha * progress};
    
    UIColor *sourceColor = [self getColorWithColorNumber:progeressColor];
    [sourceBtn setTitleColor:sourceColor forState:UIControlStateNormal];
    
    //3 变化targetBtn
    WYRGBNumber targetProgressColor = {_normalColor.red + colorRange.red * progress, _normalColor.green + colorRange.green * progress, _normalColor.blue + colorRange.blue * progress, _normalColor.alpha + colorRange.alpha * progress};
    
    UIColor *targetColor = [self getColorWithColorNumber:targetProgressColor];
    [targetBtn setTitleColor:targetColor forState:UIControlStateNormal];
}

/**
 设置mainView的contentOffset
 
 @param offset offset
 */
- (void)resetContentOffset:(CGFloat)offset
{
    CGFloat maxOffset = self.mainView.contentSize.width - self.mainView.frame.size.width;
    
    if (maxOffset < 0) return;
    
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    else {
        if (offset < 0) {
            offset = 0;
        }
    }
    [self.mainView setContentOffset:CGPointMake(offset, 0) animated:YES];
}
/**
 设置mainView的偏移量
 
 @param currentIndex 下标
 */
- (void)setHeaderContentOffsetWithCurrentIndex:(NSInteger)currentIndex
{
    //0.取出当前item
    UIButton *targetBtn = [self getItemWithIndex:currentIndex];
    
    if (targetBtn == nil) return;
    
    //1.处理字体颜色
    if (self.config.gradientTitleColor == NO) {//字体不渐变
        [_currentItem setTitleColor:self.config.normalTitleColor forState:UIControlStateNormal];
        _currentItem = targetBtn;
        [_currentItem setTitleColor:self.config.selectedTitleColor forState:UIControlStateNormal];
    }
    //2.处理无动画的指示器样式
    if (self.config.indicatorStyle != WYPageTitleIndicatorViewStyleNone) {//下划线样式
        if (self.config.indicatorViewScrollAnimation == WYIndicatorScrollAnimationNone) {
            [self resetIndicatorViewOriginWithSender:targetBtn];
        }
    }
    
    //3.记录当前的index
    _currentIndex = currentIndex;
}
/**
 设置对应下标的选中效果
 
 @param currentIndex 下标
 */
- (void)setupSelectedIndex:(NSInteger)currentIndex
{
    UIButton *button = [self getItemWithIndex:currentIndex];
    
    if (button == nil) return;
    
    [self buttonAction:button];
}


/**
 获取对应下标位置的按钮

 @param index 下标
 @return 按钮
 */
- (UIButton *)getItemWithIndex:(NSInteger)index
{
    if (index < 0 || index > self.itemArray.count - 1) {
        return nil;
    }
    if (self.itemArray.count == 0) return nil;
    return self.itemArray[index];
}
/**
 更新指示器的位置
 
 @param sender sender
 */
- (void)resetIndicatorViewOriginWithSender:(UIButton *)sender
{
    CGRect lineFrame = self.indicatorView.frame;
    CGFloat lineW = 0;
    CGFloat originX = 0;
    if (self.config.indicatorViewWidthEqualToItemWidth) {
        lineW = sender.frame.size.width;
        originX = sender.frame.origin.x;
    }
    else {
        if (_indicatorWidth == 0) {
            _indicatorWidth = self.config.indicatorViewWidth;
        }
        lineW = _indicatorWidth;
        originX = sender.center.x - lineW * 0.5;
    }
    lineFrame.size.width = lineW;
    lineFrame.origin.x = originX;
    self.indicatorView.frame = lineFrame;
}
@end
