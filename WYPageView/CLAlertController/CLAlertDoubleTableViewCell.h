//
//  CLAlertDoubleTableViewCell.h
//  AlertController
//
//  Created by sethmedia on 16/11/20.
//  Copyright © 2016年 sethmedia. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CLAlertDoubleDelegate <NSObject>

- (void)alertDoubleDidSelect:(NSInteger)flag;

@end

@class CLAlertModel;
@interface CLAlertDoubleTableViewCell : UITableViewCell

@property(nonatomic,strong) NSArray <CLAlertModel *> * models;
@property(nonatomic,weak)id<CLAlertDoubleDelegate > delegate;

@end
