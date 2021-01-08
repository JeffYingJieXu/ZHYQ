//
//  SearchViewController.m
//  JFBaseApp
//
//  Created by YingJie on 2020/11/25.
//  Copyright © 2020 英杰. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCell.h"
#import "WSDatePickerView.h"
#import "RecordDetailVC.h"
@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)QMUIButton *calendarBtn;
@property(nonatomic,strong)WSDatePickerView *datepicker;
@property(nonatomic,copy)NSString *currentDateStr;
@end

@implementation SearchViewController
{
    NSMutableArray *choseBtns;
    NSMutableArray *choseParams;
    NSString *choseparam;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.StatusBarStyle = UIStatusBarStyleLightContent;
    self.isShowLiftBack = NO;//每个根视图需要设置该属性为NO，否则会出现导航栏异常
    self.view.backgroundColor = CViewBgColor;
    
    choseparam = @"0111";
    [self createUI];
}
- (void)viewDidAppear:(BOOL)animated{
    [self loadData];
}
-(void)createUI{
    
    UILabel *datelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 32)];
    datelabel.text = @"选择日期";
    [self.view addSubview:datelabel];
    
    QMUIButton *calendarBtn = [[QMUIButton alloc] init];
    calendarBtn.imagePosition = QMUIButtonImagePositionLeft;
    calendarBtn.spacingBetweenImageAndTitle = 8;
    [calendarBtn setImage:UIImageMake(@"click_date") forState:UIControlStateNormal];
    [calendarBtn setTitleColor:CFontColor2 forState:0];
