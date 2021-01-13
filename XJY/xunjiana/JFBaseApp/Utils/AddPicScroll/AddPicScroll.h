//
//  AddPicScroll.h
//  JFBaseApp
//
//  Created by YingJie on 2021/1/13.
//  Copyright © 2021 英杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddPicScroll : UIScrollView

@property (nonatomic,assign) int maxPics;
@property (copy, nonatomic) void(^picUrlsBlock)(NSArray *picUrls);

@end

NS_ASSUME_NONNULL_END
