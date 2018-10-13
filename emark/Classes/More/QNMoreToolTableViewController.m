//
//  QNMoreToolTableViewController.m
//  emark
//
//  Created by huweiya on 2018/5/15.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "QNMoreToolTableViewController.h"
#import "QNIdCardViewController.h"
#import "QNMoreTableViewCell.h"

#import "EMHomeCollectionViewCell.h"
#import "EMSettingViewController.h"
#import "EMDiaryViewController.h"
#import "EMBigDayViewController.h"
#import "EMPlaceViewController.h"
#import "EMAlertViewController.h"
#import "EMBillViewController.h"
#import "EMHomeManager.h"
#import "EMPasswordViewController.h"
#import "KYGooeyMenu.h"
#import "QNScanTableViewController.h"
#import "QNMoreToolTableViewController.h"
#import "QNIdCardViewController.h"
#import "QNEveryDayPicViewController.h"
#import "EMHelpViewController.h"
#import "EMSettingViewController.h"//设置



@interface QNMoreToolTableViewController ()

@property(nonatomic, strong) NSArray *data;

@property(nonatomic, strong) NSArray *imageData;

@end

@implementation QNMoreToolTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更多工具";
    self.data = @[@"身份证拼接🆔",@"查快递📦",@"扫一扫",@"密码本🔑",@"提醒📅",@"节日🎁",@"日记📒",@"账单💰",@"收纳👓"];
    self.imageData = @[@"背景0",@"背景1",@"背景2",@"背景3",@"背景4",@"背景5",@"背景6",@"背景5",@"背景6"];
    self.tableView.tableFooterView = [UIView new];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:0 target:self action:@selector(setItemClick)];
    
}

- (void)setItemClick{
    EMSettingViewController *vc = [[EMSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QNMoreTableViewCell *cell = [QNMoreTableViewCell cellForTableView:tableView];
    
    cell.imgView.image = [UIImage imageNamed:self.imageData[indexPath.row]];
    cell.nameLabel.text = self.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Class classVC =  NSClassFromString([self controllers][indexPath.row]);
    UIViewController *vc = [[classVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)controllers{
    return @[@"QNIdCardViewController",@"QNExpressTableViewController",@"QNScanTableViewController",@"EMPasswordViewController",@"EMAlertViewController",@"EMBigDayViewController",@"EMDiaryViewController",@"EMBillViewController",@"EMPlaceViewController"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
