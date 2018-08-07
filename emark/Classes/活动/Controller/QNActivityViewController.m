//
//  QNActivityViewController.m
//  emark
//
//  Created by huweiyaHome on 2018/7/19.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "QNActivityViewController.h"
#import "QNActivityTableViewCell.h"
#import "EMHelpViewController.h"

@interface QNActivityViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation QNActivityViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动";
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QNActivityTableViewCell *cell = [QNActivityTableViewCell cellForTableView:tableView withIden:@"cell"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMHelpViewController  *vc = [[EMHelpViewController alloc] init];
    vc.title = @"工具来啦";
    vc.urlStr = @"http://a3.rabbitpre.com/m2/aUe1ZiA2MV";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
