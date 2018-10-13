//
//  EMTheme.m
//  emark
//
//  Created by neebel on 2017/5/26.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMTheme.h"
#import "HexColors.h"
@implementation EMTheme

- (instancetype)init
{
    self = [super init];
    if (self) {
   
        _mainBGColor = [UIColor whiteColor];
        _navTintColor = [UIColor whiteColor];

        _navBarBGColor = UIColorFromRGB(55, 166, 231);
        _navTitleColor = [UIColor whiteColor];
        _navTitleFont = [UIFont boldSystemFontOfSize:18.0];
        _dividerColor = [UIColor whiteColor];

    }
    
    return self;
}

#pragma mark - Public

+ (instancetype)currentTheme
{
    static EMTheme *_theme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theme = [[self alloc] init];
    });
    
    return _theme;
}


UIColor * UIColorFromHexARGB(CGFloat alpha, NSInteger hexRGB)
{
    return [UIColor colorWithRed:((float)((hexRGB & 0xFF0000) >> 16))/255.0
                           green:((float)((hexRGB & 0xFF00) >> 8))/255.0
                            blue:((float)(hexRGB & 0xFF))/255.0
                           alpha:alpha];
}


UIColor * UIColorFromHexRGB(NSInteger hexRGB)
{
    return UIColorFromHexARGB(1, hexRGB);
}

UIColor * UIColorFromRGB(NSInteger r,NSInteger g,NSInteger b)
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

UIColor * UIColorFromRGBAString(NSString *rgbaString)
{
    return [UIColor hx_colorWithHexRGBAString:rgbaString];
}



@end
