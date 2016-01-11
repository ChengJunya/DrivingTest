//
//  CYLockViewController.m
//  驾考刷题
//
//  Created by 程俊亚 on 15/12/30.
//  Copyright © 2015年 john. All rights reserved.
//

#import "CYLockViewController.h"
#import "CYLockView.h"
@interface CYLockViewController ()

@end

@implementation CYLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_refresh_bg"]];
    CYLockView *lockView = [[CYLockView alloc] init];

    //设置大小和位置
    lockView.bounds = CGRectMake(0, 0, __kScreenWidth , __kScreenWidth);
    lockView.backgroundColor = [UIColor clearColor];
    lockView.center = self.view.center;
    [self.view addSubview:lockView];
}


@end
