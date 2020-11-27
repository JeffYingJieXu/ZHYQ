//
//  RecordDetailCell.h
//  JFBaseApp
//
//  Created by YingJie on 2020/11/27.
//  Copyright © 2020 英杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecordDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *basev;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *point;
@property (weak, nonatomic) IBOutlet UILabel *result;
@property (weak, nonatomic) IBOutlet UILabel *testnum;
@property (weak, nonatomic) IBOutlet UILabel *descrip;
+ (instancetype)cellInTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
