//
//  WYNavHeaderView.m
//  NavDemo
//
//  Created by lwy1218 on 2017/8/9.
//  Copyright © 2017年 lwy1218. All rights reserved.
//

#import "WYPageTitleView.h"
#import "WYPageConfig.h"

typedef struct {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    BOOL isRGB;
}WYRGBNumber;

@interface WYPageTitleView ()
{
    NSInteger _currentIndex;
    UIButton *_currentItem;
}

/**
 下滑块
 */
@property (nonatomic  , weak) UIView *downLine;

/**
 scrollView
 */
@property (nonatomic , strong) UIScrollView *mainView;

/**
 存放item的数组
 */
@property (nonatomic , strong) NSMutableArray <UIButton *>* itemArray;

/**
 标题数组
 */
@property (nonatomic , strong) NSArray<NSString *> *titles;

/**
 选中的字体颜色rgb值
 */
@property (nonatomic , assign) WYRGBNumber selectColor;


/**
 normal状态下字体颜色rgb值
 */
@property (nonatomic , assign) WYRGBNumber normalColor;

/**
 字体颜色变化范围
 */
@property (nonatomic , assign) WYRGBNumber colorRange;

@property (nonatomic , strong) WYPageConfig *config;

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
- (UIView *)downLine
{
    if (!_downLine) {
        UIView *view = [[UIView alloc] init];
        [self.mainView addSubview:view];
        view.backgroundColor = self.config.downLineColor;
        self.downLine = view;
    }
    return _downLine;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles config:(WYPageConfig *)config
{
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        if (config == nil) {
            config = [[WYPageConfig alloc] init];
        }
        self.config = config;
        [self setupDefaultValue];
        [self setupUI];
    }
    return self;
}
/**
 初始化

 @param frame frame
 @param titles 标题数组
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles
{
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
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
    _currentIndex = 0;
    
    if (self.config.gradientTitleColor) {//字体颜色渐变
//        WYRGBNumber selectedColor = [self getRGBWithColor:self.config.selectedTitleColor];
//        WYRGBNumber normalColor = [self getRGBWithColor:self.config.normalTitleColor];
        WYRGBNumber selectedColor = [self getRGBColor:self.config.selectedTitleColor];
        WYRGBNumber normalColor = [self getRGBColor:self.config.normalTitleColor];
        if (selectedColor.isRGB == NO) {//转化rgb失败
            selectedColor = (WYRGBNumber){1.0, 128 / 255.0, 0.0, YES};
        }
        if (normalColor.isRGB == NO) {
            CGFloat num = 85 / 255.0;
            normalColor = (WYRGBNumber){num, num, num, YES};
        }
        
        self.selectColor = selectedColor;
        self.normalColor = normalColor;
        
        //计算变化范围
        WYRGBNumber colorRange = {_selectColor.red - _normalColor.red,_selectColor.green - _normalColor.green,_selectColor.blue - _normalColor.blue};
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
    return [UIColor colorWithRed:rgb.red green:rgb.green blue:rgb.blue alpha:1];
}

/**
 根据颜色获取rgb值 此方法只能获取rgb空间的颜色值，其他的获取不到（grayColor），因此改用下面的方法

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
//    if (self.config.onDebug) {
//         NSAssert(NO, @"WYPageTitleView==========>>>>>>>>设置字体颜色时应该使用具有rgb颜色空间的color");
//    }
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
    
    return (WYRGBNumber){red,green,blue, YES};
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
- (void)setupUI
{
    if (self.titles == nil || self.titles.count == 0) return;
    
    self.mainView.frame = self.bounds;
    
    CGFloat firstX = self.config.titleEdgeItemDistanceOfView;
    CGFloat h = self.bounds.size.height;
    if (self.config.showLine) {
        h = self.bounds.size.height - self.config.downLineHeight;
    }
    CGFloat y = 0;
    CGFloat itemMargin = self.config.titleMargin;
    
    __block UIButton *lastView = nil;
    
    __block CGFloat itemTotalWidth = 0.0;
    
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //0.计算宽度
        CGFloat w = [self getTitleWidth:obj];
        //1.创建
        UIButton *button = [self createButtonWithTitle:obj tag:(idx + 1000)];
        //2.设置frame
        if (lastView == nil) {
            button.frame = CGRectMake(firstX, y, w, h);
        }
        else {
            CGFloat x = CGRectGetMaxX(lastView.frame) + itemMargin;
            button.frame = CGRectMake(x, y, w, h);
        }
        //3.添加到view
        [self.mainView addSubview:button];
        //4.设置背景颜色
        if (self.config.titleItemBackgroundColor) {
            button.backgroundColor = self.config.titleItemBackgroundColor;
        }
        //5.处理选中状态
        if(idx == 0) {
            //1.设置选中状态字体颜色
            [button setTitleColor:self.config.selectedTitleColor forState:UIControlStateNormal];
            //2.记录当前item
            if (self.config.gradientTitleColor == NO) {//字体颜色不渐变
                _currentItem = button;
            }
            //3.放大字体
            if (self.config.canZoomTitle) {
                CGFloat zoom = self.config.titleZoomMultiple;
                button.transform = CGAffineTransformMakeScale(zoom, zoom);
            }
        }
        //6.计算总宽度
        itemTotalWidth += button.frame.size.width;
        //7.赋值
        lastView = button;
        //8.添加进数组
        [self.itemArray addObject:button];
    }];
    
    if (self.config.showLine) {//显示滑块
        self.downLine.frame = CGRectMake(firstX, self.bounds.size.height - self.config.downLineHeight, self.itemArray.firstObject.frame.size.width, self.config.downLineHeight);
    }
    
    if (self.config.canZoomTitle && self.config.showLine) {
        [self resetDownLineWithSender:self.itemArray.firstObject];
    }
  
    CGFloat contentW = CGRectGetMaxX(lastView.frame) + firstX;
    //设置等距分布
    if (self.config.equallySpaceWhenItemsWidthLessThanTitleWidth) {
        if (contentW < self.mainView.frame.size.width) {
            
            CGFloat residue = self.mainView.frame.size.width - itemTotalWidth - self.itemArray.firstObject.frame.origin.x - firstX;
            
            CGFloat margin = residue / (self.itemArray.count - 1);
            
            [self resetItemMargin:margin];
        }
    }
    self.mainView.contentSize = CGSizeMake(contentW, 0);
    
    self.mainView.backgroundColor = self.config.titleViewBackgroundColor;
    self.backgroundColor = self.config.titleViewBackgroundColor;
}

/**
 重新设置item的间距

 @param margin 间距
 */
