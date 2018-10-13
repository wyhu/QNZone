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
        __weak typeof(self) weakSelf = self;

        
        [self.contentView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView);
        }];
        
        [self.contentView addSubview:self.menuLabel];
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
        _menuLabel.textColor = [EMTheme currentTheme].navBarBGColor;
        _menuLabel.font = [UIFont boldSystemFontOfSize:22.0];
    }
    
    return _menuLabel;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.masksToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
//        _imgView.layer.cornerRadius = 10.0;
    }
    return _imgView;
}



@end
