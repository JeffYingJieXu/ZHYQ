//
//  ServiceDeskCell.h
//  cheyijia
//
//  Created by Jeff Xu on 2019/7/27.
//  Copyright © 2019 Jeff Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *routename;
@property (weak, nonatomic) IBOutlet UILabel *dutyname;
@property (weak, nonatomic) IBOutlet UILabel *starttime;
@property (weak, nonatomic) IBOutlet UILabel *endtime;
@property (weak, nonatomic) IBOutlet UILabel *yichang;
@property (weak, nonatomic) IBOutlet UILabel *loujian;
@property (weak, nonatomic) IBOutlet UILabel *beiyong;
@property (weak, nonatomic) IBOutlet UILabel *normalnum;
@property (weak, nonatomic) IBOutlet UILabel *weixiu;
@property (weak, nonatomic) IBOutlet UIView *baseview;
@property (weak, nonatomic) IBOutlet UILabel *jianxiu;
@property (weak, nonatomic) IBOutlet UILabel *haoshi;

+ (instancetype)cellInTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
