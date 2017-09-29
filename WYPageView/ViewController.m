//
//  ViewController.m
//  WYPageView
//
//  Created by lwy1218 on 2017/8/14.
//
//

#import "ViewController.h"
#import "DemoViewController.h"
#import "CLAlertController.h"
#import "NavViewController.h"


#define kIndicatorScrollAnimation @{\
@"无动画":@(WYIndicatorScrollAnimationNone),\
@"动画一":@(WYIndicatorScrollAnimationValue1),\
@"动画二":@(WYIndicatorScrollAnimationValue2),\
@"自定义动画":@(WYIndicatorScrollAnimationCustom)}

#define kIndicatorStyle @{\
@"无指示器":@(WYPageTitleIndicatorViewStyleNone),\
@"下划线样式":@(WYPageTitleIndicatorViewStyleDownLine),\
@"自定义样式1":@(WYPageTitleIndicatorViewStyleCustom),\
@"自定义样式2(小红点)":@(WYPageTitleIndicatorViewStyleCustom)}

#define kIndicatorPosition @{\
@"下方":@(WYPageTitleIndicatorViewPositionStyleBottom),\
@"上面":@(WYPageTitleIndicatorViewPositionStyleTop),\
@"中间":@(WYPageTitleIndicatorViewPositionStyleCenter)}



@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleViewHeightText;
@property (weak, nonatomic) IBOutlet UISwitch *zoomTitle;
@property (weak, nonatomic) IBOutlet UISwitch *gradientTitleColor;
@property (weak, nonatomic) IBOutlet UISwitch *scrollAnimation;
@property (weak, nonatomic) IBOutlet UISwitch *equallySpace;
@property (weak, nonatomic) IBOutlet UITextField *lineHeightText;
@property (weak, nonatomic) IBOutlet UITextField *titleMarginText;
@property (weak, nonatomic) IBOutlet UITextField *titleFontText;
@property (weak, nonatomic) IBOutlet UITextField *zoomScaleText;

@property (weak, nonatomic) IBOutlet UITextField *paginationText;
@property (weak, nonatomic) IBOutlet UITextField *animatedDurationText;

@property (weak, nonatomic) IBOutlet UISwitch *isPush;

@property (weak, nonatomic) IBOutlet UISwitch *lineWidthEqualToItemSwitch;

@property (weak, nonatomic) IBOutlet UITextField *defaultSelectedIndexTextField;

@property (weak, nonatomic) IBOutlet UIButton *positionButton;
@property (nonatomic , assign) WYIndicatorScrollAnimation currentAnimation;
@property (nonatomic , assign) WYPageTitleIndicatorViewStyle currentIndicatorStyle;
@property (nonatomic , assign) WYPageTitleIndicatorViewPositionStyle currentPosition;
@property (nonatomic , assign) WYCustomIndicatorViewStyle customStyle;
@end

@implementation ViewController

- (IBAction)indicatorStyle:(UIButton *)sender {
    [self showAlertWithTitle:@"指示器类型" index:1 sender:sender];
}
- (IBAction)setPosition:(UIButton *)sender {
    [self showAlertWithTitle:@"指示器位置" index:2 sender:sender];
}

- (IBAction)setScrollStyle:(UIButton *)sender {
    [self showAlertWithTitle:@"指示器动画" index:3 sender:sender];
}

- (IBAction)pushToNavController:(id)sender {
    [self.view endEditing:YES];
    [self nextVcIsDemo:NO];
}

