//
//  LoginVC.m
//  cheyijia
//
//  Created by Jeff Xu on 2019/7/20.
//  Copyright © 2019 Jeff Xu. All rights reserved.
//

#import "LoginVC.h"

#import "LMJDropdownMenu.h"
#import "MainTabBarController.h"
#import "AppDelegate+Service.h"
@interface LoginVC () <LMJDropdownMenuDataSource,LMJDropdownMenuDelegate>
@property (nonatomic,strong)QMUITextField * keyfield;
@end

@implementation LoginVC
{
    NSArray * _menu1OptionTitles;
    LMJDropdownMenu * menu1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CViewBgColor;
    
    _menu1OptionTitles = @[@"猴子",@"白羊",@"田园猫",@"薄荷猫",@"蓝猫",@"鼠来宝",@"仓鼠王",@"蓝莓",@"西瓜",@"薄荷",@"猴子",@"白羊",@"田园猫",@"薄荷猫",@"蓝猫",@"鼠来宝",@"仓鼠王",@"蓝莓",@"西瓜",@"薄荷"];
    [self buildUI];
}
- (void)buildUI {

    menu1 = [[LMJDropdownMenu alloc] init];
    [menu1 setFrame:CGRectMake(0, 0, 150, 40)];
    menu1.dataSource = self;
    menu1.delegate   = self;
    
    [self.view addSubview:menu1];
    [menu1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).offset(10);
        make.centerY.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(180, 50));
    }];
    
    menu1.layer.borderColor  = CThemeColor.CGColor;
    menu1.layer.borderWidth  = 2;
    menu1.layer.cornerRadius = 5;
    
    menu1.title           = @"请选择人员";
    menu1.titleBgColor    = KWhiteColor;
    menu1.titleFont       = [UIFont boldSystemFontOfSize:19];
    menu1.titleColor      = [UIColor blackColor];
    menu1.titleAlignment  = NSTextAlignmentLeft;
    menu1.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    
    menu1.rotateIcon      = [UIImage imageNamed:@"arrowdown"];
    menu1.rotateIconSize  = CGSizeMake(8, 8);
    
    menu1.optionBgColor         = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
    menu1.optionFont            = [UIFont systemFontOfSize:14];
    menu1.optionTextColor       = [UIColor blackColor];
    menu1.optionTextAlignment   = NSTextAlignmentLeft;
    menu1.optionNumberOfLines   = 0;
    menu1.optionLineColor       = [UIColor whiteColor];
    menu1.optionIconSize        = CGSizeMake(15, 15);
    menu1.optionIconMarginRight = 30;
    menu1.optionsListLimitHeight = KScreenHeight * 0.35;
    
    UIImageView *account = [UIImageView new];
    account.image = [UIImage imageNamed:@"account"];
    [self.view addSubview:account];
    [account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(menu1);
        make.right.mas_equalTo(menu1.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    self.keyfield = ({
        QMUITextField *f = [QMUITextField new];
        f.placeholder = @"请输入密码";
        f.font = UIFontMake(18);
        f.layer.borderColor  = CThemeColor.CGColor;
        f.layer.borderWidth  = 2;
        f.layer.cornerRadius = 5;
        f.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        f.clearButtonMode = UITextFieldViewModeAlways;
        f.backgroundColor = KWhiteColor;
        f;
    });
    [self.view addSubview:self.keyfield];
    [_keyfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(menu1);
        make.top.mas_equalTo(menu1.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(180, 50));
    }];
    
    UIImageView *keyimg = [UIImageView new];
    keyimg.image = [UIImage imageNamed:@"keyword"];
    [self.view addSubview:keyimg];
    [keyimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.keyfield);
        make.right.mas_equalTo(self.keyfield.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    QMUIButton *button = [QMUIButton new];
    button.adjustsButtonWhenHighlighted = YES;
    button.titleLabel.font = UIFontBoldMake(22);
    [button setTitleColor:UIColorWhite forState:UIControlStateNormal];
    button.backgroundColor = CThemeColor;
    button.layer.cornerRadius = 6;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-80);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth*0.65, 50));
    }];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *holdview = [UIView new];
    [self.view addSubview:holdview];
    [holdview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(menu1.mas_top);
    }];
    
    UIImageView *logo = [UIImageView new];
    logo.image = [UIImage imageNamed:@"logoHD"];
    [holdview addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(holdview);
    }];
    
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, KScreenHeight-50, KScreenWidth, 50)];
    tip.textAlignment = NSTextAlignmentCenter;
    tip.textColor = KGrayColor;
    tip.font = SYSTEMFONT(13);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    tip.text = NSStringFormat(@"Version: v%@",app_Version);
    [self.view addSubview:tip];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//
//    NSString *oldaccount = [kUserDefaults objectForKey:@"oldAccount"];
//    if (oldaccount) {
//        self.phoneboard.text = oldaccount;
//    }
}
- (void)loginClick {
    MainTabBarController *vc = [MainTabBarController new];
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    delegate.window.rootViewController = vc;
}
 
#pragma mark - LMJDropdownMenu DataSource
- (NSUInteger)numberOfOptionsInDropdownMenu:(LMJDropdownMenu *)menu{
    return _menu1OptionTitles.count;
}
- (CGFloat)dropdownMenu:(LMJDropdownMenu *)menu heightForOptionAtIndex:(NSUInteger)index{
    return 35;
}
- (NSString *)dropdownMenu:(LMJDropdownMenu *)menu titleForOptionAtIndex:(NSUInteger)index{
    return _menu1OptionTitles[index];
}

#pragma mark - LMJDropdownMenu Delegate
- (void)dropdownMenu:(LMJDropdownMenu *)menu didSelectOptionAtIndex:(NSUInteger)index optionTitle:(NSString *)title{

}

@end
