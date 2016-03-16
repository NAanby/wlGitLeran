//
//  user.h
//  ZCTest
//
//  Created by GuoMs on 15/12/11.
//  Copyright © 2015年 guoms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MebuModel.h"

#define SavePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"user.archive"]
@interface user : NSObject
+(instancetype)shareUser;
@property (copy,nonatomic) NSString  *  user_name;
@property (copy,nonatomic) NSString  *  user_pwd;
@property (assign,nonatomic) int   ID;
@property (strong,nonatomic) NSIndexPath *selectC;
@property (strong,  nonatomic) NSMutableArray<MebuModel*> *menuArray;
@end
