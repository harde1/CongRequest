//
//  WeatherApi.h
//  接口文件自动产生
//
//  Created by cong
//

#import "WeatherApi.h"
#import "UtilReflect.h"

@implementation WeatherApi

- (id)initWithAk:(NSString *)ak Location:(NSString *)location Output:(NSString *)output {
    self = [super init];
    if (self) {
        
        _ak = ak;
        _location = location;
        _output = output;
    }
    return self;
}
- (NSString *)requestUrl {
    return @"/weather";
}

//修改为get请求
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}
- (id)requestArgument {
    return [UtilReflect dictionartRreflectDataWith:self];
}
- (NSInteger)cacheTimeInSeconds {
    return 30;
}

//json检查，新增方法,把正确的json例子放在这里，它就会自动判断参数正确不正确
-(id)jsonStringValidator{
return nil;

}
@end
