//
//  RecordDetailVC.m
//  JFBaseApp
//
//  Created by YingJie on 2020/11/27.
//  Copyright © 2020 英杰. All rights reserved.
//

#import "RecordDetailVC.h"
#import "RecordDetailCell.h"
#import "HZPhotoBrowser.h"
@interface RecordDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation RecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"记录详情";
    self.view.backgroundColor = CViewBgColor;
    [self createUI];
}

-(void)createUI{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - kNavBarAndStatusBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = CViewBgColor;
    self.tableView.mj_footer = nil;
    [self.view addSubview:self.tableView];
    
}
- (void)headerRereshing {
    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated{
    [self loadData];
}

- (void)loadData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //默认的
    [manager.requestSerializer setValue:LatestToken forHTTPHeaderField:@"Authorization"];
    
    [manager GET:XJ_taskDetail parameters:@{@"taskId":self.taskID,@"countType":self.searchtype} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject valueForKey:@"list"]) {
            self.dataList = [[responseObject valueForKey:@"list"] mutableCopy];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.estimatedRowHeight = 135;
    
    return self.tableView.rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordDetailCell *cell = [RecordDetailCell cellInTableView:tableView withIdentifier:@"RecordDetailCell"];
    NSDictionary *dic = self.dataList[indexPath.row];
    cell.name.text = StrFromDict(dic, @"equipName");
    cell.point.text = StrFromDict(dic, @"pointName");
    cell.result.text = [dic[@"status"] isEqualToString:@"NORMAL"] ? @"正常" : @"异常" ;
    cell.testnum.text = StrFromDict(dic, @"value");
    cell.descrip.text = StrFromDict(dic, @"remark");
    if (dic[@"taskResultFiles"]) {
        NSArray *pics = dic[@"taskResultFiles"];
        if (pics.count>0) {
            cell.somePics.hidden = NO;
            NSMutableArray *marr = [NSMutableArray array];
            for (NSDictionary *picdic in pics) {
                [marr addObject:picdic[@"path"]];
            }
            [cell.somePics whenTapped:^{
                HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
                browser.isFullWidthForLandScape = YES;
                browser.isNeedLandscape = YES;
                browser.currentImageIndex = 0;
                browser.imageArray = [marr copy];
                [browser show];
            }];
        }else {
            cell.somePics.hidden = YES;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
