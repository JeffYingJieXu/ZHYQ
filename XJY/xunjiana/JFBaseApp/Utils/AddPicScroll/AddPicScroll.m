//
//  AddPicScroll.m
//  JFBaseApp
//
//  Created by YingJie on 2021/1/13.
//  Copyright © 2021 英杰. All rights reserved.
//

#import "AddPicScroll.h"
#import "SuPhotoPicker.h"
#import "AddPicView.h"

@interface AddPicScroll ()

@property (nonatomic,strong)NSMutableArray *chosePics;
@property (nonatomic,strong)NSMutableArray *chosePicURLs;
@property (nonatomic,assign) CGFloat picW;
@end

@implementation AddPicScroll

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat w = frame.size.width/4;
        _picW = w;
        UIImageView *addv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, w)];
        addv.image = [UIImage imageNamed:@"uploadpic"];
        [self addSubview:addv];
        [addv whenTapped:^{
           [self addPictures];
        }];
        
    }
    return self;
}
- (NSMutableArray *)chosePics
{
    if (!_chosePics) {
        _chosePics = [NSMutableArray array];
    }
    return _chosePics;
}

- (NSMutableArray *)chosePicURLs {
    if (!_chosePicURLs) {
        _chosePicURLs = [NSMutableArray array];
    }
    return _chosePicURLs;
}

- (void)refreshScroll{
    
    [self removeAllSubviews];
    for (int i=0; i<_chosePics.count; i++) {
        
        AddPicView *addv = [[AddPicView alloc] initWithFrame:CGRectMake(_picW*i, 0, _picW, _picW)];
        [self addSubview:addv];
        addv.imgv.image = _chosePics[i];
        [addv whenTapped:^{
            [AvatarBrowser showImage:addv.imgv];
        }];
        [addv.deleteV whenTapped:^{
            [self deletePicWith:i];
        }];
    }
    UIImageView *addv = [[UIImageView alloc] initWithFrame:CGRectMake(_picW*_chosePics.count, 0, _picW, _picW)];
    addv.image = [UIImage imageNamed:@"uploadpic"];
    [self addSubview:addv];
    [addv whenTapped:^{
       [self addPictures];
    }];
    
    self.contentSize = CGSizeMake(_picW*_chosePics.count+_picW, _picW);

    [self layoutIfNeeded];
    
    if (self.picUrlsBlock) {
        self.picUrlsBlock(_chosePicURLs);
    }
    
}
- (void)deletePicWith:(NSInteger)index{
    [_chosePics removeObjectAtIndex:index];
    [_chosePicURLs removeObjectAtIndex:index];
    [self refreshScroll];
}


#pragma mark - 添加图片
- (void)addPictures {
//    NSLog(@"666");
    if (_chosePicURLs.count>=_maxPics) {
        [MBProgressHUD showTipMessageInWindow:[NSString stringWithFormat:@"最多上传%d张照片",_maxPics]];
        return;
    }
    //    NSLog(@"添加图片");
    __weak typeof(self) weakSelf = self;
    SuPhotoPicker * picker = [[SuPhotoPicker alloc]init];
            picker.selectedCount = 1;
            picker.preViewCount = 10;
    
    UIViewController *vc = [kAppDelegate getCurrentVC];
    [picker showInSender:vc handle:^(NSArray<UIImage *> *photos) {
        
        if ((photos.count + weakSelf.chosePicURLs.count) > weakSelf.maxPics) {
            [MBProgressHUD showTipMessageInWindow:[NSString stringWithFormat:@"最多上传%d张照片",weakSelf.maxPics]];
            return;
        }
//        UIImage *imga = photos[0];
        
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
//            [weakSelf.chosePicURLs addObject:imgName];
//            [weakSelf.chosePics addObject: imga];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshScroll];
            });
            
        });
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
