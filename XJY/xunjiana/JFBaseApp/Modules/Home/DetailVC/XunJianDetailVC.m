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
@interface XunJianDetailVC ()<UITableViewDelegate,UITableViewDataSource,LMJDropdownMenuDataSource,LMJDropdownMenuDelegate>

@end

@implementation XunJianDetailVC
{
    NSArray *menuOptionTitles;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    menuOptionTitles = @[@"运行",@"备用",@"检修"];
    [self createUI];
//    [self loadDate];
}

-(void)createUI{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight-100);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = KWhiteColor;
    [self.view addSubview:self.tableView];
    
}
- (void)loadDate {
    NSDictionary *dic = @{
        @"id": @1,
        @"name": @"废水加药间区域",
        @"equipments": @[
            @{@"id": @1,
              @"name": @"有机硫箱加药系统",
              @"points": @[
                    @{@"id": @1,
                      @"name": @"有机硫箱液位、管道阀门状态",
                      @"type": @"OBSERVE",
                      @"item": @{
                              @"id": @1,
                              @"name": @"液位是否正常、管道阀门是否无泄漏",
                              @"standard": @"是",
                              @"unit": @""}
                    },
                    @{
                        @"id": @2,
                        @"name": @"有机硫各计量泵运行状态",
                        @"type": @"OBSERVE",
                        @"item": @{
                            @"id": @2,
                            @"name": @"各计量泵是否在运转、运转是否正常",
                            @"standard": @"是",
                            @"unit": @""}
                    }
              ]
            }
        ]
      
    };
    XJModel *m = [XJModel modelWithDictionary:dic];
    NSLog(@"%@",m.equipments[0].points[1].item.standard);
    
}
#pragma mark --- table delegte datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SectionSimple *view = [[[NSBundle mainBundle] loadNibNamed:@"SectionSimple" owner:self options:nil]firstObject];
    
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataList.count;
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {

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
        return cell;
            
    }else{
        ItemTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTwoCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemTwoCell" owner:self options:nil]firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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