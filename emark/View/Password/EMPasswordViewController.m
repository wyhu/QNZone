//
//  EMPasswordViewController.m
//  emark
//
//  Created by huweiya on 2018/4/30.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "EMPasswordViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface EMPasswordViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;


@property (nonatomic, strong) NSMutableDictionary *dataDic;


@end

@implementation EMPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"密码本", nil);
    self.view.backgroundColor = [EMTheme currentTheme].mainBGColor;
    
//    [self evaluateAuthenticate];

    [self touchIDAction:nil];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录密码本" style:0 target:self action:@selector(touchIDAction:)];

//    [self add:@"666666" pass:@"举例：微信号"];
//    [self add:@"888888" pass:@"QQ"];
//    [self add:@"66668888" pass:@"微博账号"];
    
    self.mainTableView.hidden = YES;
    [self.view addSubview:self.mainTableView];
    
    
}


- (NSDictionary *)forDataDic
{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *path=[paths objectAtIndex:0];
    
    
    NSString *filename=[path stringByAppendingPathComponent:@"mainData.plist"];   //获取路径
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filename];
    
    
    return dic;
}

- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionaryWithDictionary:[self forDataDic]];
    }
    return _dataDic;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.dataDic = [NSMutableDictionary dictionaryWithDictionary:[self forDataDic]];
    
    [self.mainTableView reloadData];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    
    headerV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 30)];
    
    label1.text = @"账号";
    
    [headerV addSubview:label1];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 0, 80, 30)];
    
    label2.text = @"密码";
    
    label2.textAlignment = NSTextAlignmentRight;
    
    [headerV addSubview:label2];
    
    
    return headerV;
}


- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        
        _mainTableView.tableFooterView = [[UIView alloc] init];
        
        _mainTableView.backgroundColor = [UIColor whiteColor];
        
        _mainTableView.dataSource = self;
        
        _mainTableView.delegate = self;
    }
    
    return _mainTableView;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.dataDic allValues].count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//        [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(32, 32));
//            make.left.mas_equalTo(10);
//            make.centerY.equalTo(cell);
//        }];
//        cell.imageView.image = [UIImage imageNamed:@"账号添加"];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    }
        
    NSDictionary *dic = [self.dataDic allValues][indexPath.row];
    
    cell.textLabel.text = dic[@"count"];
    
    cell.detailTextLabel.text = dic[@"countPass"];;
    
    return cell;
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {//title可自已定义
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cance = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [tableView reloadData];
            
            //            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }];
        
        
        UIAlertAction *dele = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            [self.dataDic removeObjectForKey:cell.textLabel.text];
            
            [self.dataDic removeObjectForKey:cell.textLabel.text];
            
            [self.dataDic writeToFile:[self getDataPath] atomically:YES];
            
            [tableView reloadData];
            
            
        }];
        
        
        [alert addAction:dele];
        
        [alert addAction:cance];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
        
    }];
    //此处是iOS8.0以后苹果最新推出的api，UITableViewRowAction，Style是划出的标签颜色等状态的定义，这里也
    
    
    
    //    可自行定义
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSString *zhanghao = cell.textLabel.text;
        
        NSString *mima = cell.detailTextLabel.text;
        
        [self addMiMa:zhanghao mima:mima];
        
    }];
    
    
    
    editRowAction.backgroundColor = [UIColor colorWithRed:0 green:124/255.0 blue:223/255.0 alpha:1];//可以定义RowAction的颜色
    
    return @[deleteRoWAction, editRowAction];//最后返回这俩个RowAction 的数组
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    

    
}


#pragma mark 新增密码
- (void)addMiMa:(NSString *)zhanghao mima:(NSString *)mima{
    
    
    UIAlertController *passAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入新的账号和密码" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.mainTableView reloadData];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *field1 = passAlert.textFields[0];
        
        UITextField *field2 = passAlert.textFields[1];
        
        
        if (field1.text.length >0 && field2.text.length > 0) {
            
            
            [self add:field2.text pass:field1.text];
        }else{
            
            //什么也不做
            
            
        }
        
        
        
    }];
    
    
    
    
    [passAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入账号！";
        if ([zhanghao isKindOfClass:[NSString class]]) {
            textField.text = zhanghao;
            textField.enabled = NO;
        }
        
        
    }];
    
    
    
    
    [passAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入密码！";
        
        if ([mima isKindOfClass:[NSString class]]) {
            textField.text = mima;
            
            [textField becomeFirstResponder];
        }
        
    }];
    
    
    
    
    [passAlert addAction:action2];
    
    [passAlert addAction:action3];
    
    
    [self presentViewController:passAlert animated:YES completion:^{
        
    }];
    
    
    
}



- (NSString*)stringFromDate:(NSDate*)date withFormatter:(NSString *)formatter;

