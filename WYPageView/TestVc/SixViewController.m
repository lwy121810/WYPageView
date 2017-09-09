//
//  SixViewController.m
//  WYPageView
//
//  Created by lwy1218 on 2017/8/28.
//
//

#import "SixViewController.h"

@interface SixViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation SixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *iconPath = [resourcePath stringByAppendingPathComponent:@"lwy3.jpg"];
    UIImage *icon = [UIImage imageWithContentsOfFile:iconPath];
    self.iconView.image = icon;
}

- (void)dealloc
{
    
    NSLog(@"dealloc --------------  %@", NSStringFromClass([self class]));
}
@end