//    calendarBtn.backgroundColor = KWhiteColor;
    [calendarBtn setBackgroundColor:KWhiteColor];
    NSDate *date = [NSDate date];
    _currentDateStr = [date stringWithFormat:@"yyyy-MM-dd"];
    [calendarBtn setTitle:[date stringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    calendarBtn.titleLabel.font = UIFontMake(14);
    calendarBtn.frame = CGRectMake(110, 10, 130, 32);
    [self.view addSubview:calendarBtn];
    [calendarBtn addTarget:self action:@selector(calendarClick:) forControlEvents:UIControlEventTouchUpInside];
    self.calendarBtn = calendarBtn;
    
    UILabel *choselabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 52, 90, 18)];
    choselabel.text = @"测项状态";
    [self.view addSubview:choselabel];
    
    choseBtns = [NSMutableArray array];
    CGFloat w = KScreenWidth >= 414 ? 66 : 55;
    CGFloat h = 40;
    NSArray *chosebtn = @[@"全部",@"异常",@"漏检",@"上报维修"];
    choseParams = [@[@"0",@"1",@"1",@"1"] mutableCopy];
    choseparam = @"0111";
    for (int i=0;i<chosebtn.count;i++) {
        QMUIButton *btn = [[QMUIButton alloc] init];
        btn.imagePosition = QMUIButtonImagePositionLeft;// 将图片位置改为在文字上方
        btn.spacingBetweenImageAndTitle = 8;
        [btn setImage:UIImageMake(@"click_nor") forState:UIControlStateNormal];
        [btn setImage:UIImageMake(@"click_sel") forState:UIControlStateSelected];
        [btn setTitleColor:CFontColor2 forState:0];
        [btn setTitle:chosebtn[i] forState:UIControlStateNormal];
        btn.titleLabel.font = UIFontMake(14);
        btn.frame = CGRectMake(w*i+86, 42, w, h);
        if (i==3) {
            btn.frame = CGRectMake(w*i+86, 42, 88, h);
        }
        btn.tag = i+11;
        btn.selected = YES;
        [self.view addSubview:btn];
        [choseBtns addObject:btn];
        [btn addTarget:self action:@selector(choseClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.selected = NO;
        }
    }
    
    
    self.tableView.frame = CGRectMake(0, 80, KScreenWidth, KScreenHeight-kNavAndTabHeight-80);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = CViewBgColor;
    self.tableView.mj_footer = nil;
    [self.view addSubview:self.tableView];
    
}
- (void)choseClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.tag-11 == 0) {
        if (btn.selected) {
            for (int i = 1; i<4; i++) {
                UIButton *tempbtn = choseBtns[i];
                tempbtn.selected = NO;
            }
            choseparam = @"1000";
            choseParams = [@[@"1",@"0",@"0",@"0"] mutableCopy];
        }else{
            for (int i = 1; i<4; i++) {
                UIButton *tempbtn = choseBtns[i];
                tempbtn.selected = YES;
            }
            choseparam = @"0111";
            choseParams = [@[@"0",@"1",@"1",@"1"] mutableCopy];
        }
    }else{
        if (btn.selected) {
            choseParams[btn.tag-11] = @"1";
        }else{
            choseParams[btn.tag-11] = @"0";
        }
        UIButton *tempbtn = choseBtns[0];
        tempbtn.selected = NO;
        choseParams[0] = @"0";
        choseparam = [choseParams componentsJoinedByString:@""];
    }
    
    [self loadData];
}
- (WSDatePickerView *)datepicker
{
    if (!_datepicker) {
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {

            NSString *dateshow = [selectDate    stringWithFormat:@"yyyy-MM-dd"];
//            NSString *dateParam = [selectDate stringWithFormat:@"yyyyMMdd"];
            [self.calendarBtn setTitle:dateshow forState:0];
            self.currentDateStr = dateshow;
            [self loadData];
        }];
        datepicker.datePickerColor = KBlackColor;
        datepicker.maxLimitDate = [NSDate new];
        _datepicker = datepicker;
    }
    return _datepicker;
}
#pragma mark ------------日期选择
- (void)calendarClick:(UIButton *)btn{
    
    [self.datepicker show];
}
- (void)headerRereshing{
    [self loadData];
}
#pragma mark ------------请求数据
-(void)loadData{
    NSLog(@"%@  %@",self.currentDateStr,choseparam);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //默认的
    [manager.requestSerializer setValue:LatestToken forHTTPHeaderField:@"Authorization"];
    
    [manager GET:XJ_taskSearch parameters:@{@"time":self.currentDateStr,@"type":choseparam} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@",responseObject);
        if ([responseObject valueForKey:@"list"]) {
            self.dataList = [[responseObject valueForKey:@"list"] mutableCopy];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@",[error localizedDescription]);
    }];
    
    
    
}
#pragma mark --- table delegte datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *cell = [SearchCell cellInTableView:tableView withIdentifier:@"SearchCell"];
    
    NSDictionary *dic = self.dataList[indexPath.row];
    /*
     *routename;
     *dutyname;
     *starttime;
     *endtime;
     *yichang;
     *loujian;
     *beiyong;
     *normalnum;
     *weixiu;
     *baseview;
     *jianxiu;
     *haoshi;
     
     */
    cell.routename.text = StrFromDict(dic,@"route");
    cell.dutyname.text = StrFromDict(dic,@"inspectorName");
    cell.starttime.text = StrFromDict(dic,@"processStart");
    cell.endtime.text = StrFromDict(dic,@"processEnd");
    cell.haoshi.text = StrFromDict(dic,@"timeConsuming");
    cell.normalnum.text = StrFromDict(dic,@"normal");
    cell.weixiu.text = StrFromDict(dic,@"report");
    cell.jianxiu.text = StrFromDict(dic,@"maintain");
    
    cell.loujian.text = StrFromDict(dic,@"missed");
    cell.beiyong.text = StrFromDict(dic,@"backup");
    cell.yichang.text = StrFromDict(dic,@"abnormal");
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataList[indexPath.row];
    RecordDetailVC *vc = RecordDetailVC.new;
    vc.taskID = StrFromDict(dic, @"id");
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
