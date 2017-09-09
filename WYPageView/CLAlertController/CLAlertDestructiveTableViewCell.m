//
//  CLAlertDestructiveTableViewCell.m
//  AlertController
//
//  Created by sethmedia on 16/11/20.
//  Copyright © 2016年 sethmedia. All rights reserved.
//

#import "CLAlertDestructiveTableViewCell.h"
#import "CLAlertModel.h"


@interface CLAlertDestructiveTableViewCell ()

@property(nonatomic,strong) UILabel * label;


@end

@implementation CLAlertDestructiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFrame:(CGRect)frame {
    
    frame.size.height -= 1;
    [super setFrame:frame];
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setup];
        self.preservesSuperviewLayoutMargins = NO;
        self.layoutMargins = UIEdgeInsetsZero;
        self.separatorInset = UIEdgeInsetsZero;
        
    }
    return self;
}

- (void)setup {
    
    [self.contentView addSubview:self.label];
    
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
    
    
}


- (UILabel *)label {
    
    if (!_label) {
        
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor redColor];
    }
    return _label;
    
}



- (void)setModel:(CLAlertModel *)model {
    
    self.label.text = model.title;
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
