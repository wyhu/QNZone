//
//  QNActivityTableViewCell.m
//  emark
//
//  Created by huweiya on 2018/7/19.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "QNActivityTableViewCell.h"

@implementation QNActivityTableViewCell

+ (QNActivityTableViewCell *)cellForTableView:(UITableView *)tableView withIden:(NSString *)iden{
    QNActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QNActivityTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
//    self.mainImgView.contentMode = UIViewContentModeScaleAspectFill;
            self.mainImgView.layer.cornerRadius = 10;
            self.mainImgView.layer.masksToBounds = YES;
            self.mainImgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            self.mainImgView.layer.borderWidth = 0.5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
