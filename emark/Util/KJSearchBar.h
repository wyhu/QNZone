//
//  KJSearchBar.h
//  看见
//
//  Created by huweiya on 2018/4/25.
//  Copyright © 2018年 dongbin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, KJSearchBarStyle) {
    KJSearchBarStyleNormal = 0,//普通模式,只能点击,相当于按钮
    KJSearchBarStyleSearchButton = 1,//带放大镜
    KJSearchBarStyleCanceButton = 2,//带取消按钮
    KJSearchBarStyleAutoCanceButton = 3//带自动隐藏的取消按钮
};


typedef void(^searchBarButtonClickBlock)(NSString *result);

typedef void(^searchBarTextChangeBlock)(NSString *reslut);

typedef void(^searchBarCanceButtonClickBlock)();


@interface KJSearchBar : UIControl


- (instancetype)initWithFrame:(CGRect)frame style:(KJSearchBarStyle)style;


@property(nonatomic, strong) UITextField *textField;

/**
 放大镜按钮回调：放大镜
 */
@property(nonatomic, copy) searchBarButtonClickBlock searchBarButtonClickBlock;


/**
 取消按钮回调
 */
@property(nonatomic, copy) searchBarCanceButtonClickBlock searchBarCanceButtonClickBlock;



/**
 文本变化监听
 */
@property(nonatomic, copy) searchBarTextChangeBlock searchBarTextChangeBlock;




@end
