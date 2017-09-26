//
//  CLAlertController.m
//  AlertController
//
//  Created by sethmedia on 16/11/20.
//  Copyright © 2016年 sethmedia. All rights reserved.
//

#import "CLAlertController.h"
#import "CLAlertDefaultTableViewCell.h"
#import "CLAlertDestructiveTableViewCell.h"
#import "CLAlertCancelTableViewCell.h"
#import "CLAlertView.h"


#define cellHeight 50
#define sectionHeaderHeight 10

@interface CLAlertController ()<UITableViewDelegate, UITableViewDataSource, CLAlertViewDelegate>

@property(nonatomic, copy) NSString * alertTitle;
@property(nonatomic, copy) NSString * alertMessage;
@property(nonatomic,strong) UILabel * titleLabel;
@property(nonatomic,strong) UILabel * messageLabel;


@property(nonatomic, assign) CLAlertControllerStyle preferredStyle;
@property(nonatomic,strong) UITableView * tableView;

@property(nonatomic,strong) NSMutableArray *itemsGroups;
@property(nonatomic,strong) NSMutableArray * itemActions;
@property(nonatomic,strong) NSMutableArray * cancelActions;
@property(nonatomic,assign) NSInteger itemCount;
@property(nonatomic,strong) UIView * bgView;


@property(nonatomic,strong) CLAlertView * alertView;
@property(nonatomic,strong) NSMutableArray * alertItems;

@end

@implementation CLAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(CLAlertControllerStyle)preferredStyle {
    
    CLAlertController *alert = [[CLAlertController alloc] init];
    alert.alertTitle         = title;
    alert.alertMessage       = message;
    alert.preferredStyle     = preferredStyle;
    return alert;
}

- (NSMutableArray *)itemsGroups {
    
    if (!_itemsGroups) {
        
        _itemsGroups = [[NSMutableArray alloc] init];
        
    }
    return _itemsGroups;
}

- (NSMutableArray *)itemActions {
    
    if (!_itemActions) {
        
        _itemActions = [[NSMutableArray alloc] init];
    }
    return _itemActions;
}

- (NSMutableArray *)cancelActions {
    
    if (!_cancelActions) {
        
        _cancelActions = [[NSMutableArray alloc] init];
    }
    return _cancelActions;
}

- (NSMutableArray *)alertItems {
    
    if (!_alertItems) {
        
        _alertItems = [[NSMutableArray alloc] init];
        
    }
    return _alertItems;
}

- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIEdgeInsets inset = window.safeAreaInsets;
    CGFloat y      = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat height = self.tableView.frame.size.height;
    CGRect frame = self.tableView.frame;
    frame.origin.y = y - height - inset.bottom;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.tableView.frame = frame;
        self.bgView.alpha = 0.2;
    }];
}
- (void)addAction:(CLAlertModel *)action {
    
    self.itemCount ++;
    
    if (self.preferredStyle == CLAlertControllerStyleAlert) {
        
        [self.alertItems addObject:action];
        
    } else {
        if (action.style == CLAlertActionStyleCancel) {
            
            [self.cancelActions addObject:action];
            
        } else {
            
            [self.itemActions addObject:action];
        }
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.itemsGroups addObject:self.itemActions];
    [self.itemsGroups addObject:self.cancelActions];
    
    if (self.preferredStyle == CLAlertControllerStyleSheet ) {
        
        _alertControllerStyle = CLAlertControllerStyleSheet;
        [self setupStyleSheet];
        
    } else if (self.preferredStyle == CLAlertControllerStyleAlert) {
        
        _alertControllerStyle = CLAlertControllerStyleAlert;
        [self setupStyleAlert];
        
    }
    
}

