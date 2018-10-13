//
//  QNEveryDayPicViewController.m
//  emark
//
//  Created by huweiya on 2018/5/8.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "QNEveryDayPicViewController.h"
#import "QNHttpManager.h"
#import "UIImageView+WebCache.h"
#import "OFToast.h"

@interface QNEveryDayPicViewController ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation QNEveryDayPicViewController

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"返回"] forState:0];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.hidden = YES;
    }
    return _backButton;
}
- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (UIButton *)downloadButton
{
    if (!_downloadButton) {
        _downloadButton = [[UIButton alloc] init];
        [_downloadButton setImage:[UIImage imageNamed:@"下载"] forState:0];
        [_downloadButton addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
        _downloadButton.hidden = YES;
    }
    return _downloadButton;
}
- (IBAction)downloadAction:(UIButton *)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"返回"] forState:0];
        _closeButton.hidden = YES;

    }
    return _closeButton;
}
- (UIButton *)changeButton
{
    if (!_changeButton) {
        _changeButton = [[UIButton alloc] init];
        [_changeButton setImage:[UIImage imageNamed:@"替换"] forState:0];
        _changeButton.hidden = YES;
        [_changeButton addTarget:self action:@selector(exchangeAction:) forControlEvents:UIControlEventTouchUpInside];


    }
    return _changeButton;
}

- (IBAction)exchangeAction:(UIButton *)sender {
    
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }else{
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor lightGrayColor];

    }
    return _imageView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(60);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.view addSubview:self.downloadButton];
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.bottom.mas_equalTo(-60);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    
    [self.view addSubview:self.changeButton];
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.bottom.equalTo(self.downloadButton.mas_top).mas_offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    
//    [self.view addSubview:self.closeButton];
//    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-25);
//        make.bottom.equalTo(self.changeButton.mas_top).mas_offset(-20);
//        make.size.mas_equalTo(CGSizeMake(30, 30));
//    }];
    
    
    
    [self loadData];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    
    [self.view addGestureRecognizer:tap];
    
    [self getAnimation];
}


- (void)tapClick{
    
    self.backButton.hidden = !self.backButton.hidden;
    self.downloadButton.hidden = !self.downloadButton.hidden;
    self.closeButton.hidden = !self.closeButton.hidden;
    self.changeButton.hidden = !self.changeButton.hidden;
    
}

- (void)dealloc{
    
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
    snowEmitter.emitterPosition = CGPointMake(SCREEN_WIDTH/2, 0);
    //指定发射源的大小
    snowEmitter.emitterSize  = CGSizeMake(SCREEN_WIDTH, 0.0);
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
    snowflake.contents  = (id) [[UIImage imageNamed:@"星星"] CGImage];
    //图片缩放比例
    snowflake.scale = 0.5;
    //开始动画
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowflake];
}



- (void)loadData{
    
    //    dayPicVC
    NSString *url = @"http://www.bing.com/HPImageArchive.aspx";
    NSDictionary *params = @{@"format":@"js",
                             @"idx":@"0",
                             @"n":@"1"
                             };
    [QNHttpManager GET:url parameters:params success:^(NSURLSessionDataTask *operation, NSDictionary *responseDic) {
        
        NSArray *images = responseDic[@"images"];
        if (images.count > 0) {
            NSDictionary *image = images[0];
            NSString *url = image[@"url"];
            NSString *pic = [NSString stringWithFormat:@"http://www.bing.com%@",url];
            
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:pic]];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
    
    
}



- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error) {
        [OFToast showDefaultText:@"保存失败"];
    } else {
        [OFToast showDefaultText:@"保存成功"];

    }
}



//-(BOOL)shouldAutorotate{
//    return YES;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationLandscapeRight;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
