//
//  MainController.m
//  ZCTest
//
//  Created by GuoMs on 15/12/8.
//  Copyright © 2015年 guoms. All rights reserved.
//

#import "MainController.h"
#import "UIBarButtonItem+Extension.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "repondseModel.h"
#import "MJExtension.h"
#import "UIView+Extension.h"
#import "MBProgressHUD+MJ.h"
#import "user.h"
@interface MainController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) repondseModel *backModel;
@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"网站首页";
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(presentLeftMenuViewController:) image:@"menu-icon" highImage:@"menu-icon"];
    
   
    //1创建webView
    UIWebView *webView= [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    webView.height=webView.height-CGRectGetMaxY(self.navigationController.navigationBar.frame);
    [self.view addSubview:webView];
    self.webView=webView;
    
    //webView加载网页
    //加载Post请求
    NSString *body = [NSString stringWithFormat: @"from_type=IOS"];
    // NSString *body = [NSString stringWithFormat: @"ctl=deals&first_post=1"];
    //NSURL *url=[NSURL URLWithString:@"http://zctest.fanwe.com/wap/"];
    NSURL *url=[NSURL URLWithString:@"http://zctest.fanwe.com/wap/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"POST"];
    request.timeoutInterval=5.0;//设置请求超时为5秒
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    webView.delegate=self;
    [webView loadRequest:request];
    
}

-(repondseModel *)backModel{
    
    if (_backModel)return _backModel;
    _backModel=[[repondseModel alloc]init];
    return _backModel;
        
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    if (!self.webView.canGoBack) {
        [MBProgressHUD showMessage:nil];
    }
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUD];
    
}
#pragma mark 加载完毕
-(void)webViewDidFinishLoad:(UIWebView *)webView{
   
    //隐藏网络请求加载图标
    [UIApplication sharedApplication].networkActivityIndicatorVisible=false;
    //加载js文件
    NSString *path=[[NSBundle mainBundle] pathForResource:@"fun.js" ofType:nil];
    NSString *jsStr=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载js文件到页面
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
    
    //注意！！！一定是网页加载完成调用一下方法
    //iOS调用js
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //js调用iOS
    //第一种情况
    //其中test1就是js的方法名称，赋给是一个block 里面是iOS代码
    //此方法最终将打印出所有接收到的参数，js参数是不固定的 我们测试一下就知道
    context[@"pass_parameter"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (JSValue * obj in args) {
            NSString *JsonString=[obj toString];
            NSData *JsonData=[JsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            if (err) {
                NSLog(@"解析失败");
            }else{
                NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:JsonData options:NSJSONReadingMutableContainers error:&err];
                NSLog(@"%@",dic);
                self.backModel=[repondseModel mj_objectWithKeyValues:dic];
                [self setNavBar];
            }
        }
        
    };
    
    context[@"login_success"] = ^() {
        // NSLog(@"login_success");
        NSArray *args = [JSContext currentArguments];
        for (JSValue * obj in args) {
            NSString *JsonString=[obj toString];
            // NSLog(@"%@",JsonString);
            NSData *JsonData=[JsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            if (err) {
                NSLog(@"解析失败");
            }else{
                NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:JsonData options:NSJSONReadingMutableContainers error:&err];
                NSLog(@"%@",dic);
                user *userStatic=[user shareUser];
                userStatic=[user mj_objectWithKeyValues:dic];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"login_success" object:self userInfo:dic];
                //user写入文件
              //  [NSKeyedArchiver archiveRootObject:[user shareUser] toFile:SavePath];
            }
        }
    };
    context[@"logout"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (JSValue * obj in args) {
            NSString *JsonString=[obj toString];
            NSLog(@"%@",JsonString);
            //            NSData *JsonData=[JsonString dataUsingEncoding:NSUTF8StringEncoding];
            //            NSError *err;
            //            if (err) {
            //                NSLog(@"解析失败");
            //            }else{
            //                NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:JsonData options:NSJSONReadingMutableContainers error:&err];
            //                NSLog(@"%@",dic);
            //                self.backModel=[repondseModel mj_objectWithKeyValues:dic];
            //                [self setNavBar];
            //            }
        }
    };
    [MBProgressHUD hideHUD];
    [self deal_login_init];
}

//用户登录初始化
-(void)deal_login_init{
    user *USER=[user shareUser];
    USER=[NSKeyedUnarchiver unarchiveObjectWithFile:SavePath];
    //调用本地JS
    NSString*jsToGetHTMLSource =[NSString stringWithFormat:@"deal_login_init('%@','%@')",USER.user_name,USER.user_pwd];
    [self.webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
}
-(void)setNavBar{
    self.title=self.backModel.title;
    if ([self.backModel.is_show_left_button isEqualToString:@"back"]) {
         self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self.webView action:@selector(goBack) image:@"ico_back" highImage:@"ico_back"];
    }else{
        
        self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(presentLeftMenuViewController:) image:@"menu-icon" highImage:@"menu-icon"];
        self.title=@"首页";
    }

}

@end
