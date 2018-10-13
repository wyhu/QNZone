//
//  UIImage+Additions.h
//  emark
//
//  Created by neebel on 2017/6/10.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

- (UIImage *)aspectResizeWithWidth:(CGFloat)width;

/**
 动态获取启动图
 
 @return 启动图
 */
+ (UIImage *)launchImage;

/**
 获取APPicon
 
 @return 获取APPicon
 */
+ (UIImage *)appIcon;


@end
