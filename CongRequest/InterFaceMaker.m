//
//  Jiekou.m
//  PudiEdu
//
//  Created by cong on 15/10/2.
//  Copyright © 2015年 cong. All rights reserved.
//

#import "InterFaceMaker.h"

@implementation InterFaceMaker

+ (InterFaceMaker *)sharedManager
{
    static InterFaceMaker *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}



+(void)makeInterFaceMakerByStr:(NSString *)str {
    NSDictionary* dict = [self dictionaryWithHttp:str];
    
    NSString * path_ori = [[[str componentsSeparatedByString:@"?"] firstObject] lastPathComponent];
    
    
    NSMutableCharacterSet *base = [NSMutableCharacterSet letterCharacterSet]; //字母
    NSCharacterSet *decimalDigit = [NSCharacterSet decimalDigitCharacterSet];   //十进制数字
    [base formUnionWithCharacterSet:decimalDigit];    //字母加十进制
    
    
    
    
    NSString * path = [path_ori capitalizedStringWithLocale:[NSLocale currentLocale]];
    
    
    [base invert];
    
    NSString *  safe_path = [[path componentsSeparatedByCharactersInSet:base] componentsJoinedByString:@"_"];
    
    
    NSString * str_property = @"@property(copy,nonatomic)NSString * ";
    NSString * initWith = @"- (id)initWith";
    NSString * all_property = @"";
    NSArray * allKeys = [dict allKeys];
    
    //父类
    NSString * str_super = @"BaseRequest";
    
    //.h文件
    NSString * str_h = @"//\n//  %@Api.h\n//  接口文件自动产生\n//\n//  Created by cong\n//\n\n#import <Foundation/Foundation.h>\n#import \"%@.h\"\n\n@interface %@Api : %@\n%@\n%@\n@end";
    NSString * initWith_h = @"";
    //.m文件
    NSString * str_m = @"//\n//  %@Api.h\n//  接口文件自动产生\n//\n//  Created by cong\n//\n\n#import \"%@Api.h\"\n#import \"UtilReflect.h\"\n\n@implementation %@Api\n\n%@ {\n    self = [super init];\n    if (self) {\n        %@\n    }\n    return self;\n}\n- (NSString *)requestUrl {\n    return @\"/%@\";\n}\n\n- (id)requestArgument {\n    return [UtilReflect dictionartRreflectDataWith:self];\n}\n- (NSInteger)cacheTimeInSeconds {\n    return %d;\n}\n\n//json检查，新增方法,把正确的json例子放在这里，它就会自动判断参数正确不正确\n-(id)jsonStringValidator{\nreturn nil;\n\n}\n@end\n";
    int int_cachetime = 30;
    NSString * initWith_m = @"";
    NSString * all_x_eq_x = @"";
    
    if (allKeys&&(allKeys?allKeys.count==0:NO)) {
        initWith_m = @"-(instancetype)init";
    }
    
    
    for (NSString * key in allKeys) {
        //.h文件
        NSString * property = [NSString stringWithFormat:@"\n%@%@;",str_property,key];
        all_property = [all_property stringByAppendingString:property];
        
        
        //.m文件
        NSString * x_eq_x = [NSString stringWithFormat:@"\n        _%@ = %@;",key,key];
        all_x_eq_x = [all_x_eq_x stringByAppendingString:x_eq_x];
        
        //初始化方法
        if ([[allKeys lastObject]isEqual:key]) {
            //.h文件
            initWith_h = [initWith stringByAppendingString:[NSString stringWithFormat:@"%@:(NSString *)%@;\n",[key capitalizedStringWithLocale:[NSLocale currentLocale]],key]];
            
            //.m文件
            initWith_m = [initWith stringByAppendingString:[NSString stringWithFormat:@"%@:(NSString *)%@",[key capitalizedStringWithLocale:[NSLocale currentLocale]],key]];
        }else{
            //.h文件
            initWith = [initWith stringByAppendingString:[NSString stringWithFormat:@"%@:(NSString *)%@ ",[key capitalizedStringWithLocale:[NSLocale currentLocale]],key]];
            
            
            
        }
    }
    //.h文件
    str_h = [NSString stringWithFormat:str_h,safe_path,str_super,safe_path,str_super,all_property,initWith_h];
    
    
    
    //.m文件
    str_m = [NSString stringWithFormat:str_m,safe_path,safe_path,safe_path,initWith_m,all_x_eq_x,path_ori,int_cachetime];
    
    
    
    //对于错误信息
    NSError *error;
    //创建文件管理器
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString * loc_path = [self sharedManager].basePath;
    
    
    NSLog(@"%@\n\n\n\n%@",str_h,str_m);
    
    if (!loc_path) {
        NSLog(@"@waring:[InterFaceMaker sharedManager].baseUrl接口文件的保存路径还没有设置");
        
        return;
    }
    
    
    
    
    
    NSString * loc_path_h = [loc_path stringByAppendingPathComponent:[safe_path stringByAppendingString:@"Api.h"]];
    NSString * loc_path_m = [loc_path stringByAppendingPathComponent:[safe_path stringByAppendingString:@"Api.m"]];
    
    
    if (![fileMgr fileExistsAtPath:loc_path_h]) {
        [str_h writeToFile:loc_path_h atomically:YES
                  encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            NSLog(@"%@",error);
        }
        
        [str_m writeToFile:loc_path_m atomically:YES
                  encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
        
        
        NSLog(@"=======================接口文件已经产生=================\n%@\n%@",loc_path_h,loc_path_m);
        
    }
    
    
}


+(NSDictionary*)dictionaryWithHttp:(NSString*)http{
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    
    NSArray*arr=[http componentsSeparatedByString:@"?"];
    
    if (arr.count>=2) {
        
        NSMutableString*str=[[NSMutableString alloc]init];
        if (arr.count==2) {
            str=[arr objectAtIndex:1];
        }else{
            for (int i=0; i<arr.count-1; i++) {
                [str  appendFormat:@"%@?",[arr objectAtIndex:i+1]];
            }
            [str replaceCharactersInRange:NSMakeRange(str.length-1, 1) withString:@""];
        }
        
        NSArray*arr_class=[str componentsSeparatedByString:@"&"];
        for (int i=0; i<arr_class.count; i++) {
            NSArray*arr_temp=[[arr_class objectAtIndex:i]componentsSeparatedByString:@"="];
            
            
            
            NSMutableString*str_temp=[[NSMutableString alloc]init];
            
            
            if (arr_temp.count>2) {
                
                for (int i=0; i<arr_temp.count-1; i++) {
                    
                    [str_temp appendFormat:@"%@=",[arr_temp objectAtIndex:i+1]];
                }
                
                [str_temp replaceCharactersInRange:NSMakeRange(str_temp.length-1, 1) withString:@""];
                [dict setObject:str_temp forKey:[arr_temp objectAtIndex:0]];
                
            }else{
                [dict setObject:[arr_temp objectAtIndex:1] forKey:[arr_temp objectAtIndex:0]];
            }
            
        }
    }
    return dict;
}



@end
