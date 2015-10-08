//
//  YTKRequest+ResponseNotNull.m
//  PudiEdu
//
//  Created by cong on 15/10/2.
//  Copyright © 2015年 cong. All rights reserved.
//

#import "YTKRequest+ResponseNotNull.h"
#import <objc/runtime.h>
#import "YTKNetworkConfig.h"
static const void *notNullDictKey = &notNullDictKey;
@implementation YTKRequest (ResponseNotNull)
@dynamic notNullDict;

-(id)jsonStringValidator{
    
    return nil;
}


-(void)setNotNullDict:(NotNullDict *)notNullDict{
    objc_setAssociatedObject(self, &notNullDictKey, notNullDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NotNullDict *)notNullDict{
    return objc_getAssociatedObject(self, &notNullDictKey);
}


-(void)startNotNullWithCompletionBlockWithSuccess:(void (^)(YTKRequest * request ,NSDictionary * responseDict))success failure:(void (^)(YTKRequest *request))failure{
    
    
    NSLog(@"\n===========request===========\n%@%@?%@\n详细参数:\n%@",[YTKNetworkConfig sharedInstance].baseUrl ,[self requestUrl],[self dictTransitoString:[self requestArgument]], [self requestArgument]);
    
    [self startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        YTKRequest * yTKRequest = (YTKRequest *)request;
        
        
        
        if (yTKRequest.notNullDict.targetDict) {
            [yTKRequest saveJsonResponseToCacheFile:yTKRequest.notNullDict.targetDict];
            success(yTKRequest,yTKRequest.notNullDict.targetDict);
        }else{
            success(yTKRequest,yTKRequest.responseJSONObject);
        }
        
        
    } failure:^(YTKBaseRequest *request) {
        YTKRequest * yTKRequest = (YTKRequest *)request;
        
        NSLog(@"\n=========== 请求失败 ===========\n%@%@?%@\n详细参数:\n%@",[YTKNetworkConfig sharedInstance].baseUrl ,[self requestUrl],[self dictTransitoString:[self requestArgument]], [self requestArgument]);
        
        if (request.responseStatusCode==0) {
            NSLog(@"网络不给力，请检查网络配置");
        }else{
            failure(yTKRequest);
        }
    }];
}

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

/**
 *  字典转字符串
 *
 *  @param param 字段
 *
 *  @return 字符串
 */
- (NSString *)dictTransitoString:(NSDictionary *)param {
    if (param == nil || param.count == 0) {
        return @"";
    } else {
        NSString *dictStr = [NSString stringWithFormat:@"%@", param];
        dictStr = [dictStr stringByReplacingOccurrencesOfString:@"{\n    " withString:@""];
        dictStr = [dictStr stringByReplacingOccurrencesOfString:@";\n    " withString:@"&"];
        dictStr = [dictStr stringByReplacingOccurrencesOfString:@" = " withString:@"="];
        dictStr = [dictStr stringByReplacingOccurrencesOfString:@"\n}" withString:@""];
        dictStr = [dictStr stringByReplacingOccurrencesOfString:@";" withString:@""];
        dictStr = [dictStr stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
        dictStr = [dictStr stringByReplacingOccurrencesOfString:@"\"[\"" withString:@"[\""];
        dictStr = [dictStr stringByReplacingOccurrencesOfString:@"\"]\"" withString:@"\"]"];
        dictStr = [dictStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        return dictStr;
    }
}

@end
@implementation NotNullDict

-(instancetype)init{
    
    if (self = [super init]) {
        
        
    }
    return self;
}


@end