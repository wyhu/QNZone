//
//  EMSettingViewController.m
//  emark
//
//  Created by neebel on 2017/5/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMSettingViewController.h"
#import "EMSettingTableViewCell.h"
#import "EMSettingHeaderView.h"
#import "EMHomeManager.h"
#import "EMSettingActionSheet.h"
#import "EMHomeManager.h"
#import "EMAboutUsViewController.h"
#import "FSMediaPicker.h"
#import "EMShowPhotoTool.h"
#import <UShareUI/UShareUI.h>
#import "EMDeviceUtil.h"
#import "QNEveryDayPicViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "EMHelpViewController.h"

@interface EMSettingViewController ()<UITableViewDelegate, UITableViewDataSource, EMSettingActionSheetDelegate, FSMediaPickerDelegate, EMSettingHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *settingItemArr;
@property (nonatomic, strong) EMSettingActionSheet *actionSheet;
@property (nonatomic, strong) EMHomeHeadInfo *headInfo;
@property (nonatomic, strong) EMShowPhotoTool *tool;


@property (nonatomic, strong) CMMotionManager *motionManager;

@end

static NSString *settingTableViewCellIdentifier = @"settingTableViewCellIdentifier";
static NSString *settingTableViewHeaderViewIdentifier = @"settingTableViewHeaderViewIdentifier";

@implementation EMSettingViewController

#pragma mark - LifeCycle

- (CMMotionManager *)motionManager
{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return _motionManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"设置", nil);
    [self.view addSubview:self.tableView];
    [self loadData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:0 target:self action:@selector(shareClick)];
    
    UIButton *dayPicBtn = [[UIButton alloc] init];
    dayPicBtn.layer.cornerRadius = 45/2;
    dayPicBtn.layer.masksToBounds = YES;
    dayPicBtn.layer.borderWidth = 3.0;
    dayPicBtn.layer.borderColor = [EMTheme currentTheme].navBarBGColor.CGColor;
    [dayPicBtn setImage:[UIImage imageNamed:@"每日图片"] forState:0];
    [self.view insertSubview:dayPicBtn aboveSubview:self.tableView];
    [dayPicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-100);
        make.right.mas_equalTo(-30);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    [dayPicBtn addTarget:self action:@selector(dayPicBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}


- (void)dayPicBtnClick{
    
    QNEveryDayPicViewController *vc = [[QNEveryDayPicViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    

    
    
}

- (void)shareClick{
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType];
    }];
    
    
}


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"%@-%@",[EMDeviceUtil sharedDevice].appName,NSLocalizedString(@"记录从此更便捷", nil)] descr:NSLocalizedString(@"记录从此更便捷", nil) thumImage:[EMDeviceUtil sharedDevice].appIcon];
    //设置网页地址
    NSString *url = @"https://itunes.apple.com/us/app/%E9%9D%92%E6%9F%A0book-%E8%AE%B0%E5%BD%95%E4%BB%8E%E6%AD%A4%E6%9B%B4%E4%BE%BF%E6%8D%B7/id1380559614?l=zh&ls=1&mt=8";
    shareObject.webpageUrl =url;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        
    }];
}


- (void)dealloc
{
    _motionManager = nil;

    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}


#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[EMSettingTableViewCell class]
           forCellReuseIdentifier:settingTableViewCellIdentifier];
        [_tableView registerClass:[EMSettingHeaderView class] forHeaderFooterViewReuseIdentifier:settingTableViewHeaderViewIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}


- (NSArray *)settingItemArr
{
    if (!_settingItemArr) {
        _settingItemArr = @[NSLocalizedString(@"更换头像", nil), NSLocalizedString(@"关于我们", nil), NSLocalizedString(@"支持一下", nil),@"您想要什么样的工具？告诉我",@"帮助"];
    }
    
    return _settingItemArr;
}


- (EMSettingActionSheet *)actionSheet
{
    if (!_actionSheet) {
        _actionSheet = [[EMSettingActionSheet alloc] init];
        _actionSheet.delegate = self;
    }
    
    return _actionSheet;
}


- (EMHomeHeadInfo *)headInfo
{
    if (!_headInfo) {
        _headInfo = [[EMHomeHeadInfo alloc] init];
    }
    
    return _headInfo;
}


- (EMShowPhotoTool *)tool
{
    if (!_tool) {
        _tool = [[EMShowPhotoTool alloc] init];
    }
    
    return _tool;
}

#pragma mark - Action

