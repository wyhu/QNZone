//
//  QNSearchExpressCompanyTableViewController.h
//  emark
//
//  Created by huweiya on 2018/5/8.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^QNSearchExpressCompanyResultBlock)(NSDictionary *dic);

@interface QNSearchExpressCompanyTableViewController : UITableViewController
@property(nonatomic,copy) QNSearchExpressCompanyResultBlock qnSearchExpressCompanyResultBlock;

@end
