//
//  CYShakeViewController.m
//  驾考刷题
//
//  Created by 程俊亚 on 15/12/26.
//  Copyright © 2015年 john. All rights reserved.
//

#import "CYShakeViewController.h"
#import "MBProgressHUD+MJ.h"
@interface CYShakeViewController ()

@end

@implementation CYShakeViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"摇一摇";
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __kScreenWidth, __kScreenHeight)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"可以摇的呦";
    [self.view addSubview:label];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillAppear:animated];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - ShakeToEdit 摇动手机之后的回调方法

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    if (motion == UIEventSubtypeMotionShake)

    {
        [MBProgressHUD showSuccess:@"检测到摇动"];
    }
}

//- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
//
//{
//    [MBProgressHUD showMessage:@"摇动取消"];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUD];
//    });
//}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    //摇动结束
    if (event.subtype == UIEventSubtypeMotionShake) {
        [MBProgressHUD showSuccess:@"摇动结束"];
    }
}
@end
