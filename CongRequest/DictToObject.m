//
//  PrintObject.m
//  WuKongUserClient
//
//  Created by 悟空设计部 on 15/8/27.
//  Copyright (c) 2015年 cong. All rights reserved.
//

#import "DictToObject.h"
#import <objc/runtime.h>
@implementation DictToObject


+(NSDictionary*)getObjectData:(id)obj

{
    
    NSMutableDictionary  *dic = [NSMutableDictionary dictionary];
    
    unsigned int propsCount;
    
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    
    
    for(int i = 0;i < propsCount; i++)
    {
        
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        
        id value = [obj valueForKey:propName];
        
        if(value == nil)
            
        {
            
            value = [NSNull null];
            
        }
        else
        {
            value = [self getObjectInternal:value];
            
        }
        
        
//        const char * attributes = property_getAttributes(prop);//获取属性类型
        
        [dic setObject:value forKey:propName];
        
    }
    
    return dic;
}


+(NSDictionary *)getObjectType:(id)obj{
    
    NSMutableDictionary  *dic = [NSMutableDictionary dictionary];
    
    unsigned int propsCount;
    
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    
    
    for(int i = 0;i < propsCount; i++)
    {
        
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        
        NSString * value_type = [[NSString alloc] initWithCString:(const char*)property_getAttributes(prop) encoding:NSASCIIStringEncoding];//获取属性类型
        
        [dic setObject:value_type forKey:propName];
        
    }
    return dic;
}




+(void)print:(id)obj

{
    
    NSLog(@"%@", [self getObjectData:obj]);
    
}





+(NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error

{
    
    return [NSJSONSerialization dataWithJSONObject:[self getObjectData:obj] options:options error:error];
    
}



+(id)getObjectInternal:(id)obj

{
    
    if([obj isKindOfClass:[NSString class]] ||
       [obj isKindOfClass:[NSNumber class]] ||
       [obj isKindOfClass:[NSNull class]]) {
        
        return obj;
    }
    
    
    
    if([obj isKindOfClass:[NSArray class]])
        
    {
        
        NSArray
        *objarr = obj;
        
        NSMutableArray
        *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int i = 0;i < objarr.count; i++) {
            
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
            
        }
        
        return arr;
    }
    
    
    
    if([obj isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary
        *objdic = obj;
        
        NSMutableDictionary
        *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString *key in objdic.allKeys)
            
        {
            
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
            
        }
        
        return dic;
        
    }
    
    return [self getObjectData:obj];
    
}





