//
//  JFNetTool.m
//  cheyijia
//
//  Created by Jeff Xu on 2019/8/12.
//  Copyright © 2019 Jeff Xu. All rights reserved.
//

#import "JFNetTool.h"
#import "PPNetworkHelper.h"

@implementation JFNetTool

+(void)post:(NSString *)url paramJson:(BOOL)isJsonStr params:(NSDictionary *)dic Suc:(JFSuccessBlock)sucBack Fail:(JFFailBlock)failBack{
    
    [PPNetworkHelper setRequestSerializer:isJsonStr ? PPRequestSerializerJSON : PPRequestSerializerHTTP];

     [PPNetworkHelper POST:url parameters:dic success:^(id responseObject) {
        [QMUITips hideAllTips];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [responseObject[@"code"] integerValue];
//            if (code ==102) {
//                KPostNotification(KNotificationLoginStateChange, nil)
//                return;
//            }
            
            NSDictionary *datadic = responseObject[@"result"]?:responseObject[@"data"];
            NSString *msg = responseObject[@"msg"];
            if ([datadic isKindOfClass:[NSNull class]]) {
                NSLog(@"空数据");
                NSLog(@"%@\n%@\n%@",url,dic,responseObject);
//                [QMUITips showInfo:msg];
            }
            if (code==0) {
                sucBack(datadic,code,msg);
            }
        }else
        {
            DLog(@"请求成功但未取到数据：%@",url);
        }
    } failure:^(NSError *error) {
        [QMUITips hideAllTips];
        failBack(error);
        DLog(@"请求错误---%@---%@",url,error.localizedDescription);
    }];
}

+(void)get:(NSString *)url paramJson:(BOOL)isJsonStr params:(NSDictionary *)dic Suc:(JFSuccessBlock)sucBack Fail:(JFFailBlock)failBack{
    [PPNetworkHelper setRequestSerializer:isJsonStr ? PPRequestSerializerJSON : PPRequestSerializerHTTP];

    [PPNetworkHelper GET:url parameters:dic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [QMUITips hideAllTips];
            NSInteger code = [responseObject[@"code"] integerValue];
//            if (code ==102) {
//                KPostNotification(KNotificationLoginStateChange, nil)
//                return;
//            }
            NSDictionary *datadic = responseObject[@"result"]?:responseObject[@"data"];
            NSString *msg = responseObject[@"msg"];
            if ([datadic isKindOfClass:[NSNull class]]) {
                NSLog(@"空数据");
                NSLog(@"%@\n%@\n%@",url,dic,responseObject);
//                [QMUITips showInfo:msg];
            }
            if (code==0) {
                sucBack(datadic,code,msg);
            }
        }else
        {
            DLog(@"请求成功但未取到数据：%@",url);
        }
    } failure:^(NSError *error) {
        [QMUITips hideAllTips];
        failBack(error);
     DLog(@"请求错误---%@---%@",url,error.localizedDescription);
    }];
    
}



@end
