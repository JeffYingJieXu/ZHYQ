//
//  PiontDetailVC.h
//  JFBaseApp
//
//  Created by YingJie on 2020/12/7.
//  Copyright © 2020 英杰. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PiontDetailVC : RootViewController

@property(nonatomic,assign)BOOL normal,xiu,testPoint;
@property(nonatomic,copy) NSString *remark,*name,*standard,*value,*unit;

@property (nonatomic, copy) void(^someBlock)(BOOL normal,BOOL xiu, NSString *testNum, NSString *remark);

@end

NS_ASSUME_NONNULL_END
