//
//  ServiceDeskCell.m
//  cheyijia
//
//  Created by Jeff Xu on 2019/7/27.
//  Copyright © 2019 Jeff Xu. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.baseview.layer.cornerRadius = 10;
    self.baseview.layer.cornerRadius = 8;
    self.baseview.layer.masksToBounds = NO;
    
    self.baseview.layer.shadowColor = KGray2Color.CGColor;
    self.baseview.layer.shadowOffset = CGSizeMake(1, 1);
    self.baseview.layer.shadowOpacity = 1;
    self.baseview.layer.shadowRadius = 3;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellInTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier
{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
@end
