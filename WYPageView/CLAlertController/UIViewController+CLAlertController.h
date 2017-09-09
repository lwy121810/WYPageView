//
//  UIViewController+CLAlertController.h
//  AlertController
//
//  Created by sethmedia on 16/11/20.
//  Copyright © 2016年 sethmedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CLAlertController)

- (void)presentToViewController:(UIViewController *)viewControllerToPresent
                     completion:(void (^)(void))completion;


- (void)dismissToViewControllerCompletion:(void (^)(void))completion;


@end
