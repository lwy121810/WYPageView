//
//  CLAlertModel.m
//  AlertController
//
//  Created by sethmedia on 16/11/20.
//  Copyright © 2016年 sethmedia. All rights reserved.
//

#import "CLAlertModel.h"



@implementation CLAlertModel

+ (instancetype)actionWithTitle:(NSString *)title
                          style:(CLAlertActionStyle)style
                        handler:(void (^)(CLAlertModel *))handler {
    
    CLAlertModel *model = [[CLAlertModel alloc] initWithTitle:title style:style handler:handler];
    return model;
}


- (instancetype)initWithTitle:(NSString *)title style:(CLAlertActionStyle)style handler:(void (^)(CLAlertModel *))handler
{
    self = [super init];
    if (self) {
        
        _title = title;
        _style = style;
        _action = handler;
        
    }
    return self;
}


@end
