//
//  QNSearchExpressCompanyTableViewController.m
//  emark
//
//  Created by huweiya on 2018/5/8.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "QNSearchExpressCompanyTableViewController.h"
#import "KJSearchBar.h"

@interface QNSearchExpressCompanyTableViewController ()
@property(nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) KJSearchBar *searchBar;
@property(nonatomic, strong) NSMutableArray *curArray;

@end

@implementation QNSearchExpressCompanyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableHeaderView = self.searchBar;
    
}
- (KJSearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[KJSearchBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:KJSearchBarStyleCanceButton];
        _searchBar.textField.placeholder = @"搜索快递公司";
        [_searchBar.textField becomeFirstResponder];
        //点击取消
        WeakSelf(QNSearchExpressCompanyTableViewController);
        
        _searchBar.searchBarCanceButtonClickBlock = ^{
            if ([weakSelf.searchBar.textField canResignFirstResponder]) {
                [weakSelf.searchBar.textField resignFirstResponder];
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        //        //文字改变
        _searchBar.searchBarTextChangeBlock = ^(NSString *reslut) {
            [weakSelf startSearch:reslut];
        };
        //点击放大镜
        //        _searchBar.searchBarButtonClickBlock = ^(NSString *result) {
        //
        //        };
    }
    return _searchBar;
}


- (void)startSearch:(NSString *)search{
    
    self.curArray = [NSMutableArray array];

    if (search.length > 0) {
        
        for (NSDictionary *dic in self.dataArray) {
            NSString *name = dic[@"name"];
            
            if ([name containsString:search]) {
                [self.curArray addObject:dic];
            }
        }
        
    }
    
    [self.tableView reloadData];
}

- (NSMutableArray *)curArray{
    if (!_curArray) {
        _curArray = [NSMutableArray array];
    }
    return _curArray;
}

- (NSArray *)dataArray{
    
    if (!_dataArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"express0" ofType:@"plist"];
        _dataArray = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return _dataArray;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.curArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [UITableViewCell new];
    };
    
    NSDictionary *dic = self.curArray[indexPath.row];
//    cell.textLabel.text = dic[@"name"];
    cell.textLabel.attributedText = [self toChangeColorWithKeyword:self.searchBar.textField.text Text:dic[@"name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.qnSearchExpressCompanyResultBlock) {
        if ([self.searchBar.textField canResignFirstResponder]) {
            [self.searchBar.textField resignFirstResponder];
        }
        [self dismissViewControllerAnimated:YES completion:^{
      
        }];
        
        NSDictionary *dic = self.curArray[indexPath.row];
        if (dic) {
            self.qnSearchExpressCompanyResultBlock(dic);
        }
    }

}




- (NSMutableAttributedString *)toChangeColorWithKeyword:(NSString *)keyword Text:(NSString *)text{
    
    // 设置标签文字
    NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:text];
    
    // 获取标红的位置和长度
    NSRange range = [text rangeOfString:keyword];
    
    // 设置标签文字的属性
    [attrituteString setAttributes:@{NSForegroundColorAttributeName :[UIColor redColor] ,   NSFontAttributeName : [UIFont systemFontOfSize:17]} range:range];
    
    // 显示在Label上
    return attrituteString;
    
}
@end
