//
//  AddPicView.m
//  cheyijia
//
//  Created by Jeff Xu on 2019/8/9.
//  Copyright © 2019 Jeff Xu. All rights reserved.
//

#import "AddPicView.h"
#define MarginX 15
@implementation AddPicView
// 步骤 1：重写initWithFrame:方法，创建子控件并 - 添加
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
       
        CGFloat w = frame.size.width - MarginX*2;
        UIImageView *imga = [[UIImageView alloc] initWithFrame:CGRectMake(MarginX, MarginX, w, w)];
        self.imgv = imga;
        [self addSubview:imga];
        imga.image  = [UIImage imageNamed:@"uploadpic"];
        imga.contentMode = UIViewContentModeScaleAspectFill;
        imga.layer.masksToBounds = YES;
        UIImageView *imgb = [[UIImageView alloc] initWithFrame:CGRectMake(w, 0, MarginX*2, MarginX*2)];
        self.deleteV = imgb;
        imgb.image = [UIImage imageNamed:@"redcha"];
        [self addSubview:imgb];
    }
    return self;
}
// 步骤 2：重写layoutSubviews，子控件设置frame
//- (void)layoutSubviews {
//
//    [super layoutSubviews];
//    CGSize size = self.frame.size;
//    self.lable.frame = CGRectMake(0, 0, size.width * 0.5, size.height * 0.5);
//}
//// 步骤 4： 子控件赋值
//- (void)setModel:(CustomUIViewModel *)model {
//
//    _model = model;
//    self.lable.text = model.name;
//}

@end
