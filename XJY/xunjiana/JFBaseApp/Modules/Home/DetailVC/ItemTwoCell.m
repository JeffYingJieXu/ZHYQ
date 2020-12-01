//
//  ItemTwoCell.m
//  JFBaseApp
//
//  Created by YingJie on 2020/12/1.
//  Copyright © 2020 英杰. All rights reserved.
//

#import "ItemTwoCell.h"

@implementation ItemTwoCell

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
    if (sender.selected) {
        self.erorBtn.selected = NO;
        self.choseBtn.selected = YES;
    } else {
        self.choseBtn.selected = NO;
    }
}
- (IBAction)erorClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.normalBtn.selected = NO;
        self.choseBtn.selected = NO;
    }
}

@end
