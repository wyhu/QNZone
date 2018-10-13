//
//  QNNewHomeViewController.m
//  emark
//
//  Created by huweiya on 2018/10/8.
//  Copyright © 2018 neebel. All rights reserved.
//

#import "QNNewHomeViewController.h"
#import "SDCycleScrollView.h"//轮播图
#import "QNHttpManager.h"
#import "QNEveryDayPicViewController.h"
#import "MMScanViewController.h"
#import "QNExpressTableViewController.h"
#import "UIButton+EnlargeEdge.h"


@interface QNNewHomeViewController ()
<SDCycleScrollViewDelegate>

@property(nonatomic, strong)  SDCycleScrollView *cycleScrollView;


@end

@implementation QNNewHomeViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.cycleScrollView];
    
    [self loadData];
    
    [self initButtonView];
    
}

- (void)initButtonView{
    
    CGFloat btnWidth = SCREEN_WIDTH/3;
    
    NSArray *titles = @[@"二维码",@"条形码-1",@"送快递"];
    
    for (int i = 0; i < 3; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(btnWidth, btnWidth));
            make.left.mas_equalTo(i * btnWidth);
        make.top.equalTo(self.cycleScrollView.mas_bottom).mas_offset(0);
            
        }];
//        [button.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(btnWidth/2, btnWidth/2));
//            make.center.equalTo(button);
//        }];
        
//        [button.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(button);
//            make.centerX.equalTo(button);
//        }];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:titles[i] forState:0];
        [button setTitleColor:[EMTheme currentTheme].navBarBGColor forState:0];
        [button setImage:[UIImage imageNamed:titles[i]] forState:0];
        
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20];
    }
    
}

- (void)loadData{
    
    self.cycleScrollView.imageURLStringsGroup = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539065680142&di=2cbe848625b257702479fd67983e01b9&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F0b7b02087bf40ad1e3266b375d2c11dfa8ecce20.jpg",@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3309602765,3271474696&fm=26&gp=0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539065757784&di=e74220b48d8750f717df85ec23eb57e9&imgtype=0&src=http%3A%2F%2Fn2-q.mafengwo.net%2Fs10%2FM00%2F27%2F66%2FwKgBZ1mozfqAMmBKAAymUjAxfag525.png"];
    self.cycleScrollView.titlesGroup = @[@"美图欣赏-鸟巢",@"美图欣赏-伦敦眼",@"美图欣赏-悉尼歌剧院"];
    
}
- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) delegate:self placeholderImage:nil];
        
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView.autoScrollTimeInterval = 6;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        
        //        _cycleScrollView.currentPageDotImage = cImage(@"选中");
        //        _cycleScrollView.pageDotImage = cImage(@"未选中");
        _cycleScrollView.titleLabelHeight = 33;
        _cycleScrollView.titleLabelTextFont = [UIFont systemFontOfSize:15];
        _cycleScrollView.pageControlBottomOffset = 5;
        _cycleScrollView.autoScroll = NO;
        
    }
    return _cycleScrollView;
}
#pragma mark 轮播图点击
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    //    QNEveryDayPicViewController *vc = [[QNEveryDayPicViewController alloc] init];
    //    [self presentViewController:vc animated:YES completion:nil];
    
}


- (IBAction)btnClick:(UIButton *)sender {
    MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeAll onFinish:^(NSString *result, NSError *error) {
        if (error) {
            NSLog(@"error: %@",error);
        } else {
            NSLog(@"扫描结果：%@",result);
            
        }
    }];
    [self.navigationController pushViewController:scanVc animated:YES];
}


- (IBAction)expressClick:(UIButton *)sender {
    
    QNExpressTableViewController *vc = [[QNExpressTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
