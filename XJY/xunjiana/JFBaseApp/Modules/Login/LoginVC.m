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
#import "CZPickerView.h"

@interface LoginVC () <LMJDropdownMenuDataSource,LMJDropdownMenuDelegate,CZPickerViewDelegate,CZPickerViewDataSource>
@property (nonatomic,strong)QMUITextField * keyfield;
@property (nonatomic,copy)NSString *loginID;
@property (nonatomic,copy)NSString *loginName;
@property (nonatomic,strong)LMJDropdownMenu *menuLabel;
@property (nonatomic,strong) UIButton *choseObj;
@end

@implementation LoginVC
{
    NSArray * _menu1OptionTitles;
    LMJDropdownMenu * menu1;
    NSArray *choseArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CViewBgColor;
    
    /*
   城南热电: 124.70.162.99:30080
   津西钢铁: 124.70.162.99:30081
   日照钢铁: 124.70.162.99:30082
   */
    choseArr = @[@{@"name":@"城南",@"url":@"http://124.70.162.99:30080"},@{@"name":@"津西",@"url":@"http://124.70.162.99:30081"},@{@"name":@"日照",@"url":@"http://124.70.162.99:30082"}];
           
    _menu1OptionTitles = @[];
    [self buildUI];
}
- (void)buildUI {

    menu1 = [[LMJDropdownMenu alloc] init];
    [menu1 setFrame:CGRectMake(0, 0, 150, 40)];
    menu1.dataSource = self;
    menu1.delegate   = self;
    self.menuLabel = menu1;
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
        f.secureTextEntry =  YES;
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
    
//    UIImageView *logo = [UIImageView new];
//    logo.image = [UIImage imageNamed:@"logoHD"];
//    [holdview addSubview:logo];
//    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(holdview);
//    }];
    
    
    UIButton *obj = [UIButton buttonWithType:UIButtonTypeCustom];
    [obj setTitleColor:CThemeColor forState:UIControlStateNormal];
    obj.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    obj.titleLabel.textAlignment = NSTextAlignmentCenter;
//    obj.titleLabel.text = @"请点击选择项目";
    [obj setTitle:@"请点击选择项目" forState:UIControlStateNormal];
    [holdview addSubview:obj];
    [obj mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(holdview);
    }];
    self.choseObj = obj;
    
    [obj addTarget:self action:@selector(objectChose) forControlEvents:UIControlEventTouchUpInside];
    
    
    
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
- (void)objectChose {
 
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"项目选择" cancelButtonTitle:@"自定义" confirmButtonTitle:@"确定"];
    picker.headerTitleFont = [UIFont systemFontOfSize: 20];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = NO;
    picker.headerBackgroundColor = [UIColor qmui_colorWithHexString:@"f4f4f7"];
    picker.headerTitleColor = [UIColor qmui_colorWithHexString:@"373940"];
    picker.headerTitleFont = UIFontMake(16);

    [picker showInView:self.view];
}
#pragma mark --- CZPickerDelegate datasource
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView
{
    return choseArr.count;
}
- (NSString *)czpickerView:(CZPickerView *)pickerView titleForRow:(NSInteger)row
{
    return [choseArr[row] objectForKey:@"name"];
}
- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemAtRow:(NSInteger)row {
//    self.choseObj.titleLabel.text = [choseArr[row] objectForKey:@"name"];
    [self.choseObj setTitle:[choseArr[row] objectForKey:@"name"] forState:UIControlStateNormal];
    NSString *url = [choseArr[row] objectForKey:@"url"];
    SaveApi(url);
    self.loginID = nil;
    self.loginName = nil;
    self.menuLabel.title = @"";
    self.keyfield.text = @"";
    [self loadData];
}
- (void)loadData{
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //默认的
//    NSString *url = [NSString stringWithFormat:@"%@/%@",NewApi,Login_people];
//    NSLog(@"%@",url);
       
    [manager GET:Login_people parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        _menu1OptionTitles = responseObject;
        [menu1 reloadOptionsData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

- (void)loginClick {
    if (!self.loginID) {
        [QMUITips showWithText:@"请选择登陆用户"];
        return;
    }
    
    if ([self.keyfield.text isEqualToString:@""]) {
        [QMUITips showWithText:@"请输入密码"];
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //默认的
    NSLog(@"%@",Login_in);
    [manager POST:Login_in parameters:@{@"inspector":self.loginID,@"password":self.keyfield.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse*)task.response;
        NSDictionary *dict = httpURLResponse.allHeaderFields;
        if (dict && dict[@"Authorization"]) {
            SaveToken(dict[@"Authorization"]);
            [kUserDefaults setValue:self.loginName forKey:@"loginName"];
            MainTabBarController *vc = [MainTabBarController new];
            AppDelegate *delegate = [AppDelegate shareAppDelegate];
            delegate.window.rootViewController = vc;
        }
        NSLog(@"%@",dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
    
    
    

}
 
#pragma mark - LMJDropdownMenu DataSource
- (NSUInteger)numberOfOptionsInDropdownMenu:(LMJDropdownMenu *)menu{
    return _menu1OptionTitles.count;
}
- (CGFloat)dropdownMenu:(LMJDropdownMenu *)menu heightForOptionAtIndex:(NSUInteger)index{
    return 35;
}
- (NSString *)dropdownMenu:(LMJDropdownMenu *)menu titleForOptionAtIndex:(NSUInteger)index{
    return [_menu1OptionTitles[index] valueForKey:@"name"];
}

#pragma mark - LMJDropdownMenu Delegate
- (void)dropdownMenu:(LMJDropdownMenu *)menu didSelectOptionAtIndex:(NSUInteger)index optionTitle:(NSString *)title{
    self.loginID = [NSString stringWithFormat:@"%@", [_menu1OptionTitles[index] valueForKey:@"id"]];
    self.loginName = StrFromDict(_menu1OptionTitles[index], @"name");
}

@end
