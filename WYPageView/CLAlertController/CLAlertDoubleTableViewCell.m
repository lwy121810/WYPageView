//
//  CLAlertDoubleTableViewCell.m
//  AlertController
//
//  Created by sethmedia on 16/11/20.
//  Copyright © 2016年 sethmedia. All rights reserved.
//

#import "CLAlertDoubleTableViewCell.h"
#import "CLAlertModel.h"

@interface CLAlertDoubleTableViewCell ()

@property(nonatomic,strong) UIButton * leftBtn;
@property(nonatomic,strong) UIButton * rightBtn;

@end


@implementation CLAlertDoubleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setFrame:(CGRect)frame {
    
    frame.size.height -= 1;
    [super setFrame:frame];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        [self setup];
    }
    
    return self;
    
}

- (UIButton *)leftBtn {
    
    if (!_leftBtn) {
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _leftBtn.backgroundColor = [UIColor whiteColor];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _leftBtn.tag = 1;
    }
    
    
    return _leftBtn;
}

- (UIButton *)rightBtn {
    
    if (!_rightBtn) {
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightBtn.backgroundColor = [UIColor whiteColor];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _rightBtn.tag = 2;
    }
    
    
    return _rightBtn;
}


- (void)setup {
    
    [self.contentView addSubview:self.leftBtn];
    [self.contentView addSubview:self.rightBtn];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_leftBtn]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_leftBtn)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftBtn]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_leftBtn)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_rightBtn]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_rightBtn)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_leftBtn]-0.5-[_rightBtn(_leftBtn)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_rightBtn,_leftBtn)]];
    
    
}

- (void)setModels:(NSArray<CLAlertModel *> *)models {
    
    CLAlertModel *model0 = models[0];
    CLAlertModel *model1 = models[1];
    [self.rightBtn setTitle:model1.title forState:UIControlStateNormal];
    [self.leftBtn setTitle:model0.title forState:UIControlStateNormal];
    
    switch (model0.style) {
        case CLAlertActionStyleCancel:
        {
            self.leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
            
        case CLAlertActionStyleDefault:
        {
            self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
            
        case CLAlertActionStyleDestructive:
            
        {
            self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }
            
        default:
            break;
    }
    
    switch (model1.style) {
        case CLAlertActionStyleCancel:
        {
            self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
            
        case CLAlertActionStyleDefault:
        {
            self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
            
        case CLAlertActionStyleDestructive:
            
        {
            self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }
            
        default:
            break;
    }
    
    
    
    
}



- (void)BtnClick:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(alertDoubleDidSelect:)]) {
        [_delegate alertDoubleDidSelect:sender.tag-1];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
