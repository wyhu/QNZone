//
//  QNIdCardResultViewController.m
//  emark
//
//  Created by huweiya on 2018/5/18.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "QNIdCardResultViewController.h"

@interface QNIdCardResultViewController ()

@end

@implementation QNIdCardResultViewController

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"拼接完成";
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIBarButtonItem *printItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ID下载"] style:0 target:self action:@selector(saveAciton)];
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ID打印"] style:0 target:self action:@selector(printAction:)];

    self.navigationItem.rightBarButtonItems = @[saveItem,printItem];
}

#pragma mark打印
-(void)printAction:(UIBarButtonItem *)item
{
    //获取要打印的图片
    UIImage * printImage = self.imageView.image;

    UIPrintInteractionController *printC = [UIPrintInteractionController sharedPrintController];//显示出打印的用户界面。
//    printC.delegate = self;
    
    if (!printC) {
        NSLog(@"打印机不存在");
        
    }
    
    printC.showsNumberOfCopies = YES;
    printC.showsPageRange = YES;
    
    NSData *imgDate = UIImageJPEGRepresentation(printImage, 1);
    
    if (printC && [UIPrintInteractionController canPrintData:imgDate]) {
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];//准备打印信息以预设值初始化的对象。
        printInfo.outputType = UIPrintInfoOutputGeneral;//设置输出类型。
        printC.showsPageRange = YES;//显示的页面范围
    
        printC.printInfo = printInfo;
        printC.printingItem = imgDate;//single NSData, NSURL, UIImage, ALAsset
        
        // 等待完成
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"可能无法完成，因为印刷错误: %@", error);
            }else{
                
            }
        };
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            [printC presentFromBarButtonItem:item animated:YES completionHandler:completionHandler];//在ipad上弹出打印那个页面
        } else {
            [printC presentAnimated:YES completionHandler:completionHandler];//在iPhone上弹出打印那个页面
        }
    }
}



#pragma mark 保存
- (void)saveAciton{
    
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error) {
        [self showInfo:[NSString stringWithFormat:@"error: %@",error]];
    } else {
        [self showInfo:@"保存成功"];
    }
}

#pragma mark - Error handle
- (void)showInfo:(NSString*)str {
    [self showInfo:str andTitle:@"提示"];
}

- (void)showInfo:(NSString*)str andTitle:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:str preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action1 = ({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:NULL];
        action;
    });
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:NULL];
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
