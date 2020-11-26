//
//  HomeCell.h
//  JFBaseApp
//
//  Created by YingJie on 2020/11/25.
//  Copyright © 2020 英杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *routename;
+ (instancetype)cellInTableView:(UITableView *)tableView index:(NSInteger)index withIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