+ (void)setAttributesDictionary:(NSDictionary *)aDict byObject:(id)object{
    @try {
        //获得映射字典
        NSDictionary *mapDictionary = [DictToObject getObjectData:object];
        
        NSDictionary *dict_type =  [DictToObject getObjectType:object];

        
        //如果子类没有重写attributeMapDictionary方法，则使用默认映射字典
        if (mapDictionary == nil) {
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithCapacity:aDict.count];
            for (NSString *key in aDict) {
                [tempDict setObject:key forKey:key];
            }
            mapDictionary = tempDict;
        }
        
        
        //遍历映射字典
        NSEnumerator *keyEnumerator = [mapDictionary keyEnumerator];
        id attributeName = nil;
        while ((attributeName = [keyEnumerator nextObject])) {
            //获得属性的setter
            SEL setter = [DictToObject _getSetterWithAttributeName:attributeName];
            
            if ([object respondsToSelector:setter]) {
                //获得映射字典的值，也就是传入字典的键
                NSString *aDictKey =attributeName;
                //            NSString *aDictKey = [mapDictionary objectForKey:attributeName];
                //获得传入字典的键对应的值，也就是要赋给属性的值
                id aDictValue = [aDict objectForKey:aDictKey];
                
                
                
                
                
                
#pragma mark -- 字典里面有字典会出问题
                
                if ([aDictValue isKindOfClass:[NSDictionary class]]) {
                    
                    Class newClass = [[object valueForKey:aDictKey] class];
                    
                    if (newClass) {
                        
                        id newObject = [newClass new];
                        
                        [DictToObject setAttributesDictionary:aDictValue byObject:newObject];
                        
                        //为属性赋值
                        [object performSelectorOnMainThread:setter withObject:newObject waitUntilDone:[NSThread isMainThread]];
                    }else{
                        
                        //首字母大写
                        NSString * str_className = [attributeName capitalizedStringWithLocale:[NSLocale currentLocale]];
                        newClass=NSClassFromString(str_className);
                        
                        
                        NSLog(@"warning:能不能知道这个类的对象是什么名字:%@,通过名字找对象", NSStringFromClass([[object valueForKey:aDictKey] class]));
                        
                        if (newClass) {
                            id newObject = [newClass new];
                            
                            [DictToObject setAttributesDictionary:aDictValue byObject:newObject];
                            
                            
                            
                            //为属性赋值
                            [object performSelectorOnMainThread:setter withObject:newObject waitUntilDone:[NSThread isMainThread]];
                            
                            NSLog(@"ok : 找到这个类 <%@>",str_className);
                        }else{
                            
                            
                            
                            NSLog(@"waring : 不存在这个类 <%@>",str_className);
                        }
                    }
                }else{
                    
                    //NSLog(@"%@,赋值的内容 : %@,数据的类型:%@",NSStringFromClass([aDictValue class]),aDictValue,dict_type[aDictKey]);
                    
                    //NSLog(@"数据的类型:%@",dict_type[aDictKey]);
                    
                    BOOL isFound =[dict_type[aDictKey] rangeOfString:@"Tq,N,V"].location != NSNotFound;
                   isFound = isFound ||[dict_type[aDictKey] rangeOfString:@"Ti,N,V"].location != NSNotFound;
                   
                    
                    
                    
                    BOOL isNum = [aDictValue isKindOfClass:[NSString class]] && isFound && [DictToObject isPureNumandCharacters:aDictValue];
//                    NSLog(@"isNum:%d,%@",isNum,aDictValue);

                    if (isNum) {
                        
                        
                        long long numm = [aDictValue longLongValue];
                        NSNumber * num = @(numm);
                        
                        
                        if ([[object valueForKey:aDictKey] isKindOfClass:[NSString class]]) {
                            NSString * str_num = [NSString stringWithFormat:@"%@",num];
                            [object setValue:str_num forKey:aDictKey];
                        }else{
                            [object setValue:num forKey:aDictKey];
                        }
                        
                        
                        
                    }else{
                        
                        if ([[object valueForKey:aDictKey] isKindOfClass:[NSString class]]) {
                            
                            [object setValue:[NSString stringWithFormat:@"%@",aDictValue] forKey:aDictKey];
                        }else{
                        
                        
                        if ([aDictValue isKindOfClass:[NSNumber class]] && isFound) {
                            NSNumber * num = aDictValue;
                            
                            if ([num isEqualToNumber:@(0)]) {
                                [object setValue:@(0) forKey:aDictKey];
                            }else{
                                
                                if (!aDictValue) {
                                   

                                         [object setValue:@(0) forKey:aDictKey];

                                }else if ([aDictValue isKindOfClass:[NSNull class]]) {

                                        [object setValue:@(0) forKey:aDictKey];

                                }else{

                                        [object setValue:num forKey:aDictKey];

                                }
                                
                                
                            }
                            
                        }else{
                            
                            //为属性赋值
//                            [object performSelectorOnMainThread:setter withObject:aDictValue waitUntilDone:[NSThread isMainThread]];
                            if (aDictValue) {
                                
                                if ([[object valueForKey:aDictKey] isKindOfClass:[NSString class]]) {
                                    
                                    [object setValue:[NSString stringWithFormat:@"%@",aDictValue] forKey:aDictKey];
                                }else{
                                
                               [object setValue:aDictValue forKey:aDictKey];
                                }
                            }
                           
         
                        }
                        
                        }
                    }
                }
            }
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"出现异常:%@  in  setAttributesDictionary",exception);
    }
    @finally {
        
    }
}

+ (SEL)_getSetterWithAttributeName:(NSString *)attributeName
{
    NSString *firstAlpha = [[attributeName substringToIndex:1] uppercaseString];
    NSString *otherAlpha = [attributeName substringFromIndex:1];
    NSString *setterMethodName = [NSString stringWithFormat:@"set%@%@:", firstAlpha, otherAlpha];
    return NSSelectorFromString(setterMethodName);
}


//判断都是数字
+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}



/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (![jsonString isKindOfClass:[NSString class]]) {
        NSLog(@"@waring : 不是字符串，不能转化为字典");
        return nil;
    }
   
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json字符串转字典,解析失败：%@,[%@]",err,jsonString);
        return nil;
    }
    return dic;
}

+ (NSString*)dictionaryToJson:(id)dic

{
    
    if ([dic isKindOfClass:[NSNull class]]||!dic) {
        NSLog(@"json字符串转字典,解析失败：%@",dic);
        return @"{}";
    }
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    if(parseError) {
        NSLog(@"json字符串转字典,解析失败：%@,[%@]",parseError,dic);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


@end
