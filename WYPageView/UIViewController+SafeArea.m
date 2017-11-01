//
//  UIViewController+SafeArea.m
//  WYPageView
//
//  Created by lwy1218 on 2017/10/30.
//

#import "UIViewController+SafeArea.h"

@implementation UIViewController (SafeArea)
- (void)setupFullFrameWithView:(UIView *)subview
{
    if (subview == nil) return;
    if (subview.superview != self.view) {
        return;
    }
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets =  self.view.safeAreaInsets;
        CGRect frame = self.view.frame;
        frame.origin.x = safeAreaInsets.left;
        frame.origin.y = safeAreaInsets.top;
        frame.size.width -= safeAreaInsets.left + safeAreaInsets.right;
        frame.size.height -= safeAreaInsets.top + safeAreaInsets.bottom;
        subview.frame = frame;
    } else {
        // Fallback on earlier versions
        subview.frame = self.view.bounds;
    }
}
@end
