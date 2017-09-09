//
//  UIViewController+CLAlertController.m
//  AlertController
//
//  Created by sethmedia on 16/11/20.
//  Copyright © 2016年 sethmedia. All rights reserved.
//

#import "UIViewController+CLAlertController.h"
#import "CLAlertController.h"

@implementation UIViewController (CLAlertController)




- (void)presentToViewController:(UIViewController *)viewControllerToPresent completion:(void (^)(void))completion {
    
    self.definesPresentationContext = YES;
    viewControllerToPresent.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:viewControllerToPresent animated:NO completion:completion];
    
    
}


- (void)dismissToViewControllerCompletion:(void (^)(void))completion {
    
    [self dismissViewControllerAnimated:NO completion:completion];
}

@end