- (void)resetItemMargin:(CGFloat)margin
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
    //1.取出下标
    NSInteger index = sender.tag - 1000;
    //2.点击的同一个 直接返回
    if (index == _currentIndex) return;
    //3.取出上一个按钮
    UIButton *oldBtn = self.itemArray[_currentIndex];
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
    //6.变化字体
    if (self.config.canZoomTitle) {
        CGFloat zoom = self.config.titleZoomMultiple;
        NSTimeInterval duration = self.config.titleAnimationDuration;
        [UIView animateWithDuration:duration animations:^{
            oldBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            sender.transform = CGAffineTransformMakeScale(zoom, zoom);
        }];
    }
    //7. 调整滑块位置
    if (self.config.showLine) {
        NSTimeInterval duration = self.config.titleAnimationDuration;
        if (self.config.canZoomTitle) {
            [UIView animateWithDuration:duration animations:^{
                [self resetDownLineWithSender:sender];
            }];
        }
        else {
            [UIView animateWithDuration:duration animations:^{
                 [self resetDownLineWithSender:sender];
            }];
        }
    }
    //8.记录当前item
    if (self.config.gradientTitleColor == NO) {//不渐变字体颜色
        _currentItem = sender;
    }
    //9.记录当前item的index
    _currentIndex = index;
    
    //10. 代理
    if (_delegate && [_delegate respondsToSelector:@selector(pageTitleView:selectdIndexItem:)]) {
        [_delegate pageTitleView:self selectdIndexItem:_currentIndex];
    }
}

/**
 清除内容
 */
