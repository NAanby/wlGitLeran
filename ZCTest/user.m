//
//  user.m
//  ZCTest
//
//  Created by GuoMs on 15/12/11.
//  Copyright © 2015年 guoms. All rights reserved.
//

#import "user.h"


@implementation user

// 所有对象内存的分配，都会调用 allocWithZone 这方法
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    //一定要声明静态 instance
    static user *instance;
    //dispatch_once_t  是线程安全的，onceToken默认是0
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //代码永远只执行一次
        instance=[super allocWithZone:zone];
        //第一次登录时菜单栏选中网站首页
        instance.selectC=[NSIndexPath indexPathForRow:1 inSection:0];
    });
    
    return instance;
}
//共享实例，便于其他实例访问
+(instancetype)shareUser{
    //alloc  方法内部会调用allocWithZone:这方法。
    return [[user alloc] init];
}


//@property (copy,nonatomic) NSString  *  user_name;
//@property (copy,nonatomic) NSString  *  user_pwd;
//@property (assign,nonatomic) NSInteger   ID;

/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.user_name forKey:@"user_name"];
    [encoder encodeObject:self.user_pwd forKey:@"user_pwd"];
    
   
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.user_name = [decoder decodeObjectForKey:@"user_name"];
        self.user_pwd = [decoder decodeObjectForKey:@"user_pwd"];
       
      
    }
    return self;
}

@end
