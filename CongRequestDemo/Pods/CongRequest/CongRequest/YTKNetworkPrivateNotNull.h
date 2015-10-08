//
//  YTKNetworkPrivateNotNull.h
//  PudiEdu
//
//  Created by cong on 15/10/2.
//  Copyright © 2015年 cong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTKNetworkPrivateNotNull : NSObject
+ (BOOL)checkJson:(id)json withValidator:(id)validatorJson byObj:(id)obj;
+(NSDictionary *)jsonValidatorByJsonStr:(NSString *)json;
@end