- (void)setupStyleAlert {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.bgView];
    [window addSubview:self.alertView];
    
    CGFloat width = 260.0f/320.0f*[UIScreen mainScreen].bounds.size.width;
    CGFloat height = [self messageHeight]+self.itemCount*cellHeight;
    if (height > [UIScreen mainScreen].bounds.size.height - 40) {
        height = [UIScreen mainScreen].bounds.size.height-40;
    }
    
    if (self.itemCount == 2) {
        height = [self messageHeight] + cellHeight;
    }
    
    
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - width)/2.0f;
    CGFloat Y = ([UIScreen mainScreen].bounds.size.height - height)/2.0f;
    
    CGRect frame = CGRectMake(x, Y, width, height);
    self.alertView.frame = frame;
    self.alertView.center = self.view.center;
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.alpha = 0.2;
        self.alertView.alpha =  1;
    }];
    
    
}



- (void)setupStyleSheet {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.bgView];
    [window addSubview:self.tableView];
    
    CGFloat itemHeight    = self.itemCount*cellHeight;
    CGFloat sectionHeight = (self.itemsGroups.count - 1)*sectionHeaderHeight;
    CGFloat messageHeight = [self messageHeight];
    
    if (self.cancelActions.count == 0) { sectionHeight = 0; }
    
    CGFloat height = itemHeight + sectionHeight + messageHeight;
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    CGFloat x      = 0;
    CGFloat y      = [UIScreen mainScreen].bounds.size.height;
    
    if (height > y) {
        height = y;
    }
    
    
    CGRect frame = CGRectMake(x,y,width,height);
    
    self.tableView.frame = frame;
    frame.origin.y -= height;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.tableView.frame = frame;
        self.bgView.alpha = 0.2;
    }];
    
    
}


- (UIView *)bgView {
    
    if (!_bgView) {
        
        _bgView = [[UIView alloc] initWithFrame:self.view.frame];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [_bgView addGestureRecognizer:tap];
        
    }
    return _bgView;
}

- (void)dismiss:(UITapGestureRecognizer *)tap {
    
    [self close];
    
}

- (void)close {
    
    if (self.preferredStyle == CLAlertControllerStyleSheet) {
        
        [self dissmissSheet];
        
    }
}

- (void)dismissAlert {
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.bgView.alpha = 0;
        self.alertView.alpha = 0.1;
    }completion:^(BOOL finished) {
        
        [self.bgView removeFromSuperview];
        self.bgView = nil;
        [self.alertView removeFromSuperview];
        self.alertView = nil;
        
        [self dismissToViewControllerCompletion:nil];
        
    }];
    
    
    
}



- (void)dissmissSheet {
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.bgView.alpha = 0;
        self.tableView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0);
    }completion:^(BOOL finished) {
        
        [self.bgView removeFromSuperview];
        [self.tableView removeFromSuperview];
        self.bgView = nil;
        self.tableView = nil;
        [self dismissToViewControllerCompletion:nil];
        
    }];
    
}

- (CLAlertView *)alertView {
    
    if (!_alertView) {
        
        _alertView = [[CLAlertView alloc] initWithFrame:CGRectZero title:self.alertTitle message:self.alertMessage actions:self.alertItems];
        _alertView.center = self.view.center;
        _alertView.delegate = self;
        _alertView.alpha = 0.0f;
    }
    
    return _alertView;
}



- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CLAlertCancelTableViewCell class] forCellReuseIdentifier:@"cancel"];
        [_tableView registerClass:[CLAlertDefaultTableViewCell class] forCellReuseIdentifier:@"default"];
        [_tableView registerClass:[CLAlertDestructiveTableViewCell class] forCellReuseIdentifier:@"destructive"];
        _tableView.estimatedSectionFooterHeight = 0;
    }
    
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.itemsGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.itemsGroups[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLAlertModel *model = self.itemsGroups[indexPath.section][indexPath.row];
    
    switch (model.style) {
        case CLAlertActionStyleCancel:
        {
            
            CLAlertCancelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cancel"];
            cell.model = model;
            
            return cell;
        }
            break;
            
        case CLAlertActionStyleDefault:
        {
            CLAlertDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
            cell.model = model;
            return cell;
            
        }
            break;
            
        case CLAlertActionStyleDestructive:
        {
            
            CLAlertDestructiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"destructive"];
            cell.model = model;
            return cell;
            
        }
            break;
            
        default:
            break;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CLAlertModel *action = self.itemsGroups[indexPath.section][indexPath.row];
    
    if (action.action) {
        action.action(action);
    }
    
    [self close];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return cellHeight;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0)                  { return [self messageHeight]; }
    if (self.cancelActions.count == 0) { return 0.01; }
    
    return sectionHeaderHeight;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        if (!isEmptyString(self.alertTitle)) {
            
            [view addSubview:self.titleLabel];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_titleLabel]-30-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
            
        }
        
        if (!isEmptyString(self.alertMessage)) {
            [view addSubview:self.messageLabel];
            
            if (isEmptyString(self.alertTitle)) {
                
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_messageLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLabel)]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_messageLabel]-30-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLabel)]];
                
            } else {
                
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel][_messageLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLabel,_titleLabel)]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_messageLabel]-30-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLabel)]];
            }
        }
        
        if (!isEmptyString(self.alertTitle) || !isEmptyString(self.alertMessage)) {
            
            UIView *lineView = [[UIView alloc] init];
            [view addSubview:lineView];
            lineView.backgroundColor = tableView.separatorColor;
            lineView.translatesAutoresizingMaskIntoConstraints = NO;
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView(0.5)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lineView)]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lineView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lineView)]];
            
        }
        
        
        return view;
        
        
        
    }
    
    return nil;
    
}


BOOL isEmptyString(NSString *string) {
    
    return string.length?NO:YES;
    
}

- (CGFloat)messageHeight {
    
    if (self.preferredStyle == CLAlertControllerStyleAlert) {
        
        CGFloat titleHeight = 0.01;
        if (!isEmptyString(self.alertTitle)) { titleHeight = 48;}
        CGFloat width = 260.0f/320.0f*[UIScreen mainScreen].bounds.size.width;
        
        CGSize size                    = CGSizeMake(width-40, MAXFLOAT);
        
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin|
        NSStringDrawingUsesFontLeading;
        
        NSDictionary *attributes       = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        
        CGFloat messageHeight = [self.alertMessage boundingRectWithSize:size
                                                                options:options
                                                             attributes:attributes
                                                                context:nil].size.height;
        CGFloat space = 10;
        
        
        if (!isEmptyString(self.alertMessage)) {  return titleHeight + messageHeight + space; }
        
        return titleHeight;
        
        
        
    }
    
    CGFloat titleHeight = 0.01;
    if (!isEmptyString(self.alertTitle)) { titleHeight = 30;}
    
    CGSize size                    = CGSizeMake([UIScreen mainScreen].bounds.size.width - 60, MAXFLOAT);
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin|
    NSStringDrawingUsesFontLeading;
    
    NSDictionary *attributes       = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    
    CGFloat messageHeight = [self.alertMessage boundingRectWithSize:size
                                                            options:options
                                                         attributes:attributes
                                                            context:nil].size.height;
    CGFloat space = 10;
    
    
    if (!isEmptyString(self.alertMessage)) {  return titleHeight + messageHeight + space; }
    
    return titleHeight;
    
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.text = self.alertTitle;
    }
    return _titleLabel;
    
}


- (UILabel *)messageLabel {
    
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:12];
        _messageLabel.textColor = [UIColor grayColor];
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _messageLabel.text = self.alertMessage;
        _messageLabel.numberOfLines = 0.0;
    }
    
    return _messageLabel;
}


- (void)alertView:(CLAlertView *)alertView didSelectActionItem:(CLAlertModel *)action {
    
    [self dismissAlert];
    
    
}


// 看内存是否释放
- (void)dealloc {
    
#if DEBUG
    NSLog(@"界面已经释放");
#endif
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

