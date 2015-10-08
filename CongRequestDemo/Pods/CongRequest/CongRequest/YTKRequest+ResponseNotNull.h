//
//  YTKRequest+ResponseNotNull.h
//  PudiEdu
//
//  Created by cong on 15/10/2.
//  Copyright © 2015年 cong. All rights reserved.
//

#import "YTKRequest.h"
@class NotNullDict;
@interface YTKRequest (ResponseNotNull)

@property(strong,nonatomic)NotNullDict * notNullDict;
-(void)startNotNullWithCompletionBlockWithSuccess:(void (^)(YTKRequest * request ,NSDictionary * responseDict))success failure:(void (^)(YTKRequest *request))failure;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString*)dictionaryToJson:(id)dic;
-(id)jsonStringValidator;
@end


@interface NotNullDict : NSObject
@property(nonatomic,strong)id targetDict;
@end