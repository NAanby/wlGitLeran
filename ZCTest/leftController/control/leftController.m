//
//  leftController.m
//  ZCTest
//
//  Created by GuoMs on 15/12/8.
//  Copyright © 2015年 guoms. All rights reserved.
//

#import "leftController.h"
#import "MebuModel.h"
#import "MJExtension.h"
#import "MenuCell.h"
#import "MainController.h"
#import "ANNavController.h"
#import "webController.h"
#import "user.h"
#import "AFNetworking.h"
#define CellHeight 50
#define headViewHeight 30
@interface leftController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (copy,  nonatomic) NSString *userName;
@property (strong,  nonatomic) NSMutableArray *menuArray;
@end

@implementation leftController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTableview];
 
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(login_success:) name:@"login_success" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logout:) name:@"logout" object:nil];
}
-(void)logout:(NSNotification*)not{
    
     self.userName=nil;
    MebuModel *model=[self.menuArray firstObject];
    model.title=@"登录/注册";
    model.navTitle=@"登录/注册";
    self.menuArray[0]=model;
}

-(void)login_success:(NSNotification *)not{
    
    NSDictionary *userInfo=not.userInfo;
    self.userName=userInfo[@"user_name"];
    MebuModel *model=[self.menuArray firstObject];
    model.title=@"个人中心";
    model.navTitle=@"个人中心";
    self.menuArray[0]=model;
    
}



-(NSMutableArray *)menuArray{
    if (_menuArray)return _menuArray;
    _menuArray=[user shareUser].menuArray;
    return _menuArray;
}
/**
 *tableVuew设置
 */
-(void)setTableview{
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - headViewHeight-CellHeight *  self.menuArray.count) / 2.0f, self.view.frame.size.width, CellHeight *  self.menuArray.count+headViewHeight) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    
}


#pragma mark -
#pragma mark UITableView Datasource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return headViewHeight;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSLog(@"----ass");
    UILabel *headView=[[UILabel alloc]init];
    NSLog(@"%@",[user shareUser].user_name);
    if ([user shareUser].user_name) {
        headView.text=[NSString stringWithFormat:@"  \t %@,你好",[user shareUser].user_name];
    }else{
        headView.text=[NSString stringWithFormat:@"  \t %@",@"亲你还没有登录呢！"];
    }
    headView.textColor=[UIColor whiteColor];
    headView.font=[UIFont systemFontOfSize:15];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MebuModel *model=self.menuArray[indexPath.row];
    
    
     return [MenuCell menuwithTableView:tableView setData:model withRow:indexPath.row];
   
    
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MenuCell *newcell=[tableView cellForRowAtIndexPath:indexPath];
    MenuCell *oldcell=[tableView cellForRowAtIndexPath:[user shareUser].selectC];
    NSInteger oldRow=[user shareUser].selectC.row;
    [user shareUser].selectC=indexPath;
    [newcell setData:self.menuArray[indexPath.row] withRow:indexPath.row];
    [oldcell setData:self.menuArray[oldRow] withRow:oldRow];
//
    //有没有遇到过，导航+UITableView，在push，back回来之后，当前cell仍然是选中的状态。
    //当然，解决办法简单，添加一句[tableView deselectRowAtIndexPath:indexPath animated:YES]即可。
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    MebuModel *model=self.menuArray[indexPath.row];
    webController *control=[webController webControlerWithModel:model];
    [self.sideMenuViewController setContentViewController:[[ANNavController alloc] initWithRootViewController:control]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
  
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