- (void)clearData
{
    [self.itemArray removeAllObjects];
    [self.mainView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.titles = nil;
    if (_downLine) {
        _downLine = nil;
    }
    _currentIndex = 0;
    _currentItem = nil;
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
 设置item的title

 @param progress 翻页进度
 @param sourceIndex 源index
 @param targetIndex 目标index
 */
- (void)setTitleWithProgress:(double)progress
                 sourceIndex:(NSInteger)sourceIndex
                 targetIndex:(NSInteger)targetIndex

{
    //1.取出btn
    UIButton *sourceBtn = self.itemArray[sourceIndex];
    UIButton *targetBtn = self.itemArray[targetIndex];
    
    //2.处理字体颜色
    if (self.config.gradientTitleColor) {//渐变字体颜色
        [self gradientTitleColorWithProgress:progress sourceBtn:sourceBtn targetBtn:targetBtn];
    }
    
    
    //3.处理滑块
    if (self.config.showLine) {
        [self zoomDownLineWithProgress:progress sourceBtn:sourceBtn targetBtn:targetBtn];
    }
    
    //4.处理字体大小
    if (self.config.canZoomTitle) {//字体缩放
        [self zoomTitleWithProgress:progress sourceBtn:sourceBtn targetBtn:targetBtn];
    }
    
    //5.记录最新的index
    _currentIndex = targetIndex;
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
    CGFloat sourceZoom = self.config.titleZoomMultiple - zoomRange * progress;
    sourceBtn.transform = CGAffineTransformMakeScale(sourceZoom, sourceZoom);
    
    CGFloat targetZoom = 1.0 + zoomRange * progress;
    targetBtn.transform = CGAffineTransformMakeScale(targetZoom, targetZoom);
}

/**
 缩放移动滑块

 @param progress progress
 @param sourceBtn sourceBtn
 @param targetBtn targetBtn
 */
- (void)zoomDownLineWithProgress:(double)progress
                       sourceBtn:(UIButton *)sourceBtn
                       targetBtn:(UIButton *)targetBtn
{
    
    CGFloat sourceW = sourceBtn.frame.size.width;
    CGFloat targetW = targetBtn.frame.size.width;
    
    CGFloat widthRange = targetW - sourceW;
    
    CGFloat progressW = sourceW + widthRange * progress;
    
    CGFloat moveTotalX = targetBtn.frame.origin.x - sourceBtn.frame.origin.x;
    CGFloat moveX = moveTotalX * progress;
    CGFloat currentLineX = moveX + sourceBtn.frame.origin.x;
    
    CGRect lineFrame = self.downLine.frame;
    lineFrame.size.width = progressW;
    lineFrame.origin.x = currentLineX;
    self.downLine.frame = lineFrame;
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
    WYRGBNumber progeressColor = {_selectColor.red - colorRange.red * progress, _selectColor.green - colorRange.green * progress, _selectColor.blue - colorRange.blue * progress};
    
    UIColor *sourceColor = [self getColorWithColorNumber:progeressColor];
    [sourceBtn setTitleColor:sourceColor forState:UIControlStateNormal];
    
    //3 变化targetBtn
    WYRGBNumber targetProgressColor = {_normalColor.red + colorRange.red * progress, _normalColor.green + colorRange.green * progress, _normalColor.blue + colorRange.blue * progress};
    
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
    UIButton *targetBtn = self.itemArray[currentIndex];
    
    //1.处理mainView的偏移量
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
    
    //2.处理字体颜色
    if (self.config.gradientTitleColor == NO) {//字体不渐变
        [_currentItem setTitleColor:self.config.normalTitleColor forState:UIControlStateNormal];
        _currentItem = targetBtn;
        [_currentItem setTitleColor:self.config.selectedTitleColor forState:UIControlStateNormal];
    }
}
/**
 更新滑块的位置

 @param sender sender
 */
- (void)resetDownLineWithSender:(UIButton *)sender
{
    CGRect lineFrame = self.downLine.frame;
    lineFrame.size.width = sender.frame.size.width;
    lineFrame.origin.x = sender.frame.origin.x;
    self.downLine.frame = lineFrame;
}
@end
