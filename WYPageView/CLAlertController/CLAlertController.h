//
//  CLAlertController.h
//  AlertController
//
//  Created by sethmedia on 16/11/20.
//  Copyright © 2016年 sethmedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLAlertModel.h"
#import "UIViewController+CLAlertController.h"


typedef NS_ENUM(NSInteger, CLAlertControllerStyle) {
    
    CLAlertControllerStyleSheet = 0,
    CLAlertControllerStyleAlert
};



@interface CLAlertController : UIViewController


@property(nonatomic,assign, readonly)  CLAlertActionStyle actionStyle;
@property(nonatomic,assign, readonly)  CLAlertControllerStyle alertControllerStyle;



+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                          preferredStyle:(CLAlertControllerStyle)preferredStyle;

- (void)addAction:(CLAlertModel *)action;


@end
