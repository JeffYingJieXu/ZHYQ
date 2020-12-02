//
//  ItemOneCell.h
//  JFBaseApp
//
//  Created by YingJie on 2020/12/1.
//  Copyright © 2020 英杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMJDropdownMenu.h"
NS_ASSUME_NONNULL_BEGIN

@interface ItemOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *normalBtn;
@property (weak, nonatomic) IBOutlet LMJDropdownMenu *menu;
@property (nonatomic, weak) void(^ItemOneBlock)(BOOL normal,NSString *type);

@end

NS_ASSUME_NONNULL_END
