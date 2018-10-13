//
//  QNIdCardViewController.m
//  emark
//
//  Created by huweiya on 2018/5/15.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "QNIdCardViewController.h"
#import "HXPhotoManager.h"
#import "HXPhotoPicker.h"
#import "QNIdCardResultViewController.h"
@interface QNIdCardViewController ()
<HXAlbumListViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *FrontButton;

@property (weak, nonatomic) IBOutlet UIButton *AfterButton;

@property(nonatomic,strong) UIImage *frontImage;
@property(nonatomic,strong) UIImage *afterImage;

@property(nonatomic,strong) UIButton *currrentButton;

@property (weak, nonatomic) IBOutlet UIButton *okButton;


@end

@implementation QNIdCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"身份证拼接";
    [self initUI];
}

- (void)initUI{
    self.okButton.enabled = NO;
    
    self.FrontButton.layer.masksToBounds = YES;
    self.FrontButton.layer.borderColor = [EMTheme currentTheme].navBarBGColor.CGColor;
    self.FrontButton.layer.borderWidth = 1.0;
    self.FrontButton.layer.cornerRadius = 10.0;
    
    self.AfterButton.layer.masksToBounds = YES;
    self.AfterButton.layer.borderColor = [EMTheme currentTheme].navBarBGColor.CGColor;
    self.AfterButton.layer.borderWidth = 1.0;
    self.AfterButton.layer.cornerRadius = 10.0;
    
//    self.lastImageView.contentMode = UIViewContentModeScaleAspectFit;
}


- (IBAction)frontAction:(UIButton *)sender {
    
    [self hx_presentAlbumListViewControllerWithManager:[self manager] delegate:self];
    self.currrentButton = sender;
    
}

- (IBAction)afterAction:(UIButton *)sender {
    
    [self hx_presentAlbumListViewControllerWithManager:[self manager] delegate:self];
    self.currrentButton = sender;
    
}

- (IBAction)pinJieAction:(UIButton *)sender {
    
    if (!self.FrontButton.currentBackgroundImage || !
        self.AfterButton.currentBackgroundImage) {
        return;
    }
    
    UIImage *resultImage = [self addSlaveImage:self.AfterButton.currentBackgroundImage toMasterImage:self.FrontButton.currentBackgroundImage];
    if (resultImage) {
        
        QNIdCardResultViewController *vc = [[QNIdCardResultViewController alloc] init];
        vc.imageView.image = resultImage;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    

}


- (UIImage *)addSlaveImage:(UIImage *)slaveImage toMasterImage:(UIImage *)masterImage {
    
    //身份证尺寸
    CGFloat idWidth = 640;
    CGFloat idHeight = 320;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(idWidth, idHeight * 2+0), YES, 0.0);
    
    [masterImage drawInRect:CGRectMake(0, 0, idWidth, idHeight)];
    [slaveImage drawInRect:CGRectMake(0, idHeight+0, idWidth, idHeight)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}


- (HXPhotoManager *)manager{
    
    HXPhotoManager *manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    
    manager.configuration.rowCount = 2;
    //是否显示组头时间
    manager.configuration.showDateSectionHeader = YES;
    //按时间倒叙
    manager.configuration.reverseDate = YES;
    //是否替换自己的相机
    manager.configuration.replaceCameraViewController = NO;
    //是否打开相机
    manager.configuration.openCamera = NO;
    //开启单选模式
    manager.configuration.singleSelected = YES;
    manager.configuration.photoMaxNum = 1;
    manager.configuration.movableCropBox = YES;
    manager.configuration.movableCropBoxEditSize = YES;
    
    manager.configuration.movableCropBoxCustomRatio = CGPointMake(1.6, 1);
    
    return manager;
}

//相册回调
- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    
    if (photoList.count > 0) {
        HXPhotoModel *model = photoList[0];
        UIImage *image = model.previewPhoto;
        if (image) {
            [self.currrentButton setBackgroundImage:image forState:0];
            [self.currrentButton setTitle:@"" forState:0];
            [self.currrentButton setImage:nil forState:0];
        }
        
        if (self.FrontButton.currentBackgroundImage &&
            self.AfterButton.currentBackgroundImage) {
            self.okButton.enabled = YES;
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
