//
//  EMHomeCollectionViewCell.m
//  emark
//
//  Created by neebel on 2017/5/26.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMHomeCollectionViewCell.h"

@interface EMHomeCollectionViewCell()


@end

@implementation EMHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.menuLabel];
        __weak typeof(self) weakSelf = self;
        [self.menuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView);
        }];
    }

    return self;
}


- (UILabel *)menuLabel
{
    if (!_menuLabel) {
        _menuLabel = [[UILabel alloc] init];
        _menuLabel.textAlignment = NSTextAlignmentCenter;
        _menuLabel.textColor = [UIColor whiteColor];
        _menuLabel.font = [UIFont boldSystemFontOfSize:20.0];
    }
    
    return _menuLabel;
}














@end
