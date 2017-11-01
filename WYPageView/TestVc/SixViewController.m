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
    
    
    self.iconView.image = kLocalImage(@"lwy3.jpg");
}

- (void)dealloc
{
    
    NSLog(@"dealloc --------------  %@", NSStringFromClass([self class]));
}
@end
