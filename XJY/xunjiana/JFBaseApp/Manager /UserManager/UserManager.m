//
//  UserManager.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/22.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "UserManager.h"
#import "AFNetworking.h"
@implementation UserManager

SINGLETON_FOR_CLASS(UserManager);

-(instancetype)init{
    self = [super init];
    if (self) {
        //被踢下线
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onKick)
                                                     name:KNotificationOnKick
                                                   object:nil];
    }
    return self;
}


#pragma mark ————— 带参数登录 —————
-(void)login:(UserLoginType )loginType params:(NSDictionary *)params completion:(loginBlock)completion{

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
//    [PPNetworkHelper setValue:LatestToken ?:@"" forHTTPHeaderField:@"Authorization"];
    
//    NSString *urlStr =[NSString stringWithFormat:@"%@/%@",curUrl,JFLoginURL];
 
    [PPNetworkHelper POST:@"" parameters:params success:^(id responseObject) {
        [QMUITips hideAllTips];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [responseObject[@"code"] integerValue];

            NSDictionary *datadic = responseObject[@"result"]?:responseObject[@"data"];
            NSString *msg = responseObject[@"msg"];
            if ([datadic isKindOfClass:[NSNull class]]) {
                NSLog(@"空数据");
                NSLog(@"%@\n%@\n",params,responseObject);
    //                [QMUITips showInfo:msg];
            }
            if (code==0) {
                [self loginSuccess:datadic];
                if (completion) {
                    completion(YES,@"登录成功");
                }
            }else{
                if (completion) {
                    completion(NO,msg);
                }
            }
        }
    } failure:^(NSError *error) {
        [QMUITips hideAllTips];
        if (completion) {
            completion(NO,error.localizedDescription);
        }
        DLog(@"请求错误---%@---",error.localizedDescription);
    }];
    
}
- (void)loginSuccess:(NSDictionary *)datadic{
    NSDictionary *userdict = [datadic objectForKey:@"phone"];
            if(!userdict){
                return ;
            }
            self.isLogined = YES;
            self.curUserInfo = [UserInfo modelWithDictionary:userdict];
            self.curUserInfo.custShortName = StrFromDict(datadic, @"custShortName");
            [self saveUserInfo];
    
            [kUserDefaults setObject:self.curUserInfo.phone  forKey:@"oldAccount"];
            [kUserDefaults setObject:StrFormat(@"Bearer %@",datadic[@"token"])  forKey:@"latestToken"];
            [kUserDefaults synchronize];
            KPostNotification(@"jfuserinfo", @YES)
}
#pragma mark ————— 自动登录到服务器 —————
-(void)autoLoginToServer:(loginBlock)completion{
//    [PPNetworkHelper POST:NSStringFormat(@"%@%@",URL_main,URL_user_auto_login) parameters:nil success:^(id responseObject) {
//        [self LoginSuccess:responseObject completion:completion];
//
//    } failure:^(NSError *error) {
//        if (completion) {
//            completion(NO,error.localizedDescription);
//        }
//    }];
}

#pragma mark ————— 登录成功处理 —————
#pragma mark ————— 储存用户信息 —————
-(void)saveUserInfo{
    if (self.curUserInfo) {
        YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
        NSDictionary *dic = [self.curUserInfo modelToJSONObject];
        [cache setObject:dic forKey:KUserModelCache];
    }
    
}
#pragma mark ————— 加载缓存的用户信息 —————
-(BOOL)loadUserInfo{
    YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
    NSDictionary * userDic = (NSDictionary *)[cache objectForKey:KUserModelCache];
    if (userDic) {
        self.curUserInfo = [UserInfo modelWithJSON:userDic];
        return YES;
    }
    return NO;
}
#pragma mark ————— 被踢下线 —————
-(void)onKick{
    [self logout:nil];
}
#pragma mark ————— 退出登录 —————
-(void)logoutSimple{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    self.curUserInfo = nil;
    self.isLogined = NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"latestToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
    [cache removeAllObjects];
}
- (void)logout:(void (^)(BOOL, NSString *))completion{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationLogout object:nil];//被踢下线通知用户退出直播间
    
//    [[IMManager sharedIMManager] IMLogout];
    
    self.curUserInfo = nil;
    self.isLogined = NO;

//    //移除缓存
    YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
    [cache removeAllObjectsWithBlock:^{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"latestToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        KPostNotification(KNotificationLoginStateChange, nil)
  
        if (completion) {
            completion(YES,nil);
        }
    }];
    
//    KPostNotification(KNotificationLoginStateChange, @NO);
}

//jf
+(void)saveUserInfo:(NSDictionary *)dict{
    if (dict) {
        YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
        [cache setObject:dict forKey:KUserModelCache];
    }
}

+(UserInfo *)readUserInfo
{
    YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
    NSDictionary * userDic = (NSDictionary *)[cache objectForKey:KUserModelCache];
    if (userDic) {
        UserInfo *curUserInfo = [UserInfo modelWithJSON:userDic];
        return curUserInfo;
    }
    return nil;
}
//jf
@end