- (IBAction)push:(id)sender {
    [self.view endEditing:YES];
    [self nextVcIsDemo:YES];
}
#pragma mark - 跳转到下一个页面
- (void)nextVcIsDemo:(BOOL)isDemo
{
    WYPageConfig *config = [[WYPageConfig alloc] init];
    //1.指示器类型
    config.indicatorStyle = _currentIndicatorStyle;
    //2.是否可以缩放字体
    config.canZoomTitle = self.zoomTitle.isOn;
    //3.是否渐变字体颜色
    config.gradientTitleColor = self.gradientTitleColor.isOn;
    //4.是否有滚动动画
    config.contentAnimationEnable = self.scrollAnimation.isOn;
    //5.当item的总宽度小于pageView的宽度时，item是否等距分布
    config.equallySpaceWhenItemsWidthLessThanTitleWidth = self.equallySpace.on;
    //6.指示器高度
    config.indicatorViewHeight = [self getNumberWithTextField:self.lineHeightText defaultValue:2];
    //7.标题间隔
    config.titleMargin = [self getNumberWithTextField:self.titleMarginText defaultValue:15];
    //8.字体大小
    CGFloat size = [self getNumberWithTextField:self.titleFontText defaultValue:14];
    config.titleFont = [UIFont systemFontOfSize:size];
    //9.字体放大倍数
    config.titleZoomMultiple = [self getNumberWithTextField:self.zoomScaleText defaultValue:1.3];
    //10.titleView的高度
    config.titleViewHeight = [self getNumberWithTextField:self.titleViewHeightText defaultValue:44];
    //11.titlView开始偏移的位置与titleView宽度的比例
    config.paginationScale = [self getNumberWithTextField:self.paginationText defaultValue:0.5];
    
    //12.标题未选中的字体颜色
    config.normalTitleColor = [UIColor blackColor];
    //13.标题选中之后的字体颜色
    config.selectedTitleColor = [UIColor redColor];
    //14.边缘标题距离titleView的间距
    config.titleEdgeItemDistanceOfView = 15;
    //15.标题按钮的背景颜色
//    config.titleItemBackgroundColor = [UIColor cyanColor];
    //16.titleView的背景颜色
//    config.titleViewBackgroundColor = [UIColor brownColor];
    //17.指示器的颜色
    config.indicatorViewColor = [UIColor redColor];
    
    //18. 动画效果
    config.indicatorViewScrollAnimation = _currentAnimation;
    
    //19. 指示器位置
    config.indicatorPositionStyle = _currentPosition;
    
    //20. 滑块宽度是否等于标题宽度
    config.indicatorViewWidthEqualToItemWidth = self.lineWidthEqualToItemSwitch.on;
    
    config.defaultSelectedIndex = [self getNumberWithTextField:self.defaultSelectedIndexTextField defaultValue:0];
    
    BOOL isPush = self.isPush.on;
    if (isDemo) {
        DemoViewController *vc = [[DemoViewController alloc] init];
        vc.config = config;
        vc.customStyle = _customStyle;
        if (isPush) {
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    else {
        NavViewController *vc = [[NavViewController alloc] init];
        vc.config = config;
        vc.customStyle = _customStyle;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CGFloat)getNumberWithTextField:(UITextField *)textField defaultValue:(CGFloat)defaultValue
{
    NSString *text = textField.text;
    return text ? [text floatValue] : defaultValue;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    _currentAnimation = WYIndicatorScrollAnimationValue1;
    _currentPosition = WYPageTitleIndicatorViewPositionStyleBottom;
    _currentIndicatorStyle = WYPageTitleIndicatorViewStyleDownLine;
}

- (void)showAlertWithTitle:(NSString *)title index:(NSInteger)index sender:(UIButton *)sender
{
    NSArray *titles = nil;
    switch (index) {
        case 1:
        {
            titles = [kIndicatorStyle allKeys];
        }
            break;
        case 2:
        {
            
            titles = [kIndicatorPosition allKeys];
        }
            break;
        case 3:
        {
            titles = [kIndicatorScrollAnimation allKeys];
        }
            break;
            
        default:
            break;
    }
    [self presentCLSheetVcWithTitle:title itemTitles:titles action:^(NSInteger itemIndex, NSString *actionTitle) {
        [sender setTitle:actionTitle forState:UIControlStateNormal];
        switch (index) {
            case 1:// 类型
            {
                _currentIndicatorStyle = [[kIndicatorStyle valueForKey:actionTitle] integerValue];
                if (_currentIndicatorStyle == WYPageTitleIndicatorViewStyleCustom) {
                    if ([actionTitle isEqualToString:@"自定义样式1"]) {
                        _customStyle = WYCustomIndicatorViewStyle1;
                        self.lineWidthEqualToItemSwitch.on = YES;
                        _currentPosition = WYPageTitleIndicatorViewPositionStyleCenter;
                        [_positionButton setTitle:@"中间" forState:UIControlStateNormal];
                    }
                    else {//小红点模式
                       _customStyle = WYCustomIndicatorViewStyle2;
                        self.lineWidthEqualToItemSwitch.on = NO;
                    }
                    
                }
            }
                break;
            case 2:// 位置
            {
                _currentPosition = [[kIndicatorPosition valueForKey:actionTitle] integerValue];
              
            }
                break;
            case 3:// 动画
            {
                
                _currentAnimation = [[kIndicatorScrollAnimation valueForKey:actionTitle] integerValue];
            }
                break;
                
            default:
                break;
        }
    }];
}

- (void)presentCLSheetVcWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles action:(void(^)(NSInteger index, NSString *actionTitle))actionBlock
{
    if (itemTitles == nil || itemTitles.count == 0) return;
    
    CLAlertController *alert = [CLAlertController alertControllerWithTitle:title message:nil preferredStyle:CLAlertControllerStyleSheet];
    for (int i = 0; i < itemTitles.count; i++) {
        NSString *itemTitle = itemTitles[i];
        CLAlertModel *action = [CLAlertModel actionWithTitle:itemTitle style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
            if (actionBlock) {
                actionBlock(i, itemTitle);
            }
        }];
        [alert addAction:action];
    }
    [alert addAction:[CLAlertModel actionWithTitle:@"取消" style:CLAlertActionStyleCancel handler:^(CLAlertModel *action) {
        
    }]];
    [self presentToViewController:alert completion:nil];
}
@end
