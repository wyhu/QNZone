//
//  OFToast.h
//  OliveFortune
//
//  Created by DangGuo on 16/1/12.
//  Copyright © 2016年 com.zhengjin99. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ToastPosition) {
    ToastPositionTop = 0,
    ToastPositionCenter,
    ToastPositionBottom
};

@interface OFToast : NSObject

@property(nonatomic,strong) NSTimer *animationTimer;
@property(nonatomic,strong) UIImageView *animationImageView;
@property(nonatomic,assign) NSInteger imageIndex;

+ (OFToast*)shareInstance;

/**
 *
 */
+ (void)configureToast;

/**
 *  显示加载动画
 *
 *  @param containView
 */
+ (void)showLoadingHUD:(UIView *)containView;

/**
 *  隐藏加载动画
 *
 *  @param containView
 */
+ (void)hiddenLoadingHUD:(UIView *)containView;

+ (void)addLoadingOnView:(UIView*)view;

+ (void)removeLoadingOnView:(UIView*)view;



+ (void)showAtView:(UIView *)view text:(NSString *)text postion:(ToastPosition)postion duration:(CGFloat)duration;

+ (void)showAtView:(UIView *)view text:(NSString *)text duration:(CGFloat)duration;

+ (void)showDataError:(UIView *)view;

+ (void)showNetError:(UIView *)view;

+ (void)showDataErrorWithWealthAdd:(UIView *)view;

+ (void)showNetErrorWithWealthAdd:(UIView *)view;

+ (void)showNoMoreData:(CGFloat)duration;

+ (void)showDefaultText:(NSString *)text;


/**
 没有数据
 */
+ (void)showNoData;


/**
 没有更多数据
 */
+ (void)showNoOtherData;


@end
