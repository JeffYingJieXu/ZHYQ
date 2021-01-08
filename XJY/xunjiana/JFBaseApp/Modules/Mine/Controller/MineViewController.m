//
//  MineViewController.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "SettingViewController.h"
#import "MineHeadV.h"

#import "AppDelegate+Service.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataSource;
}
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.isHidenNaviBar = YES;
    self.StatusBarStyle = UIStatusBarStyleLightContent;
    self.isShowLiftBack = NO;//每个根视图需要设置该属性为NO，否则会出现导航栏异常
    
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


#pragma mark ————— 创建页面 —————
-(void)createUI{
    self.tableView.height = KScreenHeight - kNavAndTabHeight;
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    [self.tableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"MineTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.separatorColor = CViewBgColor;
    [self.view addSubview:self.tableView];
    
    MineHeadV *headv = [[[NSBundle mainBundle] loadNibNamed:@"MineHeadV" owner:self options:nil]firstObject];
    headv.frame = CGRectMake(0, 0, KScreenWidth, 166);
    self.tableView.tableHeaderView = headv;
    
    if ([kUserDefaults valueForKey:@"loginName"]) {
        headv.headNickName.text = [kUserDefaults valueForKey:@"loginName"];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        
        LoginVC *vc = [LoginVC new];
        AppDelegate *delegate = [AppDelegate shareAppDelegate];
        delegate.window.rootViewController = vc;
    }];
    [headv addGestureRecognizer:tap];
    
//    _dataSource = @[@[@{@"icon":@"mymsg",@"title":@"消息中心",@"right":@"arrow_icon"}],@[@{@"icon":@"myfeedback",@"title":@"用户留言",@"right":@"arrow_icon"},
//          @{@"icon":@"myabout",@"title":@"关于我们",@"right":@"arrow_icon"}],@[@{@"icon":@"myset",@"title":@"退出登录",@"right":@"arrow_icon"}]
//    ];
    
    _dataSource = @[];
    [self.tableView reloadData];
    
    QMUIButton *button = [QMUIButton new];
    button.adjustsButtonWhenHighlighted = YES;
    button.titleLabel.font = UIFontBoldMake(22);
    [button setTitleColor:UIColorWhite forState:UIControlStateNormal];
    button.backgroundColor = CThemeColor;
    button.layer.cornerRadius = 6;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-30-kTabBarHeight);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth*0.65, 50));
    }];
    [button setTitle:@"退出" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)loginOut{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"latestToken"];
    LoginVC *vc = [LoginVC new];
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    delegate.window.rootViewController = vc;
}
#pragma mark ————— tableview 代理 —————
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{return 15;}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = KClearColor;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCell" forIndexPath:indexPath];
    cell.cellData = _dataSource[indexPath.section][indexPath.row];;
  
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            NSLog(@"点击了 我的钱包");
            break;
        case 1:
            NSLog(@"点击了 我的任务");
            break;
        case 2:
            NSLog(@"点击了 我的好友");
            break;
        case 3:
            NSLog(@"点击了 我的等级");
            break;
        default:
            break;
    }
}


#pragma mark ————— 切换账号 —————
-(void)changeUser{
    SettingViewController *settingVC = [SettingViewController new];
    [self.navigationController pushViewController:settingVC animated:YES];
    
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
