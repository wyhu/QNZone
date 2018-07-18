//
//  QNRootNavigationController.m
//  emark
//
//  Created by huweiya on 2018/5/7.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "QNRootNavigationController.h"
#import "JMTabBarController.h"
@interface QNRootNavigationController ()
<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation QNRootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;

//    将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000 * 4, 0)
                                                         forBarMetrics:UIBarMetricsDefault];

    //去掉下划线
    [self.navigationBar setShadowImage:[UIImage new]];
    
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.translucent = YES;
    //背景色
    bar.barTintColor = [EMTheme currentTheme].navBarBGColor;
    //字体色
    bar.titleTextAttributes = @{NSForegroundColorAttributeName:[EMTheme currentTheme].navTitleColor};
    bar.tintColor = [EMTheme currentTheme].navTitleColor;

}



- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //显示
    if (self.viewControllers.count == 1) {
        [JMConfig config].tabBarController.JM_TabBar.hidden = NO;
    }
}

//push隐藏标签栏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count != 1) {
        [JMConfig config].tabBarController.JM_TabBar.hidden = YES;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
