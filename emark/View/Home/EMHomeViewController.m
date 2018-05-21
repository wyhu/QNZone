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


@interface EMHomeViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
menuDidSelectedDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray          *menuArr;

@end

static NSString *homeCollectionViewCellIdentifier = @"homeCollectionViewCellIdentifier";
static NSString *homeCollectionResuableViewIdentifier = @"homeCollectionResuableViewIdentifier";



@implementation EMHomeViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    [self.view addSubview:self.collectionView];
    [self checkToClearNoti];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(IS_IPHONEX?-49-37:-49);
    }];
    self.collectionView.backgroundColor = [EMTheme currentTheme].navBarBGColor;
    self.view.backgroundColor = [EMTheme currentTheme].navBarBGColor;
    //    [self gooeyMenu];
    
    [self initNav];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        
    }];

    
}

- (void)initNav{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    imageV.image = [UIImage imageNamed:@"青柠book"];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(88, 44));
    }];
    self.navigationItem.titleView = imageV;
    
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
        _collectionView.backgroundColor = [EMTheme currentTheme].navBarBGColor;
        [_collectionView registerClass:[EMHomeCollectionViewCell class]
            forCellWithReuseIdentifier:homeCollectionViewCellIdentifier];
        
        [_collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:homeCollectionResuableViewIdentifier];
        
    }
    
    return _collectionView;
}


- (NSArray *)menuArr
{
    if (!_menuArr) {
        _menuArr = @[NSLocalizedString(@"日记", nil), NSLocalizedString(@"账单", nil), NSLocalizedString(@"节日", nil), NSLocalizedString(@"收纳", nil), NSLocalizedString(@"提醒", nil),NSLocalizedString(@"密码本", nil),NSLocalizedString(@"二维码", nil),NSLocalizedString(@"身份证拼接", nil),@"帮助",@"更多"];
        
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
        //帮助
        vc = [[EMHelpViewController alloc] init];
    }else{
        //更多
        vc = [[QNMoreToolTableViewController alloc] init];
        
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

//红包雨
- (void)getAnimation
{
    //创建一个CAEmitterLayer
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    //降落区域的方位
    snowEmitter.frame = self.view.bounds;
    //添加到父视图Layer上
    [self.view.layer addSublayer:snowEmitter];
    //指定发射源的位置
    snowEmitter.emitterPosition = CGPointMake(self.view.bounds.size.width / 2.0, -10);
    //指定发射源的大小
    snowEmitter.emitterSize  = CGSizeMake(self.view.bounds.size.width, 0.0);
    //指定发射源的形状和模式
    snowEmitter.emitterShape = kCAEmitterLayerLine;
    snowEmitter.emitterMode  = kCAEmitterLayerOutline;
    //创建CAEmitterCell
    
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    //每秒多少个
    snowflake.birthRate = 3.0;
    //存活时间
    snowflake.lifetime = 50.0;
    //初速度，因为动画属于落体效果，所以我们只需要设置它在y方向上的加速度就行了。
    snowflake.velocity = 10;
    //初速度范围
    snowflake.velocityRange = 5;
    //y轴方向的加速度
    snowflake.yAcceleration = 30;
    //以锥形分布开的发射角度。角度用弧度制。粒子均匀分布在这个锥形范围内。
    snowflake.emissionRange = 5;
    //设置降落的图片
    snowflake.contents  = (id) [[UIImage imageNamed:@"billClothe"] CGImage];
    //图片缩放比例
    snowflake.scale = 0.5;
    //开始动画
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowflake];
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
    cell.backgroundColor = [self randomColor];
    cell.menuLabel.text = self.menuArr[indexPath.row];
    return cell;
}

- (UIColor *)randomColor{
    
    NSArray *colorArr = @[@"#FAF0E6",
                          @"#FFE4E1",
                          @"#FFF68F",
                          @"#A52A2A",
                          @"#FFA500",
                          @"#836FFF",
                          @"#7FFFD4",
                          @"#EEC900",
                          @"#EE6363",
                          @"#6C7B8B",
                          @"#90EE90",
                          @"#B2DFEE"
                          ];
    
    int index = arc4random() % colorArr.count;
    
    return UIColorFromRGBAString(colorArr[index]);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: case 3: case 4: case 7:  case 8:
            return CGSizeMake((self.view.frame.size.width - 50) / 2 + 50, 120);
            break;
        case 1: case 2: case 5: case 6: case 9:
            return CGSizeMake((self.view.frame.size.width - 50) / 2 - 50, 120);
            break;
            
        default:
            break;
    }
    
    return CGSizeZero;
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
    return UIEdgeInsetsMake(0, 20, 0, 20);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat height = ([UIApplication sharedApplication].delegate.window.bounds.size.height - 120 * 3 - 10 * 2) / 2 - 64;
    if (IS_3_5_INCH) {
        height = ([UIApplication sharedApplication].delegate.window.bounds.size.height - 120 * 3 - 10 * 2) / 2;
    }
    
    return CGSizeMake(self.view.frame.size.width, 50);
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                              withReuseIdentifier:homeCollectionResuableViewIdentifier
                                                                                     forIndexPath:indexPath];
    headerView.backgroundColor = [EMTheme currentTheme].navBarBGColor;
    
    return headerView;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self jumpAction:indexPath];
}

@end
