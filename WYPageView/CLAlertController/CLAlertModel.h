//
//  CLAlertModel.h
//  AlertController
//
//  Created by sethmedia on 16/11/20.
//  Copyright © 2016年 sethmedia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CLAlertActionStyle) {
    
    CLAlertActionStyleDefault = 0,
    CLAlertActionStyleCancel,
    CLAlertActionStyleDestructive
    
};


@interface CLAlertModel : NSObject


@property(nonatomic,copy, readonly) NSString * title;
@property(nonatomic,assign, readonly) CLAlertActionStyle style;
@property(nonatomic,copy, readonly) void (^action)(CLAlertModel *action);

+ (instancetype)actionWithTitle:(NSString *)title
                          style:(CLAlertActionStyle)style
                        handler:(void (^)(CLAlertModel *action))handler;


@end
