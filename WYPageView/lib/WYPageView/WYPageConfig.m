//
//  WYPageConfig.m
//  WYPageController
//
//  Created by lwy1218 on 2017/8/10.
//  Copyright © 2017年 lwy1218. All rights reserved.
//

#import "WYPageConfig.h"

@implementation WYPageConfig

- (instancetype)init {
    if(self = [super init]) {
        
        self.showLine = YES;
        
        self.downLineHeight = 2;
        
        self.downLineColor = [UIColor redColor];
        
        self.titleMargin = 15;
        
        self.titleFont = [UIFont systemFontOfSize:14];
        
        self.titleAnimationEnable = YES;
        
        self.titleAnimationDuration = 0.25;
        
        self.canZoomTitle = NO;
        
        self.titleZoomMultiple = 1.3;
        
        self.normalTitleColor = RGB(85, 85, 85);
        
        self.selectedTitleColor = RGB(255, 128, 0);
        
        self.titleViewHeight = 44.0;
        
        self.gradientTitleColor = YES;
        
        self.paginationScale = 0.5;
        
        self.contentAnimationEnable = YES;
        
        self.titleEdgeItemDistanceOfView = 15;
        
        self.titleViewBackgroundColor = [UIColor whiteColor];
        
        self.autoCalculateTitleItemWidth = YES;
        
        self.itemWidth = 80.f;
    }
    return self;
}

@end
