//
//  PrintObject.h
//  WuKongUserClient
//
//  Created by 悟空设计部 on 15/8/27.
//  Copyright (c) 2015年 cong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictToObject : NSObject

//通过对象返回一个NSDictionary，键是属性名称，值是属性值。
+(NSDictionary*)getObjectData:(id)obj;

//将getObjectData方法返回的NSDictionary转化成JSON
+(NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error;

//直接通过NSLog(输出getObjectData方法返回的NSDictionary
+(void)print:(id)obj;


+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+(NSString*)dictionaryToJson:(id)dic;

//传入字典，为object的属性赋值
+(void)setAttributesDictionary:(NSDictionary *)aDict byObject:(id)object;
+(NSDictionary *)getObjectType:(id)obj;
+ (BOOL)isPureNumandCharacters:(NSString *)string;

@end
