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
@property (nonatomic,assign) NSInteger startX;
@end

@implementation AddPicScroll

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat w = frame.size.width/4;
        _picW = w;
        _startX = 0;
        UIImageView *addv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, w-30, w-30)];
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

- (void)setPicsObj:(NSArray *)picsObj {
    _picsObj = picsObj;
    
    [self removeAllSubviews];
    NSMutableArray *marr = [NSMutableArray array];
  
    for (int i=0; i<picsObj.count; i++) {
        
        AddPicView *addv = [[AddPicView alloc] initWithFrame:CGRectMake(_picW*i, 0, _picW, _picW)];
        [self addSubview:addv];
        
        [marr addObject:addv.imgv];
        [self.chosePicURLs addObject:[picsObj[i] valueForKey:@"path"]];
//        addv.imgv.image = _chosePics[i];
        [addv.imgv sd_setImageWithURL:[NSURL URLWithString:[picsObj[i] valueForKey:@"path"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            _startX++;
            if (_startX == picsObj.count) {
                for (UIImageView *view in marr) {
                    [self.chosePics addObject:view.image];
                }
            }
        }];
        [addv whenTapped:^{
            [AvatarBrowser showImage:addv.imgv];
        }];
        [addv.deleteV whenTapped:^{
            [self deletePicWith:i];
        }];
    }
    UIImageView *addv = [[UIImageView alloc] initWithFrame:CGRectMake(_picW*picsObj.count+15, 15, _picW-30, _picW-30)];
    addv.image = [UIImage imageNamed:@"uploadpic"];
    [self addSubview:addv];
    [addv whenTapped:^{
       [self addPictures];
    }];
    
    self.contentSize = CGSizeMake(_picW*picsObj.count+_picW, _picW);

    [self layoutIfNeeded];
    
    if (self.picUrlsBlock && _chosePicURLs.count>0) {
        self.picUrlsBlock(_chosePicURLs);
    }
    
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
    UIImageView *addv = [[UIImageView alloc] initWithFrame:CGRectMake(_picW*_chosePics.count+15, 15, _picW-30, _picW-30)];
    addv.image = [UIImage imageNamed:@"uploadpic"];
    [self addSubview:addv];
    [addv whenTapped:^{
       [self addPictures];
    }];
    
    self.contentSize = CGSizeMake(_picW*_chosePics.count+_picW, _picW);

    [self layoutIfNeeded];
    
    if (self.picUrlsBlock && _chosePicURLs.count>0) {
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
            [MBProgressHUD showTipMessageInWindow:[NSString stringWithFormat:@"请每次最多上传%d张照片",weakSelf.maxPics]];
            return;
        }
//        UIImage *imga = photos[0];
        for (NSInteger i=0;i<photos.count;i++) {
            
//            @"http://10.100.40.89:30001/system/dfs/uploadFile"
         
        [PPNetworkHelper uploadImagesWithURL:UploadPic parameters:@{@"bucketName":@"smartxmd"} name:@"filePic" images:@[photos[i]] fileNames:@[[NSString stringWithFormat:@"pic%ld",i]] imageScale:0.5 imageType:@"png" progress:^(NSProgress *progress) {
            
        } success:^(id responseObject) {
            NSDictionary *dic = [self dictionaryForJsonData:responseObject];;
            if (dic && [dic valueForKey:@"data"]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    [weakSelf.chosePicURLs addObject:[dic valueForKey:@"data"]];
                    [weakSelf.chosePics addObject: photos[i]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self refreshScroll];
                    });
                    
                });
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",[error localizedDescription]);
        }];
        
        
        }
        
        
    }];
}

- (NSDictionary *)dictionaryForJsonData:(NSData *)jsonData

{

    if (![jsonData isKindOfClass:[NSData class]] || jsonData.length < 1) {

        return nil;

    }

    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];

    if (![jsonObj isKindOfClass:[NSDictionary class]]) {

        return nil;

    }

    return [NSDictionary dictionaryWithDictionary:(NSDictionary *)jsonObj];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
