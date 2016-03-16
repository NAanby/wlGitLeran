//
//  ANNavController.m
//  ZCTest
//
//  Created by GuoMs on 15/12/8.
//  Copyright © 2015年 guoms. All rights reserved.
//

#import "ANNavController.h"

@interface ANNavController ()

@end

@implementation ANNavController

+(void)initialize{
    //统一设置NavigationBar的蓝底样式
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigation_bar_bg"]  forBarMetrics:UIBarMetricsDefault];
   
//    //统一头部标题栏样式
//    UIBarButtonItem *item=[UIBarButtonItem appearance];
//
    // 设置普通状态UIControlStateNormal
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];  //设置item颜色
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];   //统一设置item字体大小
   // [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//
//    
//    // 设置不可用状态UIControlStateNormal
//    NSMutableDictionary *distextAttrs = [NSMutableDictionary dictionary];
//    distextAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];  //设置item颜色
//    distextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
//    [item setTitleTextAttributes:distextAttrs forState:UIControlStateDisabled];
    
    [UINavigationBar appearance].titleTextAttributes=textAttrs;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
