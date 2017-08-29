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


@end

@implementation ViewController
- (IBAction)push:(id)sender {
    [self.view endEditing:YES];
    [self nextVc];
}
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
    
    
//    config.forbidContentScroll = YES;
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
    
    
}

@end
