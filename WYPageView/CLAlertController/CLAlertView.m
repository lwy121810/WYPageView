//
//  CLAlertView.m
//  AlertController
//
//  Created by sethmedia on 16/11/20.
//  Copyright © 2016年 sethmedia. All rights reserved.
//

#import "CLAlertView.h"
#import "CLAlertModel.h"
#import "CLAlertCancelTableViewCell.h"
#import "CLAlertDefaultTableViewCell.h"
#import "CLAlertDestructiveTableViewCell.h"
#import "CLAlertDoubleTableViewCell.h"


@interface CLAlertView ()<UITableViewDelegate, UITableViewDataSource, CLAlertDoubleDelegate>

@property(nonatomic,strong) UIView * whiteBgView;
@property(nonatomic,strong) UITableView * alertTableView;


@property(nonatomic, copy) NSString * alertTitle;
@property(nonatomic, copy) NSString * alertMessage;
@property(nonatomic,strong) UILabel * titleLabel;
@property(nonatomic,strong) UILabel * messageLabel;

@property(nonatomic,strong) NSMutableArray * itemActions;

@end


@implementation CLAlertView


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message actions:(NSArray<CLAlertModel *> *)actions {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.alertTitle = title;
        self.alertMessage = message;
        
        self.itemActions = [NSMutableArray arrayWithArray:actions];
        [self setup];
        
    }
    return self;
}


- (void)setup {
    
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    [self setupTableView];
}

- (void)removeAllViews {
    
    [self.whiteBgView removeFromSuperview];
    self.whiteBgView = nil;
    
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    [self reload];
    
}


- (void)reload {
    
    [self removeAllViews];
    [self setup];
}

- (UIView *)whiteBgView {
    
    if (!_whiteBgView) {
        
        _whiteBgView = [[UIView alloc] init];
        _whiteBgView.backgroundColor = [UIColor whiteColor];
        _whiteBgView.frame = self.bounds;
        _whiteBgView.alpha = 0.93;
    }
    
    return _whiteBgView;
}

- (void)setupTableView {
    
    [self addSubview:self.alertTableView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_alertTableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_alertTableView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_alertTableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_alertTableView)]];
    
}



- (UITableView *)alertTableView {
    
    if (!_alertTableView) {
        
        _alertTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _alertTableView.delegate = self;
        _alertTableView.dataSource = self;
        _alertTableView.bounces = NO;
        _alertTableView.showsVerticalScrollIndicator = NO;
        _alertTableView.showsHorizontalScrollIndicator = NO;
        _alertTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_alertTableView registerClass:[CLAlertCancelTableViewCell class] forCellReuseIdentifier:@"cancel"];
        [_alertTableView registerClass:[CLAlertDefaultTableViewCell class] forCellReuseIdentifier:@"default"];
        [_alertTableView registerClass:[CLAlertDestructiveTableViewCell class] forCellReuseIdentifier:@"destructive"];
        [_alertTableView registerClass:[CLAlertDoubleTableViewCell class] forCellReuseIdentifier:@"double"];
        
        _alertTableView.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    
    return _alertTableView;
}

- (NSMutableArray *)itemActions {
    
    if (!_itemActions) {
        
        _itemActions = [[NSMutableArray alloc] init];
    }
    return _itemActions;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.itemActions.count == 2) {
        return 1;
    }
    
    return self.itemActions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLAlertModel *model = self.itemActions[indexPath.row];
    
    if (self.itemActions.count == 2) {
        
        CLAlertDoubleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"double"];
        cell.delegate = self;
        cell.models = self.itemActions;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else {
        
        
        
        
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
        
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CLAlertModel *action = self.itemActions[indexPath.row];
    
    if (action.action) {
        action.action(action);
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:didSelectActionItem:)]) {
        
        [_delegate alertView:self didSelectActionItem:action];
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return [self messageHeight];
        
    }
    
    return 0.01;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        if (!isEmpty(self.alertTitle)) {
            
            [view addSubview:self.titleLabel];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel(48)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_titleLabel]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
            
        }
        
        if (!isEmpty(self.alertMessage)) {
            [view addSubview:self.messageLabel];
            
            if (isEmpty(self.alertTitle)) {
                
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_messageLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLabel)]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_messageLabel]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLabel)]];
                
            } else {
                
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel][_messageLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLabel,_titleLabel)]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_messageLabel]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLabel)]];
            }
        }
        
        if (!isEmpty(self.alertTitle) || !isEmpty(self.alertMessage)) {
            
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


BOOL isEmpty(NSString *string) {
    
    return string.length?NO:YES;
    
}

- (CGFloat)messageHeight {
    
    CGFloat titleHeight = 0.01;
    if (!isEmpty(self.alertTitle)) { titleHeight = 48;}
    
    CGFloat width = 260.0f/320.0f*[UIScreen mainScreen].bounds.size.width;
    
    CGSize size                    = CGSizeMake(width - 40, MAXFLOAT);
    
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
    
    NSDictionary *attributes       = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    CGFloat messageHeight = [self.alertMessage boundingRectWithSize:size
                                                            options:options
                                                         attributes:attributes
                                                            context:nil].size.height;
    CGFloat space = 10;
    
    
    if (!isEmpty(self.alertMessage)) {  return titleHeight + messageHeight + space; }
    
    return titleHeight;
    
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
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
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.textColor = [UIColor grayColor];
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _messageLabel.text = self.alertMessage;
        _messageLabel.numberOfLines = 0.0;
    }
    
    return _messageLabel;
}


- (void)alertDoubleDidSelect:(NSInteger)flag {
    
    CLAlertModel *model = self.itemActions[flag];
    
    if (model.action) {
        model.action(model);
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:didSelectActionItem:)]) {
        
        [_delegate alertView:self didSelectActionItem:model];
        
    }
    
}




@end