{
    
    if (!formatter) {
        formatter = @"yyyy-MM-dd HH:mm:ss zzz";
    }
    
    //用于格式化NSDate对象
    
    NSDateFormatter *dateFormatte=[[NSDateFormatter alloc]init];
    
    [dateFormatte setDateFormat:formatter];
    
    //NSDate转NSString
    
    NSString *currentDateString=[dateFormatte stringFromDate:date];
    
    //输出currentDateString
    
    return currentDateString;
    
}




- (void)add:(NSString *)pass pass:(NSString *)obj{
    
    
    NSMutableDictionary *litterDic = [NSMutableDictionary dictionary];
    
    [litterDic setObject:obj forKey:@"count"];
    
    [litterDic setObject:pass forKey:@"countPass"];
    
    [litterDic setObject:[self stringFromDate:[NSDate date] withFormatter:@"yyyy-MM-dd HH:mm:ss"] forKey:@"countTime"];
    
    [self.dataDic setObject:litterDic forKey:obj];
    
    [self.dataDic writeToFile:[self getDataPath] atomically:YES];
    
    [self.mainTableView reloadData];
    
}

- (NSString *)getDataPath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *path=[paths objectAtIndex:0];
    
    
    NSString *filename=[path stringByAppendingPathComponent:@"mainData.plist"];   //获取路径
    
    return filename;
}




//指纹登陆
- (void)touchIDAction:(UIButton *)sender {
    
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"选择登录方式" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
//    alertCtrl.popoverPresentationController.sourceView = self.view;
//    alertCtrl.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"指纹登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //iOS8.0后才支持指纹识别接口
        if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
            return;
        }
        
        [self evaluateAuthenticate];
    }];
    [alertCtrl addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"密码登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clickPasswordAction:nil message:@"请输入登录密码"];
    }];
    [alertCtrl addAction:action2];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertCtrl addAction:action3];
    
}

//指纹解锁相关
- (void)evaluateAuthenticate
{
    
    //创建LAContext
    LAContext* context = [[LAContext alloc] init];
    NSError* error = nil;
    NSString* result = @"请验证已有指纹！";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    //切换主控制器
                    
                    self.mainTableView.hidden = NO;
                    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publishDiary"] style:0 target:self action:@selector(addMiMa:mima:)];


                }];
                
                
            }
            else
            {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        //系统取消授权，如其他APP切入
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        //授权失败
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        
                        
                        //系统未设置密码
                        break;
                    }
                    case LAErrorTouchIDNotAvailable:
                    {
                        //设备Touch ID不可用，例如未打开
                        break;
                    }
                    case LAErrorTouchIDNotEnrolled:
                    {
                        //设备Touch ID不可用，用户未录入
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            
                            [self clickPasswordAction:nil message:nil];
                            
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                            
                            
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        //不支持指纹识别，LOG出错误详情
        NSLog(@"不支持指纹识别");
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        UIAlertController *passAlert = [UIAlertController alertControllerWithTitle:@"提示" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        
        [passAlert addAction:action2];
        
        
        [self presentViewController:passAlert animated:YES completion:nil];
        
        NSLog(@"%@",error.localizedDescription);
    }
}




#pragma mark 密码登陆
- (IBAction)clickPasswordAction:(UIButton *)sender message:(NSString *)mess{
    
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    
    NSString *message;
    
    
    if ([mess isKindOfClass:[NSString class]] && mess.length > 0) {
        
        message = mess;
        
    }else{
        
        message = @"请输入密码！";
        
        if (!password) {
            message = @"首次使用请设置密码！";
        }
        
    }
    
    
    
    //存在
    
    
    UIAlertController *passAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (!password) {
            
            UITextField *field1 = passAlert.textFields[0];
            
            UITextField *field2 = passAlert.textFields[1];
            
            if ([field1.text isEqualToString:field2.text] && field1.text.length > 0) {
                
                [[NSUserDefaults standardUserDefaults] setObject:field2.text forKey:@"password"];
                
                [self clickPasswordAction:nil message:nil];
                
                
            }else{
                
                [self clickPasswordAction:nil message:@"请保证两次输入的密码一致或密码格式正确！"];
            }
            
        }else{
            //有密码
            UITextField *field1 = passAlert.textFields[0];
            
            if ([field1.text isEqual:password]) {
                
                
                self.mainTableView.hidden = NO;
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publishDiary"] style:0 target:self action:@selector(addMiMa:mima:)];

                
            }else{
                
                [self clickPasswordAction:nil message:@"请输入正确的密码！"];
                
            }
            
        }
        
        
    }];
    
    
    
    
    [passAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入密码！";
        
    }];
    
    
    
    if (!password) {
        [passAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"请确认密码！";
            
        }];
        
    }
    
    
    [passAlert addAction:action2];
    
    [passAlert addAction:action3];
    
    
    [self presentViewController:passAlert animated:YES completion:^{
        
    }];
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
