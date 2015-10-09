# CongRequest

 一个建立afn封装包YTKNetwork下的再次扩展包,可以称之为YTKNetwork二次扩展包,增加了json空值排除,优化了部分代码，和接口文件自动产生的类

# cocoapods
cocoapods内测版
pod 'CongRequest', :git => 'https://github.com/harde1/CongRequest'

# 使用方法
第1步、接口域名定义,我一般放在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];

config.baseUrl = @"http://api.map.baidu.com/telematics/v3";

InterFaceMaker * interFaceMaker = [InterFaceMaker sharedManager];

interFaceMaker.basePath = @"/Users/cong/Documents/CongRequest/CongRequestDemo/CongRequest/";

第2步、自动产生合格的接口文件
[InterFaceMaker makeInterFaceMakerByStr:@"http://api.map.baidu.com/telematics/v3/weather?location=北京&output=json&ak=5slgyqGDENN7Sy7pw29IUvrZ"];

第3步、上面那句执行后，就在你项目里面产生两个接口代码文件,上面的产生了,记得导入新生成的文件，就在项目的根目录，用interFaceMaker.basePath来指定的文件路径
WeatherApi * weatherApi = [[WeatherApi alloc]initWithAk:@"5slgyqGDENN7Sy7pw29IUvrZ" Location:@"北京" Output:@"json"];


[weatherApi startNotNullWithCompletionBlockWithSuccess:^(YTKRequest *request, NSDictionary *responseDict) {

NSLog(@"%@",request.responseString);


} failure:^(YTKRequest *request) {

}];

#Acknowledgements

AFNetworking
AFDownloadRequestOperation
Thanks for their great work.  


