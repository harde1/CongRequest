//
//  ViewController.m
//  CongRequest
//
//  Created by cong on 15/10/8.
//  Copyright © 2015年 cong. All rights reserved.
//

#import "ViewController.h"
#import "CongRequest.h"

//这个是InterFaceMaker产生的代码
#import "WeatherApi.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //第2步、自动产生合格的接口文件
    [InterFaceMaker makeInterFaceMakerByStr:@"http://api.map.baidu.com/telematics/v3/weather?location=北京&output=json&ak=5slgyqGDENN7Sy7pw29IUvrZ"];
   
    //第3步上面那句执行后，就在你项目里面产生两个接口代码文件,上面的产生了
    WeatherApi * weatherApi = [[WeatherApi alloc]initWithAk:@"5slgyqGDENN7Sy7pw29IUvrZ" Location:@"北京" Output:@"json"];
    
    [weatherApi startNotNullWithCompletionBlockWithSuccess:^(YTKRequest *request, NSDictionary *responseDict) {
        NSLog(@"%@",request.responseString);
    } failure:^(YTKRequest *request) {
        
    }];
    
    
}

@end
