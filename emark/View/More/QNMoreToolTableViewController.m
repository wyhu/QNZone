//
//  QNMoreToolTableViewController.m
//  emark
//
//  Created by huweiya on 2018/5/15.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "QNMoreToolTableViewController.h"
#import "QNIdCardViewController.h"
@interface QNMoreToolTableViewController ()

@property(nonatomic, strong) NSArray *data;
@end

@implementation QNMoreToolTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更多工具";
    self.data = @[@"身份证拼接"];
    self.tableView.tableFooterView = [UIView new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    };
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //身份证拼接
        QNIdCardViewController *vc = [[QNIdCardViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
