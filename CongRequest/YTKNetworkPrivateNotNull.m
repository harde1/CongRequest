//
//  YTKNetworkPrivateNotNull.m
//  PudiEdu
//
//  Created by cong on 15/10/2.
//  Copyright © 2015年 cong. All rights reserved.
//

#import "YTKNetworkPrivateNotNull.h"
#import "PrintObject.h"

@implementation YTKNetworkPrivateNotNull


+ (BOOL)checkJson:(id)json withValidator:(id)validatorJson byObj:(id)obj{
    
    return [self newCheckJson:json withValidator:validatorJson byObj:obj];
}
+ (BOOL)newCheckJson:(id)json withValidator:(id)validatorJson byObj:(id)obj{
    if ([json isKindOfClass:[NSDictionary class]] &&
        [validatorJson isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = json;
        NSDictionary * validator = validatorJson;
        BOOL result = YES;
        NSEnumerator * enumerator = [validator keyEnumerator];
        NSString * key;
        
        while ((key = [enumerator nextObject]) != nil) {
            id value = dict[key];
            id format = validator[key];
            
            if ([value isKindOfClass:[NSDictionary class]]
                || [value isKindOfClass:[NSArray class]]) {
                result = [self checkJson:value withValidator:format byObj:obj];
                
                if (!result) {
                    break;
                }
                
            } else {
                
                if ([value isKindOfClass:format] == NO &&
                    [value isKindOfClass:[NSNull class]] == NO) {
                    
                    result = NO;
                    break;
                }else if([value isKindOfClass:[NSNull class]]){
                    
                    NSLog(@"有空值进行排空:k:%@,v:%@,for:%@",key,value,format);
                    
                    NSMutableDictionary * newDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                    
                    newDict[key] = [format new];
                    json = newDict;
                    
                    //把空值去掉
                    
                    YTKRequest * yTKRequest = (YTKRequest *)obj;
                    
                    
                    NSString * str_dict = [YTKRequest dictionaryToJson:yTKRequest.notNullDict.targetDict];
                    
                    //"regip" : null
                    NSString * str_change = @"";
                    
                    NSString * str_change_ori = [NSString stringWithFormat:@"\"%@\" : null",key];
                    
                    id oo = [format new];
                    if ([oo isKindOfClass:[NSArray class]]) {
                        str_change = [NSString stringWithFormat:@"\"%@\" : []",key];
                    }else  if ([oo isKindOfClass:[NSDictionary class]]) {
                        str_change = [NSString stringWithFormat:@"\"%@\" : {}",key];
                    }else if ([oo isKindOfClass:[NSString class]]) {
                        str_change = [NSString stringWithFormat:@"\"%@\" : \"\"",key];
                    }else if ([oo isKindOfClass:[NSNumber class]]) {
                        str_change = [NSString stringWithFormat:@"\"%@\" : 0",key];
                    }
                    
                    str_dict = [str_dict stringByReplacingOccurrencesOfString:str_change_ori withString:str_change];
                    
                    
                    yTKRequest.notNullDict.targetDict =[YTKRequest dictionaryWithJsonString:str_dict];
                    
                    
                }
            }
        }
        
        return result;
    } else if ([json isKindOfClass:[NSArray class]] &&
               [validatorJson isKindOfClass:[NSArray class]]) {
        NSArray * validatorArray = (NSArray *)validatorJson;
        if (validatorArray.count > 0) {
            NSArray * array = json;
            NSDictionary * validator = validatorJson[0];
            for (id item in array) {
                BOOL result = [self checkJson:item withValidator:validator byObj:obj];
                if (!result) {
                    return NO;
                }
            }
        }
        return YES;
    } else if ([json isKindOfClass:validatorJson]) {
        return YES;
    } else {
        return NO;
    }
}


+(NSDictionary *)jsonValidatorByJsonStr:(NSString *)json{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:[YTKRequest dictionaryWithJsonString:json]];
    
    [self dictToClassDict:dict];
    
    
    return dict;
}


+(void)dictToClassDict:(NSMutableDictionary *)mdict{

    
    
    NSArray * allKey = [mdict allKeys];
    
    for (NSString * key in allKey) {
 
        id value = mdict[key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary * validatorDict = (NSDictionary *)value;
            if (validatorDict.count>0) {
                NSMutableDictionary * newDict = [NSMutableDictionary dictionaryWithDictionary:validatorDict];
                [self dictToClassDict:newDict];
                mdict[key] = newDict;
                
            }else{
                mdict[key] = [NSDictionary class];
            }
            
        }else if([value isKindOfClass:[NSArray class]]) {
            NSArray * arr = value;
            NSMutableArray * validatorArray = [NSMutableArray arrayWithArray:value];
            
            if (arr.count > 0) {
                
                for (int i=0;i<arr.count;i++) {
                    
                    NSDictionary * item = validatorArray[i];
                    NSMutableDictionary * newDict = [NSMutableDictionary dictionaryWithDictionary:item];
                    [self dictToClassDict:newDict];
                    [validatorArray replaceObjectAtIndex:i withObject:newDict];
                }
                
            }else{
                mdict[key] = [NSArray class];
                
            }
        }else{
            
            if ([value isKindOfClass:[NSNumber class]]) {
                  mdict[key] = [NSNumber class];
            }else if ([value isKindOfClass:[NSString class]]) {
                  mdict[key] = [NSString class];
            }else{
                  mdict[key] = [value class];
            }
          
        }
        
        
        
    }
}

@end
