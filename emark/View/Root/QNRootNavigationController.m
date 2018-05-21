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
    //导航栏左右item字体颜色
    [self.navigationBar setTintColor:[EMTheme currentTheme].navTitleColor];
    
    UIColor *color = [EMTheme currentTheme].navTitleColor;
    //中间标题
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color};
    
    //导航栏背景
    self.navigationBar.translucent = NO;
//    self.navigationBar.backgroundColor = [UIColor redColor];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBg"] forBarPosition:UIBarPositionTop barMetrics:0];
    //去掉下划线
    [self.navigationBar setShadowImage:[UIImage new]];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
