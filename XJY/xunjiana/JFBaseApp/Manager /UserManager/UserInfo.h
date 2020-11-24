//
//  UserInfo.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/23.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GameInfo;

typedef NS_ENUM(NSInteger,UserGender){
    UserGenderUnKnow = 0,
    UserGenderMale, //男
    UserGenderFemale //女
};

@interface UserInfo : NSObject

@property (nonatomic,copy) NSString * phone;//登录账号
@property (nonatomic,copy) NSString * name;//昵称
@property (nonatomic,copy) NSString * company;//公司
@property (nonatomic,copy) NSString * position;//职位
@property (nonatomic,copy) NSString * email;//邮箱
@property (nonatomic,copy) NSString * custShortName;
@property (nonatomic,copy) NSString * ID;
@property (nonatomic,copy) NSString * signature;//个性签名
@property (nonatomic,copy) NSString * token,*type;//用户登录后分配的登录Token

@property(nonatomic,assign)long long userid;//用户ID
@property (nonatomic,copy) NSString * idcard;//展示用的用户ID
@property (nonatomic,copy) NSString * photo;//头像
@property (nonatomic,copy) NSString * nickname;//昵称
@property (nonatomic, assign) UserGender sex;//性别
@property (nonatomic,copy) NSString * imId;//IM账号
@property (nonatomic,copy) NSString * imPass;//IM密码
@property (nonatomic,assign) NSInteger  degreeId;//用户等级
//@property (nonatomic, strong) GameInfo *info;//游戏数据

@end
/*
 
 "phone" : "17352335869",
   "position" : "前端开发",
   "enableFlag" : "Y",
   "id" : "1262192820430798849",
   "company" : "昆岳互联大家庭",
   "signature" : null,
   "email" : null,
   "customerId" : "0",
   "type" : null,
   "custShortName" : null,
   "name" : "土拨鼠"
 
 */
