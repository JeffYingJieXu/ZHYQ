//
//  XJModel.h
//  JFBaseApp
//
//  Created by YingJie on 2020/12/1.
//  Copyright © 2020 英杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class PointModel;
@class EqModel;
@interface XJModel : NSObject

@property (nonatomic,assign)  int ID;
@property (nonatomic,assign) NSString *name;
@property (nonatomic,strong) NSArray <EqModel *> *equipments;
@end

@interface EqModel : NSObject
@property (nonatomic,assign)  int ID;
@property (nonatomic,assign) NSString *name;
@property (nonatomic,strong) NSArray <PointModel *> *points;
@end

@interface ItemModel : NSObject
@property (nonatomic,assign) int ID;
@property (nonatomic,assign) NSString *name;
@property (nonatomic,assign) NSString *standard; //"是"
@property (nonatomic,assign) NSString *unit;
@end
 
@interface PointModel : NSObject
@property (nonatomic,assign)  int ID;
@property (nonatomic,assign) NSString *name;
@property (nonatomic,assign) NSString *type;
@property (nonatomic,strong) ItemModel *item;
@end
 
 






NS_ASSUME_NONNULL_END
