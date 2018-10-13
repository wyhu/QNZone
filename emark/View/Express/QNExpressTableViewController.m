//
//  QNExpressTableViewController.m
//  emark
//
//  Created by huweiya on 2018/5/5.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "QNExpressTableViewController.h"
#import "QNExpressCompanyTableViewController.h"
#import "QNHttpManager.h"
#import "UIView+EMTips.h"
#import <AudioToolbox/AudioToolbox.h>
#import "LEEAlert.h"

@interface QNExpressTableViewController ()

@property(nonatomic, strong) UIButton *searchB;
@property(nonatomic, strong) UIButton *comB;

@property(nonatomic, copy) NSString *expressComName;
@property(nonatomic, copy) NSString *expressComId;

@property(nonatomic, strong) UITextField *textF;

@property(nonatomic, strong) NSArray *data;


@end

@implementation QNExpressTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (@available(iOS 11.0, *)) {
//        self.navigationController.navigationBar.prefersLargeTitles = YES;
//    } else {
//        
//    }
    
    self.title = NSLocalizedString(@"查快递", nil);
    self.view.backgroundColor = [EMTheme currentTheme].mainBGColor;
    self.tableView.tableHeaderView = [self tableHeaderView];


    
}

- (void)shareClick{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    imageView.image = [self tableViewCapture];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [LEEAlert alert].config
//    .LeeTitle(@"保存截图到本地？")
//    .LeeContent(@"已经保存物流信息到相册")
    .LeeAddCustomView(^(LEECustomView *custom) {
        
        // 自定义设置Block
        
        // 设置视图对象
        custom.view = imageView;
        
        // 设置自定义视图的位置类型 (包括靠左 靠右 居中 , 默认为居中)
        custom.positionType = LEECustomViewPositionTypeCenter;
        
        // 设置是否自动适应宽度 (自适应宽度后 位置类型为居中)
        custom.isAutoWidth = YES;
    })

    .LeeAction(@"分享给朋友", ^{
        
    })
    .LeeAction(@"保存到本地", ^{
        UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    })
    .LeeAction(@"取消", ^{
        
    })
    .LeeShow();


}


- (UIImage*)tableViewCapture
{
    
    UIImage* viewImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(self.tableView.contentSize, self.tableView.opaque, 0.0);
    {
        CGPoint savedContentOffset = self.tableView.contentOffset;
        CGRect savedFrame = self.tableView.frame;
        
        self.tableView.contentOffset = CGPointZero;
        self.tableView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.contentSize.height);
        
        [self.tableView.layer renderInContext: UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        self.tableView.contentOffset = savedContentOffset;
        self.tableView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    return viewImage;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        
        
        
    }
}

- (UIView *)tableHeaderView{
    
    UIView *headrV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 90)];
    //[EMTheme currentTheme].navBarBGColor
    headrV.backgroundColor = [UIColor whiteColor];
    
    UIButton *searchB = [[UIButton alloc] init];
    [headrV addSubview:searchB];
    [searchB setTitleColor:[UIColor whiteColor] forState:0];
    [searchB setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    [searchB setTitle:@"查询" forState:0];
    searchB.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    searchB.layer.masksToBounds = YES;
    searchB.layer.cornerRadius = 10.0;
    searchB.backgroundColor = [EMTheme currentTheme].navBarBGColor;
    [searchB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-5);
        make.width.equalTo(searchB.mas_height);
    }];
    searchB.enabled = NO;
    self.searchB = searchB;
    [searchB addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *comB = [[UIButton alloc] init];
    [headrV addSubview:comB];
    comB.backgroundColor = [EMTheme currentTheme].navBarBGColor;
    [comB setTitleColor:[UIColor whiteColor] forState:0];
    [comB setTitle:@"选择快递公司" forState:0];
    comB.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    comB.layer.masksToBounds = YES;
    comB.layer.cornerRadius = 10.0;
    [comB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(5);
        make.height.mas_equalTo(35);
        make.right.equalTo(searchB.mas_left).mas_offset(-10);
    }];
    [comB addTarget:self action:@selector(expressComBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.comB = comB;
    
    
    UITextField *textF = [[UITextField alloc] init];
    textF.layer.masksToBounds = YES;
    textF.layer.cornerRadius = 10.0;
    textF.textAlignment = NSTextAlignmentCenter;
    textF.textColor = [UIColor whiteColor];
    textF.placeholder = @"输入快递单号";
//    textF.clearButtonMode=UITextFieldViewModeAlways;
    textF.keyboardType = UIKeyboardTypeNumberPad;
    textF.font = [UIFont boldSystemFontOfSize:17];
    [headrV addSubview:textF];
    textF.backgroundColor = [EMTheme currentTheme].navBarBGColor;
    [textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.height.mas_equalTo(35);
        make.right.equalTo(searchB.mas_left).mas_offset(-10);
    }];
    self.textF = textF;
    [textF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];

    
    return headrV;
}

#pragma mark 选择公司
- (void)textFieldTextChange:(UITextField *)textField{
    
    if (textField.markedTextRange == nil) {
        
        if (textField.text.length > 0 && self.expressComName) {
            self.searchB.enabled = YES;
        }else{
            self.searchB.enabled = NO;
        }
        
    }
    
}

#pragma mark选择回调
- (void)expressComBtnClick{
    QNExpressCompanyTableViewController *vc = [[QNExpressCompanyTableViewController alloc] init];
    vc.qnExpressCompanyResultBlock = ^(NSDictionary *dic) {
        
        self.expressComName = dic[@"name"];
        self.expressComId = dic[@"id"];
        [self.comB setTitle:self.expressComName forState:0];
        self.title = self.expressComName;
        if (self.textF.text.length > 0 && self.expressComName) {
            self.searchB.enabled = YES;
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 查询
- (void)searchBtnClick{
    
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
    
    
    NSDictionary *params = @{@"type":self.expressComId,
                             @"postid":self.textF.text
                             };
    
//    https://www.kuaidi100.com/query?type=yunda&postid=3839999003934
    [QNHttpManager GET:@"https://www.kuaidi100.com/query" parameters:params success:^(NSURLSessionDataTask *operation, NSDictionary *responseDic) {
        
        if ([responseDic[@"status"] integerValue] == 200) {
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"操作"] style:0 target:self action:@selector(shareClick)];

            
            //请求成功
            self.data = responseDic[@"data"];
            [self.tableView reloadData];
            
            if ([self.textF canResignFirstResponder]) {
                [self.textF resignFirstResponder];
            }
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误提醒" message:responseDic[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        [self.view hideManualTips];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self.view hideManualTips];
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.textLabel.numberOfLines = 0;
        [cell.textLabel sizeToFit];
    };
    NSDictionary *dic = self.data[indexPath.row];
    cell.textLabel.text = dic[@"context"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@至%@",dic[@"time"],dic[@"ftime"]];

    return cell;
}


@end
