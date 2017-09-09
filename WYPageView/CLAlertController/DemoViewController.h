//
//  DemoViewController.h
//  WYPageView
//
//  Created by lwy1218 on 2017/9/7.
//
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖保佑                  永无BUG
//          佛曰:
//                  秋名山上行人稀，
//                  常有车手较高低。
//                  如今车道依旧在，
//                  不见当年老司机。

#import <UIKit/UIKit.h>
#import "WYPageView.h"

typedef NS_ENUM(NSInteger, WYCustomIndicatorViewStyle) {
    WYCustomIndicatorViewStyle1 = 0,
    WYCustomIndicatorViewStyle2,
};
@interface DemoViewController : UIViewController

@property (nonatomic , strong) WYPageConfig *config;

@property (nonatomic , assign) WYCustomIndicatorViewStyle customStyle;
@end
