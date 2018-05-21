//
//  EMTheme.h
//  emark
//
//  Created by neebel on 2017/5/26.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@interface EMTheme : NSObject

@property (nonatomic, strong) UIColor *navBarBGColor;
@property (nonatomic, strong) UIColor *navTintColor;
@property (nonatomic, strong) UIColor *mainBGColor;
@property (nonatomic, strong) UIColor *dividerColor;
@property (nonatomic, strong) UIColor *navTitleColor;
@property (nonatomic, strong) UIFont  *navTitleFont;


+ (instancetype)currentTheme;

UIColor * UIColorFromHexARGB(CGFloat alpha, NSInteger hexRGB);
UIColor * UIColorFromHexRGB(NSInteger hexColor);
UIColor * UIColorFromRGB(NSInteger r,NSInteger g,NSInteger b);
UIColor * UIColorFromRGBAString(NSString *rgbaString);

@end
