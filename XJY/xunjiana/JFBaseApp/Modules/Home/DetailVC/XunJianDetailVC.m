//
//  XunJianDetailVC.m
//  JFBaseApp
//
//  Created by YingJie on 2020/11/30.
//  Copyright © 2020 英杰. All rights reserved.
//

#import "XunJianDetailVC.h"
#import "XJModel.h"

#import "SectionSimple.h"
#import "ItemOneCell.h"
#import "ItemTwoCell.h"

#import "PiontDetailVC.h"
@interface XunJianDetailVC ()<UITableViewDelegate,UITableViewDataSource,LMJDropdownMenuDataSource,LMJDropdownMenuDelegate>

@end

@implementation XunJianDetailVC
{
    NSArray *menuOptionTitles;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KWhiteColor;
    menuOptionTitles = @[@"运行",@"备用",@"检修"];
    [self createUI];
    [self loadDate];
}

-(void)createUI{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight-90);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = KWhiteColor;
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    [self.view addSubview:self.tableView];
    
    QMUIButton *button = [QMUIButton new];
    button.adjustsButtonWhenHighlighted = YES;
    button.titleLabel.font = UIFontBoldMake(22);
    [button setTitleColor:UIColorWhite forState:UIControlStateNormal];
    button.backgroundColor = CThemeColor;
    button.layer.cornerRadius = 6;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-20);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth*0.65, 50));
    }];
    [button setTitle:@"结束任务" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(finishTask) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)finishTask {
    NSInteger  num = 0;
    NSMutableArray *marr = [NSMutableArray array];
    for (XJModel *xjm in self.dataList) {
        for (EqModel *eqm in xjm.equipments) {
            for (PointModel *point in eqm.points) {
                NSString *state = [self stateEnglish:point.state];
                NSString *nowtime = [self nowTimeStr];
                NSDictionary *dic = @{
                    @"taskId": self.taskID,
                    @"pointId": point.ID,
                    @"itemId" : @(point.item.ID),
                    @"value": point.value ? : @"",
                    @"status": point.errorChose ? @"UNNORMAL" : @"NORMAL",
                    @"remark": point.remark ? : @"无异常",
                    @"time": point.doneTime ? : (eqm.doneTime ? : nowtime),
                    @"isReport" : point.isReport ? @"REPORT" : @"NOT_REPORT",
                    @"equipmentStatus" : state,
                    @"type":point.type,
                    @"taskResultFiles":@[]
                };
                
                [marr addObject:dic];
                if (point.haveDone) {
                    num ++;
                }
            }
        }
    }
    
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"总巡检点 %ld",marr.count] message:[NSString stringWithFormat:@"已巡检点 %ld 未巡检点 %ld 是否结束任务",num,(marr.count - num)] preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        
        
        NSError *error = nil;
        NSString *createJSON = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:marr options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding];
        NSMutableString *mstr = [NSMutableString stringWithString:createJSON];
        NSRange range = {0,createJSON.length};
        [mstr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
        NSRange range2 = {0,mstr.length};
        [mstr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
        NSRange range3 = {0,mstr.length};
        [mstr replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:range3];
        
//        NSRange range4 = {0,mstr.length};
//        [mstr replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:range4];
        
        
        [self commitRequest:mstr];
        return;
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:LatestToken forHTTPHeaderField:@"Authorization"];
        
        [manager POST:TaskDone parameters:@{@"results":mstr} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse*)task.response;
            NSDictionary *dict = httpURLResponse.allHeaderFields;
            
            NSLog(@"%@",dict[@"message"]);
            
            
            [QMUITips showSucceed:@"提交成功"];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse*)task.response;
            NSDictionary *dict = httpURLResponse.allHeaderFields;
            
            NSLog(@"%@",dict[@"message"]);
        }];
        
    }]];
    [alertController showWithAnimated:YES];
    
}

