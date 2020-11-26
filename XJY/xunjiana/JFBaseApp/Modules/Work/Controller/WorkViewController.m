//
//  WorkViewController.m
//  JFBaseApp
//
//  Created by YingJie on 2020/8/21.
//  Copyright © 2020 英杰. All rights reserved.
//

#import "WorkViewController.h"
#import "WorkCellA.h"

@interface WorkViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.isHidenNaviBar = YES;
    self.StatusBarStyle = UIStatusBarStyleLightContent;
    self.isShowLiftBack = NO;//每个根视图需要设置该属性为NO，否则会出现导航栏异常
    self.view.backgroundColor = CViewBgColor;
 
    [self createUI];
    
    
}
- (void)createUI {
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kNavBarAndStatusBarHeight)];
    navtion.backgroundColor = CNavBgColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = @"巡检任务";
    [label setFont:FontNav];
    label.textColor = CNavBgFontColor;
    label.frame = CGRectMake(0, kStatusBarHeight,KScreenWidth,44);
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    [self.view addSubview:navtion];
    

    self.tableView.frame = CGRectMake(0, kNavBarAndStatusBarHeight, KScreenWidth, KScreenHeight - kNavAndTabHeight);
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
//    [self.tableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"MineTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.separatorColor = CViewBgColor;
    [self.view addSubview:self.tableView];
    
}

#pragma mark ————— tableview —————
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{return section==0 ? 0 : 15;}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = KClearColor;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55 + KScreenWidth/4.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkCellA *cell = [WorkCellA cellInTableView:tableView withIdentifier:@"callA"];
    return cell;
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
