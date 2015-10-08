//
//  UtilReflect.m
//  wukong
//
//  Created by cong on 15/8/4.
//  Copyright (c) 2015年 cong. All rights reserved.
//

#import "UtilReflect.h"
#import <objc/runtime.h>
@implementation UtilReflect
/**
 *  反射赋值
 *
 *  @param obj        目标对象
 *  @param dataSource 网络数据
 *
 *  @return 成功失败
 */
+ (BOOL)reflectDataWith:(id)obj FromOtherObject:(id)dataSource
{
    BOOL ret = NO;
//    NSString * start = @"====== start ======";
//    NSString * end = @"====== end ======";
//    
//    DBLog(@"%@",start);
//    DBLog(@"%@",obj);
    //获得所有的属性的名字
    

    for (NSString *key in [UtilReflect propertyKeysWith:obj]) {
        
        //网络数据
        if ([dataSource isKindOfClass:[NSDictionary class]]) {
            ret = ([dataSource valueForKey:key]==nil)?NO:YES;
        }
        else
        {
            ret = [dataSource respondsToSelector:NSSelectorFromString(key)];
        }
        
        if (ret) {
            id propertyValue = [dataSource valueForKey:key];
            
            //该值不为NSNULL，并且也不为nil
            if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
                [obj setValue:propertyValue forKey:key];
//                DBLog(@"key:%@,value:%@",key,propertyValue);
            }
            
        }
    }
    
//    DBLog(@"%@",end);
    return ret;
}

+ (NSArray*)propertyKeysWith:(id)obj
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(properties);
    return keys;
}

+(NSDictionary *)dictionartRreflectDataWith:(id)obj{
    NSMutableDictionary * dict = [@{}mutableCopy];
    
    for (NSString *key in [UtilReflect propertyKeysWith:obj]) {
        
        id propertyValue=[obj valueForKey:key];
        
        if (propertyValue!=nil && ![propertyValue isKindOfClass:[NSNull class]]) {
            if([key isEqualToString:@"updateGroupInfoId"]){

                dict[@"id"] = propertyValue;
            }else if ([key isEqualToString:@"accountUserPo_nickName"]){
                dict[@"accountUserPo.nickName"]=propertyValue;
                
            }else if ([key isEqualToString:@"accountUserPo_headImg"]){
                dict[@"accountUserPo.headImg"]=propertyValue;
            }else if ([key isEqualToString:@"accountUserPo_gender"]){
                
                dict[@"accountUserPo.gender"]=propertyValue;
            }else if ([key isEqualToString:@"accountUserPo_facultyId"]){
                dict[@"accountUserPo.facultyId"]=propertyValue;
            }
            
            
            else{
            dict[key] = propertyValue;
            }
        }
    }
    return dict;
}

+(NSDictionary *)dictionartRreflectDataWithObject:(id)obj{
    NSMutableDictionary * dict = [@{}mutableCopy];
    
    for (NSString *key in [UtilReflect propertyKeysWith:obj]) {
        
        id propertyValue=[obj valueForKey:key];
        
        if (propertyValue!=nil && ![propertyValue isKindOfClass:[NSNull class]]) {
           
                dict[key] = propertyValue;
        
        }else{
        
         dict[key] = [NSNull new];
        }
    }
    return dict;
}



@end
