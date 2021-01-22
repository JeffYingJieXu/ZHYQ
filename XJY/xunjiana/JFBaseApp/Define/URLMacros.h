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

#define DevelopSever    0
#define TestSever       0
#define ProductSever    1

#if DevelopSever

/**开发服务器*/
#define URL_main @"http://10.100.40.211:10080"

#elif TestSever

/**测试服务器*/
#define URL_main @"http://10.100.10.164:10080"

#elif ProductSever

/**生产服务器*/
#define URL_main NewApi
#endif


/*
城南热电: 124.70.162.99:30080
津西钢铁: 124.70.162.99:30081
日照钢铁: 124.70.162.99:30082
*/
//最新token
#define NewApi [[NSUserDefaults standardUserDefaults] objectForKey:@"newapi"]
#define SaveApi(obj) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"newapi"]

#pragma mark - ——————— 详细接口地址 ————————

//测试接口
//NSString *const URL_Test = @"api/recharge/price/list";
#define URL_Test @"/api/cast/home/start"



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
#define UploadPic [NSString stringWithFormat:@"%@/%@",URL_main,@"system/dfs/uploadFile"]


#endif /* URLMacros_h */
