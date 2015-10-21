//
//  WeatherApi.h
//  接口文件自动产生
//
//  Created by cong
//

#import "WeatherApi.h"
#import "ReflectUtil.h"

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

- (id)requestArgument {
    return [ReflectUtil dictionartRreflectDataWith:self];
}
- (NSInteger)cacheTimeInSeconds {
    return 30;
}

//json检查，新增方法,把正确的json例子放在这里，它就会自动判断参数正确不正确,原理就是判断返回来的接口类型有没有错，如果本来是字符串的字段，变成了其他的NSNumber,这里就会检测出来
-(id)jsonStringValidator{
return nil;

}
@end
