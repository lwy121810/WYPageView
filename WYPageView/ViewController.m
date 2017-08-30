//
//  ViewController.m
//  WYPageView
//
//  Created by lwy1218 on 2017/8/14.
//
//

#import "ViewController.h"
#import "WYPageViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleViewHeightText;
@property (weak, nonatomic) IBOutlet UISwitch *showLine;
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


@property (weak, nonatomic) IBOutlet UISwitch *lineScrollNoneSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *lineScrollValue1Switch;
@property (weak, nonatomic) IBOutlet UISwitch *lineScrollValue2Switch;

@property (nonatomic , assign) WYDownLineScrollAnimation currentAnimation;

@end

@implementation ViewController

- (IBAction)lineAnimationNone:(UISwitch *)sender {
    sender.on = !sender.on;
    if (sender.on) {
        self.currentAnimation = WYDownLineScrollAnimationNone;
        
        self.lineScrollValue1Switch.on = NO;
    }
    else {
        self.lineScrollValue1Switch.on = YES;
        self.currentAnimation = WYDownLineScrollAnimationDefault;
    }
   
    self.lineScrollValue2Switch.on = NO;
}
- (IBAction)lineAnimationValue1:(UISwitch *)sender {
    
    if (self.lineScrollValue2Switch.on == NO && self.lineScrollNoneSwitch.on == NO) {
        sender.on = YES;
        return;
    }
    sender.on = !sender.on;
    
    self.currentAnimation = WYDownLineScrollAnimationDefault;
    
    self.lineScrollNoneSwitch.on = NO;
    self.lineScrollValue2Switch.on = NO;
}

- (IBAction)lineAnimationValue2:(UISwitch *)sender {
    
    sender.on = !sender.on;
    
    if (sender.on) {
        self.currentAnimation = WYDownLineScrollAnimationValue2;
        self.lineScrollValue1Switch.on = NO;
    }
    else {
        
        self.lineScrollValue1Switch.on = YES;
        self.currentAnimation = WYDownLineScrollAnimationDefault;
    }
    
    self.lineScrollNoneSwitch.on = NO;
}



- (IBAction)push:(id)sender {
    [self.view endEditing:YES];
    [self nextVc];
}
#pragma mark - 跳转到下一个页面
- (void)nextVc
{
    WYPageConfig *config = [[WYPageConfig alloc] init];
    //1.是否显示下划线
    config.showLine = self.showLine.on;
    //2.是否可以缩放字体
    config.canZoomTitle = self.zoomTitle.isOn;
    //3.是否渐变字体颜色
    config.gradientTitleColor = self.gradientTitleColor.isOn;
    //4.是否有滚动动画
    config.contentAnimationEnable = self.scrollAnimation.isOn;
    //5.当item的总宽度小于pageView的宽度时，item是否等距分布
    config.equallySpaceWhenItemsWidthLessThanTitleWidth = self.equallySpace.on;
    //6.下划线高度
    config.downLineHeight = [self getNumberWithTextField:self.lineHeightText defaultValue:2];
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
    //17.下划线的颜色
    config.downLineColor = [UIColor redColor];
    
    //18. 动画效果
    config.downLineScrollAnimation = _currentAnimation;
    
    //19. 滑块宽度是否等于标题宽度
    config.downLineWidthEqualToItemWidth = self.lineWidthEqualToItemSwitch.on;
    BOOL isPush = self.isPush.on;
    
    WYPageViewController *vc = [[WYPageViewController alloc] init];
    vc.config = config;
    if (isPush) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        [self presentViewController:vc animated:YES completion:nil];
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
    
    self.lineScrollValue1Switch.on = YES;
    self.lineScrollNoneSwitch.on = NO;
    self.lineScrollValue2Switch.on = NO;
    
    self.lineWidthEqualToItemSwitch.on = NO;
    
    _currentAnimation = WYDownLineScrollAnimationDefault;
}

@end
