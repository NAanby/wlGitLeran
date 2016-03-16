//
//  MenuCell.m
//  ZCTest
//
//  Created by GuoMs on 15/12/8.
//  Copyright © 2015年 guoms. All rights reserved.
//

#import "MenuCell.h"
#import "user.h"
#import "UIImageView+WebCache.h"
@interface MenuCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;



@end

@implementation MenuCell


+(instancetype)menuwithTableView:(UITableView *)tableView setData:(MebuModel *)model withRow:(NSInteger) row{
    
    static NSString *ID=@"MenuCell";
    MenuCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"MenuCell" owner:nil options:nil].lastObject;
        cell.image.contentMode=UIViewContentModeCenter;
    }
    
    
    return [cell setData:model withRow:(NSInteger) row];
}


-(instancetype)setData:(MebuModel *)model withRow:(NSInteger) row{
    //cell设置
    self.backgroundColor=[UIColor clearColor];
    if ([model.image rangeOfString:@"http" ].location!=NSNotFound) {
        NSLog(@"%@",model.image);
        [self.image sd_setImageWithURL:[NSURL URLWithString:model.image]];
       
    }else{
        self.image.image=[UIImage imageNamed:model.image];
    }
    self.title.text=model.title;
    self.title.textColor=[UIColor whiteColor];
    self.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_menu_item_select"]];
    if (row==[user shareUser].selectC.row) {
        self.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_menu_item_select"]];
    }else{
        self.backgroundView=nil;
    }
    return self;
    
}
- (void)awakeFromNib {
    
}



@end
