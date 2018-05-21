//
//  JMTabBarBadgeValue.h
//  JMTabBarController
//
//  Created by huweiya on 2018/2/2.
//  Copyright © 2018年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, JMTabBarBadgeValueType) {
    JMTabBarBadgeValueTypePoint, //点
    JMTabBarBadgeValueTypeNew, //new
    JMTabBarBadgeValueTypeNumber, //number
};
@interface JMTabBarBadgeValue : UIView

/** badgeL */
@property (nonatomic, strong) UILabel *badgeL;

/** type */
@property (nonatomic, assign) JMTabBarBadgeValueType type;


@end
