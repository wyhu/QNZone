//
//  QNMoreTableViewCell.h
//  emark
//
//  Created by huweiya on 2018/10/8.
//  Copyright © 2018 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QNMoreTableViewCell : UITableViewCell

+ (QNMoreTableViewCell *)cellForTableView:(UITableView *)tableView;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;


@end
