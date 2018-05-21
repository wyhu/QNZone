//
//  QNExpressCompanyTableViewController.h
//  emark
//
//  Created by huweiya on 2018/5/6.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QNExpressCompanyResultBlock)(NSDictionary *dic);

@interface QNExpressCompanyTableViewController : UITableViewController

@property(nonatomic,copy) QNExpressCompanyResultBlock qnExpressCompanyResultBlock;

@end
