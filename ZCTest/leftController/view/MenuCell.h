//
//  MenuCell.h
//  ZCTest
//
//  Created by GuoMs on 15/12/8.
//  Copyright © 2015年 guoms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MebuModel.h"
@interface MenuCell : UITableViewCell


+(instancetype)menuwithTableView:(UITableView *)tableView setData:(MebuModel *)model withRow:(NSInteger) row;
-(instancetype)setData:(MebuModel *)model withRow:(NSInteger) row;
@end
