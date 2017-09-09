//
//  CLAlertView.h
//  AlertController
//
//  Created by sethmedia on 16/11/20.
//  Copyright © 2016年 sethmedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLAlertView, CLAlertModel;
;
@protocol CLAlertViewDelegate <NSObject>

- (void)alertView:(CLAlertView *)alertView didSelectActionItem:(CLAlertModel *)action;

@end

@interface CLAlertView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message actions:(NSArray<CLAlertModel *> *)actions;
@property(nonatomic,weak)id<CLAlertViewDelegate> delegate;




@end
