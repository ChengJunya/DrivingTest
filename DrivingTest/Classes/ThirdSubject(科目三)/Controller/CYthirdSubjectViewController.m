//
//  CYthirdSubjectViewController.m
//  驾考刷题
//
//  Created by 程俊亚 on 15/12/10.
//  Copyright © 2015年 john. All rights reserved.
//

#import "CYthirdSubjectViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "CYLeftDrawerController.h"
#import "CYSettingViewController.h"
@interface CYthirdSubjectViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation CYthirdSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];
    //设置内边距
    self.scrollview.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
}

- (void)setupLeftMenuButton
{
    //创建按钮
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc]initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    //为navigationItem添加LeftBarButtonItem
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(setting) image:@"Home_setting" highImage:nil];
}

- (void)leftDrawerButtonPress:(id)sender
{
    //开关左抽屉
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

}

/** 设置 */
- (void)setting {
    //进入设置的控制器
    CYSettingViewController *settingVc = [[CYSettingViewController alloc]init];

    [self.navigationController pushViewController:settingVc animated:YES];
}

@end
