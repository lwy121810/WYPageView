//
//  FourViewController.m
//  WYPageController
//
//  Created by lwy1218 on 2017/8/17.
//  Copyright © 2017年 eastraycloud. All rights reserved.
//

#import "FourViewController.h"


static NSString *kCellId = @"UITableViewCell";
@interface FourViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FourViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"viewDidLoad >>>>>>>>>>>>>>>>>> %@", NSStringFromClass([self class]));
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellId];
    self.tableView.rowHeight = 44;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *iconPath = [resourcePath stringByAppendingPathComponent:@"lwy2.jpeg"];
    UIImage *icon = [UIImage imageWithContentsOfFile:iconPath];
    self.iconView.image = icon;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear =================== %@", NSStringFromClass([self class]));
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear ***************  %@", NSStringFromClass([self class]));
}


- (void)dealloc
{
    
    _iconView.image = nil;
    _iconView = nil;
    NSLog(@"dealloc --------------  %@", NSStringFromClass([self class]));
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    self.selectedIndex = nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    NSString *text = [NSString stringWithFormat:@"点我跳转到对应的子控制器 --  %ld", indexPath.row + 1];
    cell.textLabel.text = text;
    cell.textLabel.textColor = [UIColor redColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex) {
        self.selectedIndex(indexPath.row);
    }
}
@end
