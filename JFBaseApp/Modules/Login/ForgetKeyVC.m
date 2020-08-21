//
//  ForgetKeyVC.m
//  cheyijia
//
//  Created by Jeff Xu on 2019/7/22.
//  Copyright © 2019 Jeff Xu. All rights reserved.
//

#import "ForgetKeyVC.h"
//#import "WHGradientHelper.h"

@interface ForgetKeyVC ()<UITextFieldDelegate>
{
    NSTimer *messsageTimer;
    int messageIssssss;//短信倒计时  60s
}
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *keyboard;
@property (weak, nonatomic) IBOutlet UITextField *phoneboard;
@property (weak, nonatomic) IBOutlet UITextField *yanzlab;
@property (weak, nonatomic) IBOutlet UITextField *invitelab;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;


@end

@implementation ForgetKeyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    UIImage *btnimg = [WHGradientHelper getLinearGradientImage:kRGB_COLOR(@"#E8494E ",1) and:kRGB_COLOR(@"#FB6D7D",1) directionType:WHLinearGradientDirectionLevel];
//    [self.loginBtn setBackgroundImage:btnimg forState:0];
//    [self.inviteBtn setBackgroundImage:btnimg forState:0];
    
    
    self.keyboard.delegate = self;
    self.yanzlab.delegate = self;
    self.invitelab.delegate = self;
}

//注册
- (IBAction)registClick:(id)sender {
    
    if (!StrValid(self.phoneboard.text)) {
        [QMUITips showWithText:@"请输入手机号"];
        return;
    }
    
    if (!StrValid(self.yanzlab.text)) {
        [QMUITips showWithText:@"请输入验证码"];
        return;
    }
    
    if (!StrValid(self.keyboard.text)) {
        [QMUITips showWithText:@"请输入您的密码"];
        return;
    }
    
    if (!StrValid(self.invitelab.text)) {
        [QMUITips showWithText:@"请确认您的密码"];
        return;
    }
    
    if (![self.invitelab.text isEqualToString:self.keyboard.text]) {
        [QMUITips showWithText:@"两次输入密码不同"];
        return;
    }
    NSDictionary *dic = @{@"phone":self.phoneboard.text,
                            @"password":self.keyboard.text,
                          @"code":self.yanzlab.text
    };
    [QMUITips showLoadingInView:self.view];
    [JFNetTool post:@"" paramJson:NO params:dic Suc:^(NSDictionary *data, NSInteger code, NSString *msg) {
        [QMUITips showWithText:@"密码修改成功"];
        [userManager login:kUserLoginTypePwd params:@{@"param":self.phoneboard.text,@"password":self.keyboard.text,@"type":@"phone",@"pushId":@"pushStr"
        } completion:^(BOOL success, NSString *des) {
            if (success) {
                UIViewController *rootvc = [[AppDelegate shareAppDelegate]getCurrentVC];
                [rootvc dismissViewControllerAnimated:YES completion:nil];
            }else{
                [QMUITips showError:des];
            }
        }];
    } Fail:^(NSError *fail) {
        
    }];


        
        


    
}

//获取邀请码
- (IBAction)inviteClick:(id)sender {
    
    if (!StrValid(self.phoneboard.text)) {
        [QMUITips showWithText:@"请输入手机号"];
        return;
    }else{
   
        [PPNetworkHelper GET:@"" parameters:@{@"phone":self.phoneboard.text,@"type":@2} success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSInteger code = [responseObject[@"code"] integerValue];
                if (code==0) {
                    [QMUITips showWithText:@"发送成功"];
                    self->messageIssssss = 60;
                    if (self->messsageTimer == nil) {
                        self->messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
                    }
                }else{
                    [QMUITips showError:responseObject[@"msg"]];
                }
             }
        } failure:^(NSError *error) {
                
        }];
           
    }
}
//获取验证码倒计时
-(void)daojishi{
    [_inviteBtn setTitle:[NSString stringWithFormat:@"%@%ds",@"倒计时",messageIssssss] forState:UIControlStateNormal];
    _inviteBtn.userInteractionEnabled = NO;
    //    [_inviteBtn setTitleColor:RGB_COLOR(@"#c8c8c8", 1) forState:0];
    
    if (messageIssssss<=0) {
        //        [_inviteBtn setTitleColor:normalColors forState:0];
        [_inviteBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        _inviteBtn.userInteractionEnabled = YES;
        [messsageTimer invalidate];
        messsageTimer = nil;
        messageIssssss = 60;
    }
    messageIssssss-=1;
}

//- (IBAction)makeKeySee:(UIButton *)sender {
//    self.keyboard.secureTextEntry = !self.keyboard.secureTextEntry;
//
//    self.invitelab.secureTextEntry = !self.invitelab.secureTextEntry;
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    return [textField resignFirstResponder];
}
- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
