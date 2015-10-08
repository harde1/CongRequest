//
//  main.m
//  CongRequest
//
//  Created by cong on 15/10/8.
//  Copyright © 2015年 cong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"



int main(int argc, char * argv[]) {
    @autoreleasepool {
     

        // return UIApplicationMain(argc, argv, nil, NSStringFromClass([YYAppDelegate class]));
        // return UIApplicationMain(argc, argv, @"UIApplication", NSStringFromClass([YYAppDelegate class]));
        /*
         argc: 系统或者用户传入的参数个数
         argv: 系统或者用户传入的实际参数
         1.根据传入的第三个参数创建UIApplication对象
         2.根据传入的第四个产生创建UIApplication对象的代理
         3.设置刚刚创建出来的代理对象为UIApplication的代理
         4.开启一个事件循环
         */
        

        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