- (void)jumpAction:(NSIndexPath *)indexPath
{
    NSString *title = self.settingItemArr[indexPath.row];
    
    if ([title isEqualToString:NSLocalizedString(@"更换头像", nil)]) {
        [self selectHead];
    } else if ([title isEqualToString:NSLocalizedString(@"关于我们", nil)]) {
        EMAboutUsViewController *aboutUsVC = [[EMAboutUsViewController alloc] init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    } else if ([title isEqualToString:NSLocalizedString(@"支持一下", nil)]) {
        
        
        NSString *url = @"https://itunes.apple.com/us/app/%E9%9D%92%E6%9F%A0book-%E8%AE%B0%E5%BD%95%E4%BB%8E%E6%AD%A4%E6%9B%B4%E4%BE%BF%E6%8D%B7/id1380559614?l=zh&ls=1&mt=8";
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[self URLEncodedString:url]]]) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self URLEncodedString:url]]];
            
        }
        
    }else if ([title isEqualToString:@"帮助"]){
        
      EMHelpViewController  *vc = [[EMHelpViewController alloc] init];
        vc.title = @"帮助";
        vc.urlStr = @"http://a2.rabbitpre.com/m/NFRVVna";
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        NSString *url = @"https://itunes.apple.com/us/app/%E9%9D%92%E6%9F%A0book-%E8%AE%B0%E5%BD%95%E4%BB%8E%E6%AD%A4%E6%9B%B4%E4%BE%BF%E6%8D%B7/id1380559614?l=zh&ls=1&mt=8";
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[self URLEncodedString:url]]]) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self URLEncodedString:url]]];
            
        }
    }
}


- (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}


#pragma mark - Private

- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [[EMHomeManager sharedManager] fetchHeadInfoWithResultBlock:^(EMResult *result) {
        weakSelf.headInfo = result.result;
        [weakSelf.tableView reloadData];
    }];
}


- (void)selectHead
{
    [self.actionSheet show];
}


- (void)checkAuthorizationWithType:(EMSettingHeadImageType)type complete:(void (^) ())complete
{
    switch (type) {
        case kEMSettingHeadImageTypeCamera: //检查相机授权
        {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                switch (authStatus) {
                    case AVAuthorizationStatusAuthorized:
                        if (complete) {
                            complete();
                        }
                        break;
                    case AVAuthorizationStatusNotDetermined:
                    {
                        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                            dispatch_async_in_main_queue(^{
                                if (granted && complete) {
                                    complete();
                                }
                            });
                        }];
                    }
                        break;
                    default:
                    {
                        [self.view showMultiLineMessage:NSLocalizedString(@"请在iPhone的\"设置-隐私-相机\"选项中，允许EMark访问你的相机", nil)];
                    }
                        break;
                }
            } else {
                [EMTips show:NSLocalizedString(@"您的设备不支持拍照", nil)];
            }
        }
            break;
        case kEMSettingHeadImageTypeAlbum: //检查相册授权
        {
            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
            switch (status) {
                case ALAuthorizationStatusNotDetermined:
                case ALAuthorizationStatusAuthorized:
                    if (complete) {
                        complete();
                    }
                    break;
                default:
                {
                    [self.view showMultiLineMessage:NSLocalizedString(@"请在iPhone的\"设置-隐私-照片\"选项中，允许EMark访问你的相册", nil)];
                }
                    break;
            }
        }
            break;
        default:
            break;
    }
}


- (void)refreshHead:(UIImage *)image
{
    self.headInfo.headImage = image;
    [[EMHomeManager sharedManager] cacheHeadInfo:self.headInfo];
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settingItemArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingTableViewCellIdentifier
                                                                   forIndexPath:indexPath];
    [cell updateCellWithTitle:self.settingItemArr[indexPath.row]];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    EMSettingHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:settingTableViewHeaderViewIdentifier];
    [headerView updateViewWithImage:self.headInfo.headImage];
    headerView.delegate = self;
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self jumpAction:indexPath];
}

#pragma mark - EMSettingActionSheetDelegate

- (void)takePhoto
{
    __weak typeof(self) weakSelf = self;
    [self checkAuthorizationWithType:kEMSettingHeadImageTypeCamera complete:^{
        FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] initWithDelegate:weakSelf];
        mediaPicker.mediaType = FSMediaTypePhoto;
        mediaPicker.editMode = FSEditModeStandard;
        [mediaPicker takePhotoFromCamera];
    }];
}


- (void)searchFromAlbum
{
    __weak typeof(self) weakSelf = self;
    [self checkAuthorizationWithType:kEMSettingHeadImageTypeAlbum complete:^{
        FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] initWithDelegate:weakSelf];
        mediaPicker.mediaType = FSMediaTypePhoto;
        mediaPicker.editMode = FSEditModeStandard;
        [mediaPicker takePhotoFromPhotoLibrary];
    }];
}

#pragma mark - FSMediaPickerDelegate

- (void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo
{
    [self refreshHead:mediaInfo.editedImage];
}

#pragma mark - EMSettingHeaderViewDelegate

- (void)lookBigImage
{
    UIImage *image = self.headInfo.headImage ? self.headInfo.headImage : [UIImage imageNamed:@"headDefault"];
    [self.tool showWithImage:image];
}

@end
