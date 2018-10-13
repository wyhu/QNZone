//
//  AppDelegate.m
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "AppDelegate.h"
#import "EMAlertManager.h"
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import "QNRootNavigationController.h"
#import "QNNewHomeViewController.h"//主页
#import "QNExpressTableViewController.h"//查快递
#import "QNActivityViewController.h"//活动
#import "EMPasswordViewController.h"//密码本
#import "JMConfig.h"
#import "JMTabBarController.h"
#import "QNMoreToolTableViewController.h"
#import "EMHomeViewController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate
/**
 初始化框架
 */
- (UIWindow *)window
{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.backgroundColor = [EMTheme currentTheme].navBarBGColor;
    
    [self initRoots];
    
    [self initNoti:launchOptions];
    
    //处理友盟
    [self initUM];
    
    return YES;
}

- (void)initRoots{
    //导航栏和标签栏使用第三方库，两者的全局配置都在这里完成
    NSMutableArray *titleArr = [NSMutableArray arrayWithObjects:@"工具箱",@"设置", nil];
    NSMutableArray *imageSelectedArr = [NSMutableArray arrayWithObjects:@"首页s",@"更多s", nil];
    NSMutableArray *imageNormalArr = [NSMutableArray arrayWithObjects:@"首页n",@"更多n", nil];
    
    
    NSMutableArray *controllersArr = [NSMutableArray array];
    
    EMHomeViewController *homeVC = [[EMHomeViewController alloc] init];
    QNRootNavigationController * homeNav = [[QNRootNavigationController alloc] initWithRootViewController:homeVC];
    [controllersArr addObject:homeNav];
    
//    QNExpressTableViewController *expressVC = [[QNExpressTableViewController alloc] init];
//    QNRootNavigationController * expressNav = [[QNRootNavigationController alloc] initWithRootViewController:expressVC];
//    [controllersArr addObject:expressNav];
    
//    QNActivityViewController *actiVC = [[QNActivityViewController alloc] init];
//    QNRootNavigationController * actiNav = [[QNRootNavigationController alloc] initWithRootViewController:actiVC];
//    [controllersArr addObject:actiNav];
    
    QNMoreToolTableViewController *settingVC = [[QNMoreToolTableViewController alloc] init];
    QNRootNavigationController * settingNav = [[QNRootNavigationController alloc] initWithRootViewController:settingVC];
    [controllersArr addObject:settingNav];
    
    //配置标签栏
    JMConfig *config = [JMConfig config];
    config.tabBarBackground = [EMTheme currentTheme].navTitleColor;
    config.typeLayout = JMConfigTypeLayoutImage;//只有图片
    config.tabBarAnimType = JMConfigTabBarAnimTypeBoundsMax;
    config.imageSize = CGSizeMake(27, 27);
    config.norTitleColor = [UIColor colorWithHexString:@"#707070"];
    config.selTitleColor = [EMTheme currentTheme].navBarBGColor;
    config.imageOffset = 2;
    config.titleFont = 12;
//    config.isClearTabBarTopLine = YES;
    config.tabBarTopLineColor = [UIColor colorWithHexString:@"#707070"];
    
    //标签栏
    JMTabBarController *tabBarVc = [[JMTabBarController alloc] initWithTabBarControllers:controllersArr NorImageArr:imageNormalArr SelImageArr:imageSelectedArr TitleArr:titleArr Config:config];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateHighlighted];
    
    [btn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(46);
    }];
    
    [config addCustomBtn:btn AtIndex:1 BtnClickBlock:^(UIButton *btn, NSInteger index) {
       
        NSInteger curIndex = JMConfig.config.tabBarController.selectedIndex;
        
        QNRootNavigationController *rootNav = JMConfig.config.tabBarController.viewControllers[curIndex];

       EMPasswordViewController * vc = [[EMPasswordViewController alloc] init];
        [rootNav pushViewController:vc animated:YES];
        
        
    }];
    
    
    self.window.rootViewController = tabBarVc;
    [self.window makeKeyAndVisible];
    
}

- (void)initNoti:(NSDictionary *)launchOptions{
    [self registerLocalNotification];//注册本地通知
    [[EMAlertManager sharedManager] didFinishLaunchingWithOptions:launchOptions];
    
}

//处理友盟相关
- (void)initUM{
    
    [UMConfigure initWithAppkey:@"58db8569310c93293e00081e" channel:nil];
    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    [UMConfigure setLogEnabled:YES];//设置打开日志
    
    /*
     * 打开图片水印
     */
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"e55aee297d43be25bd3de2d6eb8e6347" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[EMAlertManager sharedManager] didReceiveLocalNotification:notification];
}


- (void)registerLocalNotification
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
}

@end
