//
//  PiontDetailVC.m
//  JFBaseApp
//
//  Created by YingJie on 2020/12/7.
//  Copyright © 2020 英杰. All rights reserved.
//

#import "PiontDetailVC.h"

@interface PiontDetailVC ()
@property (nonatomic,strong) UISwitch *sw;
@property (nonatomic,strong) UILabel *labState;
@property (nonatomic,strong) UISwitch *sw2;
@property (nonatomic,strong) UILabel *labState2;
@property (nonatomic,strong) UITextView *txtView;
@end

@implementation PiontDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = CViewBgColor;
    [self createUI];
        
}

-(void)createUI{
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 80, 20)];
    lab.text = @"结果：";
    [self.view addSubview:lab];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(120, 15, 60, 30)];
    [sw setOn:NO];
    [sw setOnTintColor:CThemeColor];
    [sw addTarget:self action:@selector(pressSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sw];
    self.sw = sw;
    
    self.labState = ({
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(180, 20, 80, 20)];
        lab.text = @"(异常)";
        lab;
    });
    [self.view addSubview:self.labState];
    
    
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 120, 20)];
    lab2.text = @"是否上报维修：";
    [self.view addSubview:lab2];
    
    UISwitch *sw2 = [[UISwitch alloc] initWithFrame:CGRectMake(160, 55, 60, 30)];
    [sw2 setOn:NO];
    [sw2 setOnTintColor:CThemeColor];
    [sw2 addTarget:self action:@selector(pressSwitch2:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sw2];
    self.sw2 = sw2;
    
    UILabel *labState2 = [[UILabel alloc]initWithFrame:CGRectMake(220, 60, 80, 20)];
    labState2.text = @"(不上报)";
    [self.view addSubview:labState2];
    self.labState2 = labState2;
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 80, 20)];
    lab3.text = @"备注：";
    [self.view addSubview:lab3];
    
    UITextView *textv = [[UITextView alloc] initWithFrame:CGRectMake(20, 130, KScreenWidth-40, 200)];
    textv.font = SYSTEMFONT(14);
    [self.view addSubview:textv];
    self.txtView = textv;
    
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
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)saveClick {
    
}
- (void)pressSwitch:(UISwitch *)sw {
    
}

- (void)pressSwitch2:(UISwitch *)sw {
    
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
