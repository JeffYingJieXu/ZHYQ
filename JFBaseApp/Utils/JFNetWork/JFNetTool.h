//
//  JFNetTool.h
//  cheyijia
//
//  Created by Jeff Xu on 2019/8/12.
//  Copyright © 2019 Jeff Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JFSuccessBlock)(NSDictionary *data,NSInteger code,NSString *msg);
typedef void (^JFFailBlock)(NSError *fail);

@interface JFNetTool : NSObject


/**
 网络封装
 @param url 接口名称
 @param dic 接口参数dic
 @param sucBack 成功回调
 @param failBack 失败回调
 */
+(void)post:(NSString *)url paramJson:(BOOL)isJsonStr params:(NSDictionary *)dic Suc:(JFSuccessBlock)sucBack Fail:(JFFailBlock)failBack;

+(void)get:(NSString *)url paramJson:(BOOL)isJsonStr params:(NSDictionary *)dic Suc:(JFSuccessBlock)sucBack Fail:(JFFailBlock)failBack;
@end


