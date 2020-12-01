//
//  XJModel.m
//  JFBaseApp
//
//  Created by YingJie on 2020/12/1.
//  Copyright © 2020 英杰. All rights reserved.
//

#import "XJModel.h"

@implementation XJModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID":@"id"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"equipments": [EqModel class]};
}
@end

@implementation EqModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID":@"id"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"points": [PointModel class]};
}
@end


@implementation PointModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID":@"id"};
}
@end


@implementation ItemModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID":@"id"};
}
@end
