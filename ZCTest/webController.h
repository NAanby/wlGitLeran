//
//  webController.h
//  ZCTest
//
//  Created by GuoMs on 15/12/10.
//  Copyright © 2015年 guoms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "MebuModel.h"
@interface webController : UIViewController
@property (nonatomic,copy) NSString *navTitle;
@property (nonatomic,copy) NSString *urlString;
@property (nonatomic,copy) NSString *bodyString;

//+(instancetype)shareWebController;
+(instancetype)webControlerWithModel:(MebuModel *)model;
@end
