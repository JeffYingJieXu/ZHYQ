//
//  HomeViewController.m
//  JFBaseApp
//
//  Created by YingJie on 2020/11/25.
//  Copyright © 2020 英杰. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "XunJianDetailVC.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.StatusBarStyle = UIStatusBarStyleLightContent;
    self.isShowLiftBack = NO;//每个根视图需要设置该属性为NO，否则会出现导航栏异常
    
    [self createUI];
}

-(void)createUI{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = CViewBgColor;
    [self.view addSubview:self.tableView];
    
}
#pragma mark --- table delegte datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataList.count;
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = [HomeCell cellInTableView:tableView index:0 withIdentifier:@"HomeCell"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XunJianDetailVC *vc = XunJianDetailVC.new;
    vc.title = @"123#炉巡检路线";
    [self.navigationController pushViewController:vc animated:YES];
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
