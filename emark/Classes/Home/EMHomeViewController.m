//
//  EMHomeViewController.m
//  emark
//
//  Created by neebel on 2017/5/26.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMHomeViewController.h"
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
#import "MJRefresh.h"
#import "SDCycleScrollView.h"//轮播图


@interface EMHomeViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
menuDidSelectedDelegate,
SDCycleScrollViewDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray          *menuArr;

@end

static NSString *homeCollectionViewCellIdentifier = @"homeCollectionViewCellIdentifier";
static NSString *homeCollectionResuableViewIdentifier = @"homeCollectionResuableViewIdentifier";



@implementation EMHomeViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self checkToClearNoti];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(IS_IPHONEX?-44:-20);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(IS_IPHONEX?-49-37:-49);
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNav];
    
//    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self.collectionView reloadData];
//        [self.collectionView.mj_header endRefreshing];
//
//    }];
    
}



- (void)initNav{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    imageV.image = [UIImage imageNamed:@"青柠book"];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(88, 44));
    }];
    self.navigationItem.titleView = imageV;
    
    
        UIButton *dayPicBtn = [[UIButton alloc] init];
        dayPicBtn.layer.cornerRadius = 45/2;
        dayPicBtn.layer.masksToBounds = YES;
        dayPicBtn.layer.borderWidth = 3.0;
        dayPicBtn.layer.borderColor = [EMTheme currentTheme].navBarBGColor.CGColor;
        [dayPicBtn setImage:[UIImage imageNamed:@"每日图片"] forState:0];
        [self.view insertSubview:dayPicBtn aboveSubview:self.collectionView];
        [dayPicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-100);
            make.right.mas_equalTo(-30);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        [dayPicBtn addTarget:self action:@selector(dayPicBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)dayPicBtnClick{
    
    QNEveryDayPicViewController *vc = [[QNEveryDayPicViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)gooeyMenu{
    KYGooeyMenu *gooeyMenu = [[KYGooeyMenu alloc]initWithOrigin:CGPointMake(CGRectGetMidX(self.view.frame)-25, CGRectGetHeight(self.view.frame)-180) andDiameter:50.0f andDelegate:self themeColor:[UIColor orangeColor]];
    
    gooeyMenu.menuDelegate = self;
    gooeyMenu.radius = 50/3;     //这里把小圆半径设为大圆的1/4
    gooeyMenu.extraDistance = 20; //间距设为R+r+20。注：R+r是默认存在的。
    gooeyMenu.MenuCount = 4;      //4个子菜单
    gooeyMenu.menuImagesArray = [NSMutableArray arrayWithObjects:
                                 [UIImage imageNamed:@"快递员"],
                                 [UIImage imageNamed:@"bigDayDelete"],
                                 [UIImage imageNamed:@"bigDayDelete"],
                                 [UIImage imageNamed:@"bigDayDelete"], nil];
}

-(void)menuDidSelected:(int)index{
    
}
- (void)dealloc
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

#pragma mark - Private

- (void)checkToClearNoti
{
    __weak typeof(self) weakSelf = self;
    [[EMHomeManager sharedManager] fetchConfigInfoWithResultBlock:^(EMResult *result) {
        EMAlertConfigInfo *configInfo = result.result;
        if (!configInfo.hasClearAlert) {
            [weakSelf clearNoti];
        }
    }];
}


- (void)clearNoti
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    EMAlertConfigInfo *configInfo = [[EMAlertConfigInfo alloc] init];
    configInfo.hasClearAlert = YES;
    [[EMHomeManager sharedManager] cacheConfigInfo:configInfo];
}

#pragma mark - Getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:flowLayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[EMHomeCollectionViewCell class]
            forCellWithReuseIdentifier:homeCollectionViewCellIdentifier];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:homeCollectionResuableViewIdentifier];
        
    }
    
    return _collectionView;
}


- (NSArray *)menuArr
{
    if (!_menuArr) {
//        _menuArr = @[NSLocalizedString(@"日记", nil), NSLocalizedString(@"账单", nil), NSLocalizedString(@"节日", nil), NSLocalizedString(@"收纳", nil), NSLocalizedString(@"提醒", nil),NSLocalizedString(@"密码本", nil),NSLocalizedString(@"二维码", nil),NSLocalizedString(@"身份证拼接", nil),@"更多"];
        
        _menuArr = @[NSLocalizedString(@"日记", nil), NSLocalizedString(@"账单", nil), NSLocalizedString(@"节日", nil), NSLocalizedString(@"收纳", nil)];
        
    }
    
    return _menuArr;
}

