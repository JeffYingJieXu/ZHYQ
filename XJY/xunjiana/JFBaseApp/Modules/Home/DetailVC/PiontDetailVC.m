//
//  PiontDetailVC.m
//  JFBaseApp
//
//  Created by YingJie on 2020/12/7.
//  Copyright © 2020 英杰. All rights reserved.
//

#import "PiontDetailVC.h"
#import "AddPicScroll.h"


@interface PiontDetailVC ()
@property (nonatomic,strong) UISwitch *sw;
@property (nonatomic,strong) UILabel *labState;
@property (nonatomic,strong) UISwitch *sw2;
@property (nonatomic,strong) UILabel *labState2;
@property (nonatomic,strong) UITextView *txtView;
@property (nonatomic,strong) UILabel *content;
@property (nonatomic,strong) UILabel *standlabel;

@property (nonatomic,strong) UILabel *testLabel,*danweiLabel;
@property (nonatomic,strong) UITextField *testNum;

@property (nonatomic,strong) AddPicScroll *scrol;
@end

@implementation PiontDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = CViewBgColor;
    [self createUI];
        
}
- (void)viewDidAppear:(BOOL)animated{
    self.content.text = self.name;
    self.standlabel.text = self.standard;
    
    self.sw.on = !self.normal;
    self.labState.text = self.sw.on ? @"(异常)" : @"(正常)" ;
    
    self.sw2.on = self.xiu;
    self.labState2.text = self.sw2.on ? @"(上报)" : @"(不上报)" ;
    
    self.txtView.text = self.remark;
//    if (self.testPoint) {
//        self.testLabel.hidden = NO;
//        self.testNum.hidden = NO;
//        self.danweiLabel.hidden = NO;
        self.testNum.text = self.value;
//    } else {
//        self.testLabel.hidden = YES;
//        self.testNum.hidden = YES;
//        self.danweiLabel.hidden = YES;
//    }
    self.scrol.picsObj = self.picsObjArr;
    
}

-(void)createUI{
    
    UILabel *namelab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 50, 20)];
    namelab.text = @"内容：";
    namelab.numberOfLines = 2;
    [self.view addSubview:namelab];
    
    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, KScreenWidth-70, 40)];
    self.content = content;
    content.numberOfLines = 2;
    [self.view addSubview:content];
    
    UILabel *namelab2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 50, 20)];
    namelab2.text = @"标准：";
    [self.view addSubview:namelab2];
    
    UILabel *content2 = [[UILabel alloc]initWithFrame:CGRectMake(70, 50, KScreenWidth-70, 40)];
    self.standlabel = content2;
    [self.view addSubview:content2];
    
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 50, 20)];
    lab.text = @"结果：";
    [self.view addSubview:lab];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(70, 95, 60, 30)];
    [sw setOn:NO];
    [sw setOnTintColor:CThemeColor];
    [sw addTarget:self action:@selector(pressSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sw];
    self.sw = sw;
    
    self.labState = ({
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(130, 100, 80, 20)];
        lab.text = @"(正常)";
        lab;
    });
    [self.view addSubview:self.labState];
    
    UILabel *test = [[UILabel alloc]initWithFrame:CGRectMake(200, 100, 50, 20)];
    test.text = @"实测：";
    self.testLabel = test;
    [self.view addSubview:test];
    
    UITextField *testNum = [[UITextField alloc] initWithFrame:CGRectMake(250, 90, 80, 40)];
    self.testNum = testNum;
    testNum.backgroundColor = KWhiteColor;
    [self.view addSubview:testNum];
    
    UILabel *danwei = [[UILabel alloc]initWithFrame:CGRectMake(330, 100, 50, 20)];
    self.danweiLabel = danwei;
    [self.view addSubview:danwei];
    
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 140, 120, 20)];
    lab2.text = @"是否上报维修：";
    [self.view addSubview:lab2];
    
    UISwitch *sw2 = [[UISwitch alloc] initWithFrame:CGRectMake(150, 135, 60, 30)];
    [sw2 setOn:NO];
    [sw2 setOnTintColor:CThemeColor];
    [sw2 addTarget:self action:@selector(pressSwitch2:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sw2];
    self.sw2 = sw2;
    
    UILabel *labState2 = [[UILabel alloc]initWithFrame:CGRectMake(210, 140, 80, 20)];
    labState2.text = @"(不上报)";
    [self.view addSubview:labState2];
    self.labState2 = labState2;
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 180, 80, 20)];
    lab3.text = @"备注：";
    [self.view addSubview:lab3];
    
    UITextView *textv = [[UITextView alloc] initWithFrame:CGRectMake(20, 210, KScreenWidth-40, 100)];
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
    
    AddPicScroll *scrol = [[AddPicScroll alloc] initWithFrame:CGRectMake(10, 330, KScreenWidth-20, KScreenWidth*0.25-5)];
    scrol.maxPics = 9;
    [scrol setPicUrlsBlock:^(NSArray * _Nonnull picUrls) {
        NSLog(@"%@",picUrls[0]);
        NSMutableArray *urlMarr = [NSMutableArray array];
        for (NSString *url in picUrls) {
            [urlMarr addObject:@{@"path":url}];
        }
        self.picsObjArr = [urlMarr copy];
    }];
    [self.view addSubview:scrol];
    self.scrol = scrol;
    
}
- (void)saveClick {
    if (self.someBlock) {
        self.someBlock(!self.sw.on, self.sw2.on, self.testNum.text, self.txtView.text ,self.picsObjArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)pressSwitch:(UISwitch *)sw {
    self.labState.text = sw.on ? @"(异常)" : @"(正常)" ;
}

- (void)pressSwitch2:(UISwitch *)sw {
    self.labState2.text = sw.on ? @"(上报)" : @"(不上报)" ;
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