- (void)commitRequest:(NSString *)jsonArr {
    //创建URL对象
    NSURL *url =[NSURL URLWithString:TaskDone];
    //创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"post"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:LatestToken forHTTPHeaderField:@"Authorization"];
    
    NSData *jsonArrData = [jsonArr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:jsonArrData];
        
    // 3 建立会话 session支持三种类型的任务
    
    //    NSURLSessionDataTask  //加载数据
    //    NSURLSessionDownloadTask  //下载
    //    NSURLSessionUploadTask   //上传
    NSURLSession *session =[NSURLSession sharedSession];
//    NSLog(@"%d",[[NSThread currentThread] isMainThread]);
    
    __weak typeof(self)weakSelf = self;
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //解析
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"%@",dic);
//        NSLog(@"%d----",[[NSThread currentThread] isMainThread]);
        //回到主线程 刷新数据 要是刷新就在这里面
        dispatch_async(dispatch_get_main_queue(), ^{
            [QMUITips showSucceed:@"提交成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    }];
    //启动任务
    [dataTask resume];
}

- (void)loadDate {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //默认的
    [manager.requestSerializer setValue:LatestToken forHTTPHeaderField:@"Authorization"];
    NSString *urlName = TaskList;
    NSString *url = [NSString stringWithFormat:@"%@/%@",urlName,self.taskTemplateID];
    NSLog(@"%@",url);
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"areas"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = responseObject[@"areas"];
            for (NSDictionary *dic in arr) {
                XJModel *m = [XJModel modelWithDictionary:dic];
                NSMutableArray *marr = [NSMutableArray array];
                for (EqModel *model in m.equipments) {
                    model.state = @"运行";
                    [marr addObject:model];
                    for (PointModel *point in model.points) {
                        point.state = @"运行";
                        [marr addObject:point];
                    }
                }
                m.totalArr = marr;
                
                [self.dataList addObject:m];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
    
    
}
#pragma mark --- table delegte datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    XJModel *model = self.dataList[section];
    
    SectionSimple *view = [[[NSBundle mainBundle] loadNibNamed:@"SectionSimple" owner:self options:nil]firstObject];
    view.SectionTitle.text = model.name;
    view.DoneBtn.selected = model.finish;
   
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        model.show = !model.show;
        [self.tableView reloadSection:section withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    [view addGestureRecognizer:tap];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataList.count;
    
    XJModel *model = self.dataList[section];
    return model.show ? model.totalArr.count : 0;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XJModel *xjmodel = self.dataList[indexPath.section];
    NSMutableArray *marr = xjmodel.totalArr;
    id obj = marr[indexPath.row];
    if ([obj isKindOfClass:[EqModel class]]) {
        ItemOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemOneCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemOneCell" owner:self options:nil]firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.menu.dataSource = self;
            cell.menu.delegate   = self;
            cell.menu.layer.borderColor  = CThemeColor.CGColor;
            cell.menu.layer.borderWidth = 2;
            cell.menu.layer.cornerRadius = 5;
            cell.menu.title           = @"运行";
            cell.menu.titleBgColor    = KWhiteColor;
            cell.menu.titleFont       = SYSTEMFONT(17);
            cell.menu.titleColor      = [UIColor darkGrayColor];
            cell.menu.titleAlignment  = NSTextAlignmentLeft;
            cell.menu.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
            cell.menu.rotateIcon      = [UIImage imageNamed:@"arrowdown"];
            cell.menu.rotateIconSize  = CGSizeMake(8, 8);
            cell.menu.optionBgColor         = CViewBgColor;
            cell.menu.optionFont            = [UIFont systemFontOfSize:14];
            cell.menu.optionTextColor       = [UIColor blackColor];
            cell.menu.optionTextAlignment   = NSTextAlignmentCenter;
            cell.menu.optionNumberOfLines   = 1;
            cell.menu.optionLineColor       = [UIColor whiteColor];
        }
        
        
        EqModel *model = obj;
        [cell.menu setChoseBlock:^(NSString * _Nonnull title) {
            model.state = title;
            for (PointModel *tmp in model.points) {
                tmp.state = title;
            }
            [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
        cell.menu.title = model.state;
        cell.name.text = model.name;
        //是否展示子cell
//        cell.arrowBtn.selected = model.show;
        
        
        //按钮正常 是否勾选
        cell.normalBtn.selected = model.normal;
        
        [cell.normalBtn addTapBlock:^(UIButton *btn) {
            btn.selected = !btn.selected;
            //按钮正常 是否勾选
            model.normal = btn.selected;
//            model.haveDone = btn.selected;
            for (PointModel *tpm in model.points) {
                tpm.normal = btn.selected;
            }
            
            [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        if (model.normal || [model.state isEqualToString:@"检修"]) {
            //如果全选正常 3级全完成
            cell.choseBtn.selected = YES;
            for (PointModel *tpm in model.points) {
                tpm.haveDone = YES;
            }
        } else {
            //3级点是否都操作了
            cell.choseBtn.selected = model.haveDone;
        }
        
        return cell;
            
    }else{
        ItemTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTwoCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemTwoCell" owner:self options:nil]firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        PointModel *point = obj;
        cell.name.text = point.name;
        
        // 观察模式巡检点 展示正常 异常操作选择
        cell.coverWhite.hidden = [point.type isEqualToString:@"OBSERVE"];
        
        // 运行状态 展示正常 异常操作选择
        cell.coverWhite.hidden = ![point.state isEqualToString:@"检修"];
        
        if ([point.state isEqualToString:@"检修"]) {
            cell.name.textColor = [UIColor lightGrayColor];
        }else {
            cell.name.textColor = [UIColor darkGrayColor];
        }
        
        cell.choseBtn.selected = point.haveDone;
        cell.normalBtn.selected = point.normal;
        cell.erorBtn.selected = point.normal;
        if (point.normal) {
            cell.choseBtn.selected = YES;
            cell.normalBtn.selected = YES;
            cell.erorBtn.selected = NO;
        }else{
            cell.choseBtn.selected = point.normalChose || point.errorChose;
            cell.normalBtn.selected = point.normalChose;
            cell.erorBtn.selected = point.errorChose;
        }
        
        if ([point.state isEqualToString:@"检修"]) {
            cell.choseBtn.selected = YES;
        }
        [cell.normalBtn addTapBlock:^(UIButton *btn) {
            cell.choseBtn.selected = YES;
            
            cell.erorBtn.selected = btn.selected;
            point.errorChose = btn.selected;
            
            btn.selected = !btn.selected;
            point.normalChose = btn.selected;
            
            point.doneTime = [self nowTimeStr];
            
            point.haveDone = YES;
            
            for (id tmp in marr) {
                if ([tmp isKindOfClass:[EqModel class]]) {
                    BOOL threeDone = YES;
                    EqModel *model = tmp;
                    BOOL oldTwoDone = model.haveDone;
                    for (PointModel *point in model.points) {
                        if (!point.haveDone) {
                            threeDone = NO;
                        }
                    }
                    model.haveDone = threeDone;
                    if (threeDone != oldTwoDone) {
                        //二级完成圈点状态改变则刷新
                        [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }
            }
        }];
        [cell.erorBtn addTapBlock:^(UIButton *btn) {
            cell.choseBtn.selected = YES;
            
            cell.normalBtn.selected = btn.selected;
            point.normalChose = btn.selected;
            
            btn.selected = !btn.selected;
            point.errorChose = btn.selected;
            
            point.doneTime = [self nowTimeStr];
            
            point.haveDone = YES;
            
            for (id tmp in marr) {
                if ([tmp isKindOfClass:[EqModel class]]) {
                    BOOL threeDone = YES;
                    EqModel *model = tmp;
                    BOOL oldTwoDone = model.haveDone;
                    for (PointModel *point in model.points) {
                        if (!point.haveDone) {
                            threeDone = NO;
                        }
                    }
                    model.haveDone = threeDone;
                    
                    BOOL twoDone = YES;
                    for (EqModel *tmp in xjmodel.equipments) {
                        if (!tmp.haveDone) {
                            twoDone = NO;
                        }
                    }
                    xjmodel.finish = twoDone;
                    
                    if (threeDone != oldTwoDone) {
                        //二级完成圈点状态改变则刷新
                        [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }
            }
        }];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row==0) {
//        _tmpModel.equipments[0].show = !_tmpModel.equipments[0].show;
//        [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationAutomatic];
//    }else{
    
    
    XJModel *xjmodel = self.dataList[indexPath.section];
    NSMutableArray *marr = xjmodel.totalArr;
    id obj = marr[indexPath.row];
    if ([obj isKindOfClass:[PointModel class]]) {
        PointModel *point = obj;
        PiontDetailVC *vc = PiontDetailVC.new;
        vc.title = @"测项详情";
        vc.name = point.item.name;
        vc.standard = point.item.standard;
        vc.normal = !point.errorChose;
        vc.xiu = point.isReport;
        vc.remark = point.remark;
//        if ([point.type isEqualToString:@"MEASURE"]) {
            vc.testPoint = YES;
            vc.unit = point.item.unit;
            if (point.value) {
                vc.value = point.value;
            }
//        }
        [vc setSomeBlock:^(BOOL normal, BOOL xiu, NSString * _Nonnull testNum, NSString * _Nonnull remark) {
            point.normalChose = normal;
            point.errorChose = !normal;
            point.isReport = xiu;
            point.value = testNum;
            point.remark = remark;
            point.haveDone = YES;
            [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



#pragma mark - LMJDropdownMenu DataSource
- (NSUInteger)numberOfOptionsInDropdownMenu:(LMJDropdownMenu *)menu{
    return menuOptionTitles.count;
}
- (CGFloat)dropdownMenu:(LMJDropdownMenu *)menu heightForOptionAtIndex:(NSUInteger)index{
    return 35;
}
- (NSString *)dropdownMenu:(LMJDropdownMenu *)menu titleForOptionAtIndex:(NSUInteger)index{
    return menuOptionTitles[index];
}

#pragma mark - LMJDropdownMenu Delegate
- (void)dropdownMenu:(LMJDropdownMenu *)menu didSelectOptionAtIndex:(NSUInteger)index optionTitle:(NSString *)title{

}


-(NSString *)nowTimeStr{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    NSDate *now = [NSDate date];
    NSString *systemTimeZoneStr =  [df stringFromDate:now];
    
    return [systemTimeZoneStr stringByReplacingOccurrencesOfString:@" " withString:@"T"];
}
- (NSString *)stateEnglish:(NSString *)state {
    if ([state isEqualToString:@"运行"]) {
        return @"RUNNING";
    } else if ([state isEqualToString:@"备用"]) {
    return @"STANDBY";
    } else {
        return @"OVERHAUL";
    }
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
