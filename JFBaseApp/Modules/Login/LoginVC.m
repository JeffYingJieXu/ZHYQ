//
//  LoginVC.m
//  cheyijia
//
//  Created by Jeff Xu on 2019/7/20.
//  Copyright © 2019 Jeff Xu. All rights reserved.
//

#import "LoginVC.h"
//#import "WHGradientHelper.h"
#import "JFWkWebView.h"
#import "RegisterVC.h"
#import "ForgetKeyVC.h"


@interface LoginVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *keyboard;
@property (weak, nonatomic) IBOutlet UITextField *phoneboard;

@property (weak, nonatomic) IBOutlet UIButton *agreeTK;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.isHidenNaviBar = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.StatusBarStyle = UIStatusBarStyleLightContent;
    self.isShowLiftBack = NO;
    self.keyboard.delegate = self;
   
}
- (IBAction)dismissPage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *oldaccount = [kUserDefaults objectForKey:@"oldAccount"];
    if (oldaccount) {
        self.phoneboard.text = oldaccount;
    }
}
- (IBAction)zuce:(id)sender {

    RegisterVC *vc = [RegisterVC new];
    vc.modalPresentationStyle = 0;
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)setmima:(id)sender {
    ForgetKeyVC *vc = [ForgetKeyVC new];
    vc.modalPresentationStyle = 0;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)loginClick:(id)sender {
    [self.view endEditing:YES];
    
    if (!StrValid(self.phoneboard.text)) {
        [QMUITips showWithText:@"请输入手机号"];return;}
    
    if (!StrValid(self.keyboard.text)) {
        [QMUITips showWithText:@"请输入密码"];return;}
    if (!self.agreeTK.selected) {
        [QMUITips showWithText:@"请阅读并同意\n《用户隐私政策》《用户服务协议》"];return;}
    
    NSDictionary *param = @{@"param":self.phoneboard.text,
                            @"password":self.keyboard.text,
                            @"type":@"phone",@"pushId":@"pushStr"};
    [QMUITips showLoadingInView:self.view];
    [userManager login:kUserLoginTypePwd params:param completion:^(BOOL success, NSString *des) {
        
        if (success) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [QMUITips showError:des];
        }
    }];
    
}
- (IBAction)makeKeySee:(UIButton *)sender {
    self.keyboard.secureTextEntry = !self.keyboard.secureTextEntry;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    return [textField resignFirstResponder];
}


- (IBAction)agreeFuwuTiaokuan:(UIButton *)sender {
    self.agreeTK.selected = !self.agreeTK.selected;
}

- (IBAction)yinsizhengce:(id)sender {
    JFWkWebView *web = [JFWkWebView new];
    web.urlStr = @"https://ahb.kunyue2019.com/ahb_privacy.html";
    web.pageTitle = @"隐私政策";
    web.modalPresentationStyle = 0;
    [self presentViewController:web animated:YES completion:nil];
}

- (IBAction)fuwuTiaokuan:(id)sender {
    JFWkWebView *web = [JFWkWebView new];
    web.urlStr = @"https://ahb.kunyue2019.com/ahb_agreement.html";
    web.pageTitle = @"服务协议";
    web.modalPresentationStyle = 0;
    [self presentViewController:web animated:YES completion:nil];
}

//- (IBAction)goBackPage:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//}


@end
