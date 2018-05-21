//
//  EMDiaryShowHeaderView.h
//  emark
//
//  Created by neebel on 2017/5/31.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMDiaryInfo.h"

@interface EMDiaryShowHeaderView : UITableViewHeaderFooterView

- (void)updateViewWithDiaryInfo:(EMDiaryInfo *)diaryInfo;

@end
