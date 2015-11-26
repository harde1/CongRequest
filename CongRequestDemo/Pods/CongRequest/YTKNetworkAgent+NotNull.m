//
//  YTKNetworkAgent+NotNull.m
//  PudiEdu
//
//  Created by cong on 15/10/2.
//  Copyright © 2015年 cong. All rights reserved.
//

#import "YTKNetworkAgent+NotNull.h"
#import "YTKNetworkPrivateNotNull.h"
#import "YTKRequest+ResponseNotNull.h"
#import "YTKRequest.h"
@implementation YTKNetworkAgent (NotNull)


- (BOOL)checkResult:(YTKBaseRequest *)request {
    BOOL result = [request statusCodeValidator];
    if (!result) {
        return result;
    }
   
     id validator = [request jsonValidator];
    if ([request respondsToSelector: NSSelectorFromString(@"jsonStringValidator")]) {
        if ([request valueForKey:@"jsonStringValidator"]) {
            NSString * jsonString =[request valueForKey:@"jsonStringValidator"];
            validator =  [YTKNetworkPrivateNotNull jsonValidatorByJsonStr:jsonString];
            
            
        }
    }
    
    if (validator != nil) {
        id json = [request responseJSONObject];

        YTKRequest * yTKRequest = (YTKRequest *)request;
        
        if (!yTKRequest.notNullDict) {
            yTKRequest.notNullDict = [NotNullDict new];
        }

         yTKRequest.notNullDict.targetDict = json;
        result = [YTKNetworkPrivateNotNull checkJson:json withValidator:validator byObj:request];
    }
    
    return result;
}
@end
