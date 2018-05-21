//
//  QNScanTableViewController.m
//  emark
//
//  Created by huweiya on 2018/5/8.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "QNScanTableViewController.h"
#import "MMScanViewController.h"
#import "TestDrawQrViewController.h"
#import "TestDrawBarViewController.h"
#import "LEEAlert.h"
@interface QNScanTableViewController ()
@property(nonatomic, strong) NSArray *data;
@end

@implementation QNScanTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫一扫";
    self.data = @[@"扫一扫",@"扫描二维码",@"扫描条形码",@"绘制二维码",@"绘制条形码"];
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
        MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeAll onFinish:^(NSString *result, NSError *error) {
            if (error) {
                NSLog(@"error: %@",error);
            } else {
                NSLog(@"扫描结果：%@",result);
                [self showInfo:result];
            }
        }];
        [self.navigationController pushViewController:scanVc animated:YES];
    } else if (indexPath.row == 1) {
        MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeQrCode onFinish:^(NSString *result, NSError *error) {
            if (error) {
                NSLog(@"error: %@",error);
            } else {
                NSLog(@"扫描结果：%@",result);
                [self showInfo:result];
            }
        }];
        [self.navigationController pushViewController:scanVc animated:YES];
    } else if (indexPath.row == 2) {
        MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeBarCode onFinish:^(NSString *result, NSError *error) {
            if (error) {
                NSLog(@"error: %@",error);
            } else {
                NSLog(@"扫描结果：%@",result);
                [self showInfo:result];
            }
        }];
        [self.navigationController pushViewController:scanVc animated:YES];
    } else if (indexPath.row == 3) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TestDrawQrViewController *drawQrVC = [story instantiateViewControllerWithIdentifier:@"drawQr"];
        [self.navigationController pushViewController:drawQrVC animated:YES];
    } else {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TestDrawBarViewController *drawBarVC = [story instantiateViewControllerWithIdentifier:@"drawBar"];
        [self.navigationController pushViewController:drawBarVC animated:YES];
    }
}


- (void)showInfo:(NSString*)str {
    
    if ([str hasPrefix:@"http"]) {
        
        [LEEAlert alert].config
        .LeeTitle(@"扫描结果")
        .LeeContent(str)
        .LeeAction(@"Safari打开此网页", ^{
            NSURL *url = [NSURL URLWithString:str];
            
            bool can = [[UIApplication sharedApplication] canOpenURL:url];
            if(can){
                [[UIApplication sharedApplication] openURL:url];
            }
            
        })
        .LeeAction(@"复制到剪切板", ^{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = str;
        })
        .LeeCancelAction(@"好的", ^{
            
        })
        .LeeShow();
        
    }else{
        //普通文字
        
        [LEEAlert alert].config
        .LeeTitle(@"扫描结果")
        .LeeContent(str)
        .LeeAction(@"复制到剪切板", ^{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = str;
        })
        .LeeCancelAction(@"好的", ^{
            
        })
        .LeeShow();
        
        
    }
    
    
}



@end
