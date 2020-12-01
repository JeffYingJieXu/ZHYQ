//
//  ItemOneCell.m
//  JFBaseApp
//
//  Created by YingJie on 2020/12/1.
//  Copyright © 2020 英杰. All rights reserved.
//

#import "ItemOneCell.h"
@interface ItemOneCell ()

@end
@implementation ItemOneCell
{
    NSArray *menuOptionTitles;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)normalClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    self.choseBtn.selected = sender.selected;

}



@end
