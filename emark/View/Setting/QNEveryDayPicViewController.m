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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;


@end

@implementation QNEveryDayPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadData];
    self.bottomView.hidden = YES;
    
//    self.bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.imageView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;

}
- (void)tapClick{
        
    self.bottomView.hidden = !self.bottomView.hidden;
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

- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)downloadAction:(UIButton *)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error) {
        [OFToast showDefaultText:@"保存失败"];
    } else {
        [OFToast showDefaultText:@"保存成功"];

    }
}


- (IBAction)exchangeAction:(UIButton *)sender {
    
    
        sender.selected = !sender.selected;
        
        if (sender.selected) {
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }else{
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

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
