//
//  QNExpressCompanyTableViewController.m
//  emark
//
//  Created by huweiya on 2018/5/6.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "QNExpressCompanyTableViewController.h"

#import "QNSearchExpressCompanyTableViewController.h"
@interface QNExpressCompanyTableViewController ()

@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) NSArray *indexArray;


@end

@implementation QNExpressCompanyTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"选择快递", nil);
    self.view.backgroundColor = [EMTheme currentTheme].mainBGColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"搜索"] style:0 target:self action:@selector(searchItemClick)];
}

- (void)searchItemClick{
    QNSearchExpressCompanyTableViewController *vc = [[QNSearchExpressCompanyTableViewController alloc] init];
    vc.qnSearchExpressCompanyResultBlock = ^(NSDictionary *dic) {
        [self.navigationController popViewControllerAnimated:NO];
        
        if (self.qnExpressCompanyResultBlock && dic) {
            self.qnExpressCompanyResultBlock(dic);
        }
        
    };
    [self presentViewController:vc animated:YES completion:nil];
}


- (NSArray *)indexArray{
    if (!_indexArray) {
        _indexArray = @[@"常",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    }
    return _indexArray;
}

- (NSArray *)dataArray{
    
    if (!_dataArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"express2" ofType:@"plist"];
        _dataArray = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return _dataArray;
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = [self dataArray][section];
    return arr.count;
}

//section （标签）标题显示
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"常用快递";
    }
    return self.indexArray[section];
}
//索引显示
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    return self.indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [UITableViewCell new];
    };
    NSArray *arr = [self dataArray][indexPath.section];
    NSDictionary *dic = arr[indexPath.row];
    cell.textLabel.text = dic[@"name"];
    if (indexPath.section == 0) {
        cell.textLabel.textColor = [EMTheme currentTheme].navBarBGColor;
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [self dataArray][indexPath.section];
    NSDictionary *dic = arr[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.qnExpressCompanyResultBlock && dic) {
        self.qnExpressCompanyResultBlock(dic);
    }
}

@end