#pragma mark - Action

- (void)jumpAction:(NSIndexPath *)indexPath
{
    
    UIViewController *vc;
    
    
    if (indexPath.row == 0) {
        //日记
        vc = [[EMDiaryViewController alloc] init];
    }else if (indexPath.row == 1){
        //账单
        vc = [[EMBillViewController alloc] init];
    }else if (indexPath.row == 2){
        //节日
        vc = [[EMBigDayViewController alloc] init];
    }else if (indexPath.row == 3){
        //收纳
        vc = [[EMPlaceViewController alloc] init];
    }else if (indexPath.row == 4){
        //提醒
        vc = [[EMAlertViewController alloc] init];
    }else if (indexPath.row == 5){
        //密码本
        vc = [[EMPasswordViewController alloc] init];
    }else if (indexPath.row == 6){
        //二维码
        vc = [[QNScanTableViewController alloc] init];
    }else if (indexPath.row == 7){
        //身份证拼接
        vc = [[QNIdCardViewController alloc] init];
    }else if (indexPath.row == 8){
        vc = [[QNMoreToolTableViewController alloc] init];
    }
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.menuArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EMHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeCollectionViewCellIdentifier
                                                                               forIndexPath:indexPath];
    cell.menuLabel.text = self.menuArr[indexPath.row];
    
    cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"背景%ld",indexPath.row]];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    CGFloat itemWidth = (SCREEN_WIDTH - 50)/3;
    CGFloat itemWidth = (SCREEN_WIDTH - 30)/2;

    return CGSizeMake(itemWidth, itemWidth);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//头部视图
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                              withReuseIdentifier:homeCollectionResuableViewIdentifier
                                                                                     forIndexPath:indexPath];
    SDCycleScrollView *cycleView = [headerView viewWithTag:500];
    
    if (!cycleView) {
        
        cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) delegate:self placeholderImage:nil];
        
        cycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleView.autoScrollTimeInterval = 3;
        cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        
        //        _cycleScrollView.currentPageDotImage = cImage(@"选中");
        //        _cycleScrollView.pageDotImage = cImage(@"未选中");
        cycleView.titleLabelHeight = 33;
        cycleView.titleLabelTextFont = [UIFont systemFontOfSize:15];
        cycleView.pageControlBottomOffset = 5;
//        cycleView.autoScroll = NO;
        cycleView.tag = 500;
        [headerView addSubview:cycleView];

    }
    
    cycleView.titlesGroup = [self titleArrays];
    cycleView.imageURLStringsGroup = [self imgArrays];
    
    return headerView;
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    EMHelpViewController  *vc = [[EMHelpViewController alloc] init];
    vc.title = [self titleArrays][index];
    vc.urlStr = [self urls][index];
    [self.navigationController pushViewController:vc animated:YES];

}

- (NSArray *)urls{
    return @[@"https://wapbaike.baidu.com/item/%E5%9B%BD%E5%AE%B6%E4%BD%93%E8%82%B2%E5%9C%BA/1297632?fromtitle=%E9%B8%9F%E5%B7%A2&fromid=4247529&bk_tashuoStyle=topLeft&bk_share=wechat&bk_sharefr=trip",@"https://wapbaike.baidu.com/item/%E4%BC%A6%E6%95%A6%E7%9C%BC?timestamp=1539065879868",@"https://wapbaike.baidu.com/item/%E6%82%89%E5%B0%BC%E6%AD%8C%E5%89%A7%E9%99%A2?timestamp=1539065861589"];
}

- (NSArray *)imgArrays{
    return @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539065680142&di=2cbe848625b257702479fd67983e01b9&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F0b7b02087bf40ad1e3266b375d2c11dfa8ecce20.jpg",@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3309602765,3271474696&fm=26&gp=0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539065757784&di=e74220b48d8750f717df85ec23eb57e9&imgtype=0&src=http%3A%2F%2Fn2-q.mafengwo.net%2Fs10%2FM00%2F27%2F66%2FwKgBZ1mozfqAMmBKAAymUjAxfag525.png"];
}

- (NSArray *)titleArrays{
    return @[@"鸟巢",@"伦敦眼",@"悉尼歌剧院"];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self jumpAction:indexPath];
}

@end
