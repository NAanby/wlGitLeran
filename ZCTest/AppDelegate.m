//
//  AppDelegate.m
//  ZCTest
//
//  Created by GuoMs on 15/12/8.
//  Copyright © 2015年 guoms. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"
#import "leftController.h"
#import "ANNavController.h"
#import "webController.h"
#import "AFNetworking.h"
#import "user.h"
#import "MebuModel.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self loadData];//加载menu数据
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        //设置侧滑菜单
    [self setSideMenu];
        
    [self.window makeKeyAndVisible];
    
    return YES;
}



/**
 *设置侧滑菜单
 */
-(void)setSideMenu{
    ANNavController *navigationController = [[ANNavController alloc] initWithRootViewController:[[MainController alloc]init]];
    leftController *leftMenuViewController = [[leftController alloc] init];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"bg_sliding_menu"];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    //sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    sideMenuViewController.scaleMenuView=NO;
    sideMenuViewController.scaleContentView=YES;
    self.window.rootViewController = sideMenuViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    
}

/**
 *加载menu数据,这里记住一定要用同步请求
 */
-(void)loadData{
   
    NSURL *url=[NSURL URLWithString:@"http://zctest.fanwe.com/public/app_left.log"];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSMutableArray *array=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
  
    [user shareUser].menuArray=[MebuModel mj_objectArrayWithKeyValuesArray:array];

    
}

/**
 SDImageCache 在初始化的时候会注册一些消息通知，在内存警告或退到后台的时候清理内存图片缓存，应用结束的时候清理过期图片。

 */
-(void)applicationWillTerminate:(UIApplication *)application{
    
    //1.得到管理者
    SDWebImageManager *mgr=[SDWebImageManager sharedManager];
 
    // 2.清除内存中的所有图片
    [mgr.imageCache clearMemory];
    [mgr.imageCache cleanDisk];
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
    //1.得到管理者
    SDWebImageManager *mgr=[SDWebImageManager sharedManager];
    
    // 2.清除内存中的所有图片
    [mgr.imageCache clearMemory];
    [mgr.imageCache cleanDisk];
    
}


@end
