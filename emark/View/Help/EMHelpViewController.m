//
//  EMHelpViewController.m
//  emark
//
//  Created by huweiya on 2018/4/30.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "EMHelpViewController.h"
#import <WebKit/WebKit.h>
#import "UIView+EMTips.h"

@interface EMHelpViewController ()
<WKNavigationDelegate>


@property (nonatomic, strong) WKWebView *wkWebView;


@end

@implementation EMHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [EMTheme currentTheme].mainBGColor;
    [self.view addSubview:self.wkWebView];
    [self.view showMaskLoadingTips:nil style:kLogoLoopGray];
}

- (void)setUrlStr:(NSString *)urlStr
{
    _urlStr = urlStr;
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    [self.wkWebView loadRequest:request];

}
- (WKWebView *)wkWebView
{
    if (!_wkWebView) {
        
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
        //允许左滑返回
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
        _wkWebView.scrollView.showsHorizontalScrollIndicator = NO;
        _wkWebView.scrollView.bouncesZoom = YES;
        _wkWebView.navigationDelegate = self;
        //监听进度
//        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return _wkWebView;
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.view hideManualTips];
}


//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.view hideManualTips];
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
