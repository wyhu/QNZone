//
//  QNMoreTableViewCell.m
//  emark
//
//  Created by huweiya on 2018/10/8.
//  Copyright © 2018 neebel. All rights reserved.
//

#import "QNMoreTableViewCell.h"

@implementation QNMoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (QNMoreTableViewCell *)cellForTableView:(UITableView *)tableView{
    
    QNMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QNMoreTableViewCell"];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QNMoreTableViewCell" owner:nil options:nil] lastObject];
        cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imgView.clipsToBounds = YES;
        cell.imgView.layer.cornerRadius = 5.0;
        
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
