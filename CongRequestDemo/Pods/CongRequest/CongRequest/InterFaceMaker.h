//
//  Jiekou.h
//  PudiEdu
//
//  Created by cong on 15/10/2.
//  Copyright © 2015年 cong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterFaceMaker : NSObject
@property(nonatomic,copy)NSString * basePath;
+ (InterFaceMaker *)sharedManager;



+(void)makeInterFaceMakerByStr:(NSString *)str;
@end
