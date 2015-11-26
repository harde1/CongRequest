//
//  UtilReflect.h
//  wukong
//
//  Created by cong on 15/8/4.
//  Copyright (c) 2015年 cong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReflectUtil : NSObject

+ (BOOL)reflectDataWith:(id)obj FromOtherObject:(id)dataSource;
+ (NSArray*)propertyKeysWith:(id)obj;
+ (NSDictionary *)dictionartRreflectDataWith:(id)obj;
+ (NSDictionary *)dictionartRreflectDataWithObject:(id)obj;
@end
