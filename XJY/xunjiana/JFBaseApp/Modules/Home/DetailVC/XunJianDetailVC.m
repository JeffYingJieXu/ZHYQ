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
    
}
- (void)loadDate {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //默认的
    [manager.requestSerializer setValue:LatestToken forHTTPHeaderField:@"Authorization"];
    NSString *urlName = TaskList;
    NSString *url = [NSString stringWithFormat:@"%@/%@",urlName,self.taskID];
    NSLog(@"%@",url);
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"areas"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = responseObject[@"areas"];
            for (NSDictionary *dic in arr) {
                XJModel *m = [XJModel modelWithDictionary:dic];
                NSMutableArray *marr = [NSMutableArray array];
                for (EqModel *model in m.equipments) {
                    [marr addObject:model];
                    for (PointModel *point in model.points) {
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
    [view.DoneBtn addTapBlock:^(UIButton *btn) {
        model.finish = !model.finish;
        btn.selected = model.finish;
    }];
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
        
        cell.name.text = model.name;
        //是否展示子cell
//        cell.arrowBtn.selected = model.show;
        //按钮正常 是否勾选
        cell.choseBtn.selected = model.normal;
        cell.normalBtn.selected = model.normal;
        
        [cell.normalBtn addTapBlock:^(UIButton *btn) {
            btn.selected = !btn.selected;
            model.normal = btn.selected;
            //按钮正常 是否勾选
//            cell.choseBtn.selected = btn.selected;
//            cell.normalBtn.selected = btn.selected;
            model.haveDone = btn.selected;
            for (PointModel *tpm in model.points) {
                tpm.haveDone = YES;
                tpm.normal = YES;
            }
            
            [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        return cell;
            
    }else{
        ItemTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTwoCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemTwoCell" owner:self options:nil]firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        PointModel *point = obj;
        cell.name.text = point.name;
        cell.coverWhite.hidden = [point.type isEqualToString:@"OBSERVE"];

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
        [cell.normalBtn addTapBlock:^(UIButton *btn) {
            cell.choseBtn.selected = YES;
            
            cell.erorBtn.selected = btn.selected;
            point.errorChose = btn.selected;
            
            btn.selected = !btn.selected;
            point.normalChose = btn.selected;
        }];
        [cell.erorBtn addTapBlock:^(UIButton *btn) {
            cell.choseBtn.selected = YES;
            
            cell.normalBtn.selected = btn.selected;
            point.normalChose = btn.selected;
            
            btn.selected = !btn.selected;
            point.errorChose = btn.selected;
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
//        vc.normal = ;
//        vc.xiu = ;
//        vc.remark = ;
        [vc setSomeBlock:^(BOOL normal, BOOL xiu, NSString * _Nonnull remark) {
            
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
