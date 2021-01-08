//
//  ItemTwoCell.h
//  JFBaseApp
//
//  Created by YingJie on 2020/12/1.
//  Copyright © 2020 英杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItemTwoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *normalBtn;
@property (weak, nonatomic) IBOutlet UIButton *erorBtn;
@property (weak, nonatomic) IBOutlet UIView *coverWhite;

@end

NS_ASSUME_NONNULL_END
