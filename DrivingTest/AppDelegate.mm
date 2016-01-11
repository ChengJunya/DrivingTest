//
//  AppDelegate.m
//  驾考刷题
//
//  Created by 程俊亚 on 15/12/6.
//  Copyright © 2015年 john. All rights reserved.
//

#import "AppDelegate.h"
#import "CYTabbarViewController.h"
#import "CYNavigationViewController.h"
#import "CYLeftDrawerController.h"
#import "MMDrawerController.h"
#import "SDWebImageManager.h"
#import "UMSocial.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    //1.创建窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];

    //2.设置根控制器
    //初始化左视图
    CYLeftDrawerController *leftTVC = [[CYLeftDrawerController alloc]init];
    CYNavigationViewController *leftNC = [[CYNavigationViewController alloc]initWithRootViewController:leftTVC];
    //    leftNC.view.backgroundColor = [UIColor redColor];
    CYTabbarViewController *tabarVc = [[CYTabbarViewController alloc] init];
    //初始化抽屉视图控制器
    MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:tabarVc leftDrawerViewController:leftNC];

    //设置抽屉抽出的宽度
    drawerController.maximumLeftDrawerWidth = __kScreenWidth - 80;
    //滑动手势开关抽屉
//    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];

    self.window.rootViewController = drawerController;

    [UMSocialData setAppKey:@"567d16a9e0f55abc680025de"];

//    _mapManager = [[BMKMapManager alloc] init];
//    BOOL ret = [_mapManager start:@"zuYmTc5e9gO0KWGzTngqUY4x" generalDelegate:nil];
//
//    if (!ret) {
//        NSLog(@"manager start failed!");
//    }

    //3.显示窗口
    [self.window makeKeyAndVisible];
    return YES;
}


-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{

    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    //1.取消下载
    [mgr cancelAll];
    //2.清除内存中的所有图片
    [mgr.imageCache clearMemory];

}
@end
