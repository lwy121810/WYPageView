//
//  ThreeViewController.m
//  WYPageController
//
//  Created by lwy1218 on 2017/8/17.
//  Copyright © 2017年 eastraycloud. All rights reserved.
//

#import "ThreeViewController.h"

@interface ThreeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation ThreeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"viewDidLoad >>>>>>>>>>>>>>>>>> %@", NSStringFromClass([self class]));
    
    self.iconView.image = kLocalImage(@"lwy1.jpeg");
    
}

- (void)dealloc
{
    
    _iconView.image = nil;
    _iconView = nil;
    NSLog(@"dealloc --------------  %@", NSStringFromClass([self class]));
}
- (IBAction)buttonAction:(id)sender {
    NSLog(@"buttonAction -- ");
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear =================== %@", NSStringFromClass([self class]));
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear ***************  %@", NSStringFromClass([self class]));
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
