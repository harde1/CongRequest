//
//  WeatherApi.h
//  接口文件自动产生
//
//  Created by cong
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface WeatherApi : BaseRequest

@property(copy,nonatomic)NSString * ak;
@property(copy,nonatomic)NSString * location;
@property(copy,nonatomic)NSString * output;
- (id)initWithAk:(NSString *)ak Location:(NSString *)location Output:(NSString *)output;

@end