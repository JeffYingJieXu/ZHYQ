//
//  RecordDetailCell.m
//  JFBaseApp
//
//  Created by YingJie on 2020/11/27.
//  Copyright © 2020 英杰. All rights reserved.
//

#import "RecordDetailCell.h"

@implementation RecordDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewRadius(self.basev, 5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellInTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier
{
    RecordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordDetailCell" owner:self options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
@end
