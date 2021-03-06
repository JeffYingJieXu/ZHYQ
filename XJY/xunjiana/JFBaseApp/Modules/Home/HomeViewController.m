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
        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            self.dataList = [responseObject mutableCopy];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
        [self.tableView.mj_header endRefreshing];
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
    
    cell.timelabel.text = [NSString stringWithFormat:@"%@ -- %@",[dic[@"start"] substringFromIndex:11],[dic[@"end"] substringFromIndex:11]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataList[indexPath.row];
    NSDictionary *namedic = [dic valueForKey:@"taskTemplate"];
    
    if ([[dic valueForKey:@"status"] isEqualToString:@"end"]) {
//        return ;
    } else if ([[dic valueForKey:@"status"] isEqualToString:@"NOT_START"]) {
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"是否开始巡检" preferredStyle:QMUIAlertControllerStyleAlert];
        [alertController addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [manager.requestSerializer setValue:LatestToken forHTTPHeaderField:@"Authorization"];
            
            NSString *urlName = XJ_taskStart;
            NSString *url = [NSString stringWithFormat:@"%@/%@",urlName,StrFromDict(dic, @"id")];
            [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                XunJianDetailVC *vc = XunJianDetailVC.new;
                vc.taskID = StrFromDict(dic, @"id");
                if (namedic) {
                    vc.title = StrFromDict(namedic, @"name");
                    vc.taskTemplateID = StrFromDict(namedic, @"id");
                }
                [self.navigationController pushViewController:vc animated:YES];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse*)task.response;
                NSDictionary *dict = httpURLResponse.allHeaderFields;
                
                if (dict[@"message"]) {
                    NSString *tip = [self URLDecodedString:dict[@"message"]];
                    [QMUITips showInfo:tip];
                }
                NSLog(@"%@",dict[@"message"]);
            }];
            
        }]];
        [alertController showWithAnimated:YES];
    } else {
        XunJianDetailVC *vc = XunJianDetailVC.new;
        vc.taskID = StrFromDict(dic, @"id");
        if (namedic) {
            vc.title = StrFromDict(namedic, @"name");
            vc.taskTemplateID = StrFromDict(namedic, @"id");
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
      
}


-(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
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
