//
//  KJSearchBar.m
//  看见
//
//  Created by huweiya on 2018/4/25.
//  Copyright © 2018年 dongbin. All rights reserved.
//

#import "KJSearchBar.h"



@interface KJSearchBar()
<UITextFieldDelegate>
@property(nonatomic, assign) KJSearchBarStyle style;

@property(nonatomic, strong) UIButton *searchBtn;

@property(nonatomic, strong) UIButton *canceBtn;

@property(nonatomic, strong) UIView *searchView;

@end


@implementation KJSearchBar

- (instancetype)initWithFrame:(CGRect)frame style:(KJSearchBarStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        //锁定尺寸
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        //配置样式
        self.backgroundColor = [UIColor whiteColor];
        
        //取消按钮
        [self addSubview:self.canceBtn];
        [self.canceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(35);
            make.centerY.equalTo(self);
        }];
        
        
        //搜索框背景
        [self addSubview:self.searchView];
        [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(30);
            make.right.mas_equalTo(-15);
        }];
        

        //放大镜
        [self.searchView addSubview:self.searchBtn];
        
        [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_offset(0);
            make.width.height.equalTo(self.searchView.mas_height);
        }];
        
        //搜索框
        [self.searchView addSubview:self.textField];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_offset(10);
            make.right.equalTo(self.searchBtn.mas_left).mas_offset(0);
        }];
        
        
        [self.textField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];

        
        if (style == KJSearchBarStyleNormal) {
//            普通模式,只能点击,相当于按钮
            UIControl *ctrl = [[UIControl alloc] init];
            [self addSubview:ctrl];
            [ctrl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsZero);
            }];
            [ctrl addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (style == KJSearchBarStyleSearchButton){
            //fagn'da'jing

     
            
        }else if (style == KJSearchBarStyleCanceButton){
            //待取消按钮
            [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.top.mas_equalTo(10);
                make.height.mas_equalTo(30);
                make.right.equalTo(self.canceBtn.mas_left).mas_offset(-5);
            }];
  
        }else if (style == KJSearchBarStyleAutoCanceButton){
            //带自动隐藏的取消按钮
  
            [self.textField addTarget:self action:@selector(textFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];

        }
    }
    return self;
}

- (void)textFieldDidBegin:(UITextField *)textField{
    

    
    
        [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(30);
            make.right.equalTo(self.canceBtn.mas_left).mas_offset(-5);
        }];
    
    

}

- (void)textFieldTextChange:(UITextField *)textField{
    
    if (textField.markedTextRange == nil) {

        if (self.searchBarTextChangeBlock) {
            self.searchBarTextChangeBlock([self removeSpaces:textField.text]);
        }
        
    }
    
}


- (UIButton *)canceBtn{
    if (!_canceBtn) {
        _canceBtn = [[UIButton alloc] init];
        [_canceBtn setTitle:@" 取消" forState:0];
        [_canceBtn setTitleColor:[EMTheme currentTheme].navBarBGColor forState:0];
        _canceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_canceBtn addTarget:self action:@selector(canceBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_canceBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        
    }
    return _canceBtn;
}

- (void)canceBtnClick{
    
    if (self.searchBarCanceButtonClickBlock) {
        self.searchBarCanceButtonClickBlock();
    }
}

- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc] init];
        _searchView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _searchView.layer.masksToBounds = YES;
        _searchView.layer.cornerRadius = 6.0;
        
    }
    return _searchView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.placeholder = @"搜索";
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.delegate = self;
        
    }
    return _textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [self btnClick];
    return YES;
}

- (UIButton *)searchBtn
{
    if (!_searchBtn) {

        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_searchBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 7.5, 15, 15)];
        imgV.image = [UIImage imageNamed:@"搜索1"];
        [_searchBtn addSubview:imgV];
    }
    return _searchBtn;
}

- (void)btnClick{
    
 
    if (self.searchBarButtonClickBlock) {
        
        if (self.style == KJSearchBarStyleNormal) {
            self.searchBarButtonClickBlock(nil);
        }else{
            
            if ([self removeSpaces:self.textField.text].length > 0) {
                self.searchBarButtonClickBlock([self removeSpaces:self.textField.text]);
                
            }

        }
        
    }
    
}


- (NSString *)removeSpaces:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end


