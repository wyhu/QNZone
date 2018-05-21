//
//  OFToast.m
//  OliveFortune
//
//  Created by DangGuo on 16/1/12.
//  Copyright © 2016年 com.zhengjin99. All rights reserved.
//

#import "OFToast.h"
#import "UIView+Toast.h"

@implementation OFToast

+ (OFToast*)shareInstance {
    static OFToast *ofToast = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ofToast = [[OFToast alloc]init];
    });
    return ofToast;
}

+ (void)configureToast {
    [CSToastManager setQueueEnabled:NO];
}

/**
 *  显示加载动画
 *
 *  @param containView
 */
+ (void)showLoadingHUD:(UIView *)containView {
    [containView makeToastActivity:CSToastPositionCenter];

}

/**
 *  隐藏加载动画
 *
 *  @param containView
 */
+ (void)hiddenLoadingHUD:(UIView *)containView {
    [containView hideToastActivity];

}

+ (void)addLoadingOnView:(UIView*)view {
    OFToast *ofToast = [OFToast shareInstance];
    if (!ofToast.animationImageView) {
        ofToast.animationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 56, 51.5)];
        ofToast.animationImageView.image = [UIImage imageNamed:@"Image-22"];
        ofToast.imageIndex = 1;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        ofToast.animationImageView.center = window.center;
        [window addSubview:ofToast.animationImageView];
        ofToast.animationTimer = [NSTimer scheduledTimerWithTimeInterval:.05 target:ofToast selector:@selector(loadingAnimation) userInfo:nil repeats:YES];
    }
}

- (void)loadingAnimation {
    OFToast *ofToast = [OFToast shareInstance];
    if (ofToast.imageIndex > 22) {
        ofToast.imageIndex = 1;
    }
    ofToast.animationImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Image-%ld",(long)ofToast.imageIndex]];
    ofToast.imageIndex++;
}

+ (void)removeLoadingOnView:(UIView*)view {
    OFToast *ofToast = [OFToast shareInstance];
    if (ofToast.animationImageView) {
        ofToast.animationImageView.image = [UIImage imageNamed:@"Image-22"];
        [ofToast.animationImageView removeFromSuperview];
        ofToast.animationImageView = nil;
        [ofToast.animationTimer invalidate];
        ofToast.animationTimer = nil;
    }
}

/**
 *
 *
 *  @param view
 *  @param text
 *  @param postion
 *  @param duration
 */
+ (void)showAtView:(UIView *)view text:(NSString *)text postion:(ToastPosition)postion duration:(CGFloat)duration {

    NSString *showPositon;
    
    switch (postion) {
        case ToastPositionTop:
            showPositon = (NSString *)CSToastPositionTop;
            break;
        case ToastPositionCenter:
            showPositon = (NSString *)CSToastPositionCenter;
            break;
        default:
            showPositon = (NSString *)CSToastPositionBottom;
            break;
    }
    
    [view makeToast:text duration:duration position:showPositon];
}

+ (void)showAtView:(UIView *)view text:(NSString *)text duration:(CGFloat)duration {
    [view makeToast:text duration:duration position:CSToastPositionCenter];
}

+ (void)showDataError:(UIView *)view {
    [OFToast showAtView:view text:@"数据异常，请您稍后重试" postion:ToastPositionCenter duration:1.0f];
}

+ (void)showNetError:(UIView *)view {
    [OFToast showAtView:view text:@"网络异常，请您稍后重试" postion:ToastPositionCenter duration:1.0f];
}

+ (void)showDataErrorWithWealthAdd:(UIView *)view {
    [OFToast showAtView:view text:@"网络在开小差，检查后再试吧" postion:ToastPositionCenter duration:1.0f];
}

+ (void)showNetErrorWithWealthAdd:(UIView *)view {
    [OFToast showAtView:view text:@"世界上最远的距离是没网" postion:ToastPositionCenter duration:1.0f];
}


+ (void)showNoMoreData:(CGFloat)duration
{
    [OFToast showAtView:[UIApplication sharedApplication].keyWindow text:@"没有数据了" duration:duration];
}


+ (void)showDefaultText:(NSString *)text;
{
    [OFToast showAtView:[UIApplication sharedApplication].keyWindow text:text duration:1.5];

}

/**
 没有数据
 */
+ (void)showNoData
{
    [OFToast showAtView:[UIApplication sharedApplication].keyWindow text:@"没有获取到数据" duration:1.0];
}

/**
 没有更多数据
 */
+ (void)showNoOtherData
{
    [OFToast showAtView:[UIApplication sharedApplication].keyWindow text:@"没有数据了" duration:1.0];
}


@end
