//
//  BaseRequest.m
//  PudiEdu
//
//  Created by cong on 15/10/2.
//  Copyright © 2015年 cong. All rights reserved.
//

#import "BaseRequest.h"

@implementation BaseRequest


-(void)setRequestOperation:(AFHTTPRequestOperation *)requestOperation{
    
    requestOperation.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    [super setRequestOperation:requestOperation];
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}
@end

