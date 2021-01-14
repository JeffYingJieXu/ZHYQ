//
//  URLMacros.h
//  JFBaseApp
//
//  Created by Jeff Xu on 2019/4/18.
//  Copyright © 2019 英杰. All rights reserved.
//

#ifndef URLMacros_h
#define URLMacros_h

//内部版本号 每次发版递增
#define KVersionCode 1
/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */

#define DevelopSever    1
#define TestSever       0
#define ProductSever    0

#if DevelopSever

/**开发服务器*/
#define URL_main @"http://10.100.40.211:10080"
//#define URL_main @"http://192.168.11.122:8090" //展鹏

#elif TestSever

/**测试服务器*/
#define URL_main @"http://10.100.10.164:10080"

#elif ProductSever

/**生产服务器*/
#define URL_main @"http://120.195.38.107:38080"
#endif



#pragma mark - ——————— 详细接口地址 ————————

//测试接口
//NSString *const URL_Test = @"api/recharge/price/list";
#define URL_Test @"/api/cast/home/start"


#pragma mark - ——————— 用户相关 ————————
//自动登录
#define URL_user_auto_login @"/api/autoLogin"
//登录
#define URL_user_login @"/api/login"
//用户详情
#define URL_user_info_detail @"/api/user/info/detail"
//修改头像
#define URL_user_info_change_photo @"/api/user/info/changephoto"
//注释
#define URL_user_info_change @"/api/user/info/change"


//人员列表
#define Login_people [NSString stringWithFormat:@"%@/%@",URL_main,@"inspectors"]

//登录
#define Login_in [NSString stringWithFormat:@"%@/%@",URL_main,@"inspectors/login"]

//巡检任务查询
#define XJ_taskSearch [NSString stringWithFormat:@"%@/%@",URL_main,@"tasks/statistics/2/0"]

//巡检任务详情
#define XJ_taskDetail [NSString stringWithFormat:@"%@/%@",URL_main,@"task-results/pageDtail/0"]

//巡检任务列表
#define XJ_taskList [NSString stringWithFormat:@"%@/%@",URL_main,@"tasks"]

//巡检任务点击确认开始
#define XJ_taskStart [NSString stringWithFormat:@"%@/%@",URL_main,@"tasks/start"]

//获取巡检任务模板
#define TaskList [NSString stringWithFormat:@"%@/%@",URL_main,@"task-templates"]

//结束任务
#define TaskDone [NSString stringWithFormat:@"%@/%@",URL_main,@"task-results/saveBatch"]

//上传文件  图片
#define UploadPic [NSString stringWithFormat:@"%@/%@",URL_main,@"dfs/uploadFile"]


#endif /* URLMacros_h */
