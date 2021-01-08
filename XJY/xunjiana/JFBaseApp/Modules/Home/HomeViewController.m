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
    self.tableView.mj_footer = nil;
    [self.view addSubview:self.tableView];
    
}
-(void)headerRereshing{
    [self loadData];
}
- (void)viewDidAppear:(BOOL)animated {
    [self loadData];
}
- (void)loadData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //默认的
    [manager.requestSerializer setValue:LatestToken forHTTPHeaderField:@"Authorization"];
    [manager GET:XJ_taskList parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            self.dataList = [responseObject mutableCopy];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}
#pragma mark --- table delegte datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = [HomeCell cellInTableView:tableView index:0 withIdentifier:@"HomeCell"];
    NSDictionary *dic = self.dataList[indexPath.row];
    NSDictionary *namedic = [dic valueForKey:@"taskTemplate"];
    if (namedic) {
        cell.routename.text = StrFromDict(namedic, @"name");
    }
    
    if ([[dic valueForKey:@"status"] isEqualToString:@"NOT_START"]) {
        cell.routename.backgroundColor = [UIColor lightGrayColor];
    }else if ([[dic valueForKey:@"status"] isEqualToString:@"PROCESSING"]) {
        cell.routename.backgroundColor = CThemeColor;
    }else {
        cell.routename.backgroundColor = [UIColor greenColor];
    }
    
    cell.timelabel.text = [NSString stringWithFormat:@"%@ -- %@",[dic[@"start"] substringFromIndex:12],[dic[@"end"] substringFromIndex:12]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataList[indexPath.row];
    NSDictionary *namedic = [dic valueForKey:@"taskTemplate"];
    
    if ([[dic valueForKey:@"status"] isEqualToString:@"NOT_START"]) {
//        return ;
    }
    XunJianDetailVC *vc = XunJianDetailVC.new;
    vc.taskID = StrFromDict(namedic, @"id");
    if (namedic) {
        vc.title = StrFromDict(namedic, @"name");
    }
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
