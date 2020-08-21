//
//  WorkCellA.m
//  JFBaseApp
//
//  Created by YingJie on 2020/8/21.
//  Copyright © 2020 英杰. All rights reserved.
//

#import "WorkCellA.h"

@implementation WorkCellA

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellInTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier
{
    WorkCellA *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WorkCellA" owner:self options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KWhiteColor;
    }
    return cell;
}


@end
