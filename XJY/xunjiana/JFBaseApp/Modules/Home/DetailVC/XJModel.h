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
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) BOOL show;
@property (nonatomic,assign) BOOL finish;
@property (nonatomic,strong) NSArray <EqModel *> *equipments;
@property (nonatomic,strong) NSMutableArray *totalArr;
@end

@interface EqModel : NSObject
@property (nonatomic,assign)  int ID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) BOOL show;
@property (nonatomic,assign) BOOL normal;
@property (nonatomic,assign) BOOL haveDone;

@property (nonatomic,copy) NSString *doneTime; //操作时间

@property (nonatomic,assign) NSString *state; // 运行 备用 检修
@property (nonatomic,strong) NSArray <PointModel *> *points;
@end

@interface ItemModel : NSObject
@property (nonatomic,assign) int ID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *standard; //"是"
@property (nonatomic,assign) NSString *unit;
@end
 

@interface PointModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *value; //测值
@property (nonatomic,copy) NSString *remark; //备注
@property (nonatomic,copy) NSString *doneTime; //操作时间
@property (nonatomic,assign) BOOL isReport;


@property (nonatomic,assign) NSString *state;//用作比对
/// 正常 or 异常
@property (nonatomic,assign) BOOL normalChose;
@property (nonatomic,assign) BOOL errorChose;

@property (nonatomic,assign) BOOL haveDone;

@property (nonatomic,strong) ItemModel *item;

/// itemOne的正常全部勾选
@property (nonatomic,assign) BOOL normal;
@end
 
 






NS_ASSUME_NONNULL_END
