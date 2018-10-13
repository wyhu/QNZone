//
//  QNActivityTableViewCell.h
//  emark
//
//  Created by huweiya on 2018/7/19.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QNActivityTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *mainImgView;

@property (strong, nonatomic) IBOutlet UILabel *titleLable;

+ (QNActivityTableViewCell *)cellForTableView:(UITableView *)tableView withIden:(NSString *)iden;






@end
