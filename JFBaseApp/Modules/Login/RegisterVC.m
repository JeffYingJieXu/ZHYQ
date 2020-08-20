//
//  RegisterVC.m
//  cheyijia
//
//  Created by Jeff Xu on 2019/7/22.
//  Copyright © 2019 Jeff Xu. All rights reserved.
//

#import "RegisterVC.h"
//#import "WHGradientHelper.h"

@interface RegisterVC ()<UITextFieldDelegate>
{
    NSTimer *messsageTimer;
    int messageIssssss;//短信倒计时  60s
}
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneboard;
@property (weak, nonatomic) IBOutlet UITextField *yanzlab;

@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;


@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.yanzlab.delegate = self;
    [self.phoneboard becomeFirstResponder];
}

//注册
- (IBAction)registClick:(id)sender {
    
    [self.view endEditing:YES];
    
    if (!StrValid(self.phoneboard.text)) {
        [QMUITips showWithText:@"请输入手机号"];
        return;
    }

    if (!StrValid(self.yanzlab.text)) {
        [QMUITips showWithText:@"请输入验证码"];
        return;
    }

    [JFNetTool get:@"" paramJson:NO params:@{@"phone":self.phoneboard.text,@"code":self.yanzlab.text} Suc:^(NSDictionary *data, NSInteger code, NSString *msg) {
        id isReady = data;
        if ([isReady boolValue]) {
//            RegisterInfoVC *vc = [RegisterInfoVC new];
//            vc.phonenum = self.phoneboard.text;
//            vc.modalPresentationStyle = 0;
//            [self presentViewController:vc animated:YES completion:nil];
        }else{
            [QMUITips showError:msg];
        }
    } Fail:^(NSError *fail) {

    }];
    


}

//获取邀请码
- (IBAction)inviteClick:(id)sender {
   
    if (!StrValid(self.phoneboard.text)) {
        [QMUITips showWithText:@"请输入手机号"];
        return;
    }else{
        
//        NSString *urlStr =[NSString stringWithFormat:@"%@/%@",curUrl,JFPhoneReady];
 
        [PPNetworkHelper GET:@"" parameters:@{@"phone":self.phoneboard.text} success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                id isReady = responseObject[@"data"];
                if ([isReady boolValue]) {
                    [QMUITips showWithText:@"手机号已注册"];
                }else{
                    [self reqInviteCode];
                }
             }
        } failure:^(NSError *error) {
            NSLog(@"%@",[error localizedDescription]);
        }];
//        [JFNetTool get:JFPhoneReady paramJson:NO params:@{@"phone":self.phoneboard.text} Suc:^(NSDictionary *data, NSInteger code, NSString *msg) {
//            id isReady = data;
//            if ([isReady boolValue]) {
//                [QMUITips showWithText:@"手机号已注册"];
//            }else{
//                [self reqInviteCode];
//            }
//
//        } Fail:^(NSError *fail) {
//
//        }];
    }
}

- (void)reqInviteCode{
    
//    NSString *urlStr =[NSString stringWithFormat:@"%@/%@",curUrl,JFGetIdentifyingCodeURL];
 
    [PPNetworkHelper GET:@"" parameters:@{@"phone":self.phoneboard.text,@"type":@1} success:^(id responseObject) {
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
//    [JFNetTool get:JFGetIdentifyingCodeURL paramJson:NO params:@{@"phone":self.phoneboard.text,@"type":@1} Suc:^(NSDictionary *data, NSInteger code, NSString *msg) {
//        if (code==0) {
//            [QMUITips showWithText:@"发送成功"];
//            self->messageIssssss = 60;
//            if (self->messsageTimer == nil) {
//                self->messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
//            }
//        }else{
//            [QMUITips showError:msg];
//        }
//
//    } Fail:^(NSError *fail) {
//
//    }];
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    return [textField resignFirstResponder];
}

- (IBAction)dismissVcBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
