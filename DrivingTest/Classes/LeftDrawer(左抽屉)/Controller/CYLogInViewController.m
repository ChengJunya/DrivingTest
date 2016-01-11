//
//  CYLogInViewController.m
//  驾考刷题
//
//  Created by 程俊亚 on 15/12/27.
//  Copyright © 2015年 john. All rights reserved.
//

#import "CYLogInViewController.h"
#import "MBProgressHUD+MJ.h"

//定义用户偏好设置的key 防止写错
#define rememberPwdKey @"rememberPwd"//记录密码
#define autoLoginKey @"autoLogin"//自动登录
#define accountKey @"account"//帐号
#define passwordKey @"password"

@interface CYLogInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
- (IBAction)loginBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *rememberPassword;
@property (weak, nonatomic) IBOutlet UISwitch *autoLoginSwitch;
@property (weak, nonatomic) IBOutlet UIButton *logInBtn;

@end

@implementation CYLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"navi_back" highImage:@"navi_back"];
    self.navigationItem.title = @"登陆";

    // 设置 “开关” 默认值
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.rememberPassword.on = [defaults boolForKey:rememberPwdKey];
    self.autoLoginSwitch.on = [defaults boolForKey:autoLoginKey];

    // 设置 帐号 和 密码 默认值
    self.phoneNum.text = [defaults objectForKey:accountKey];
    if (self.rememberPassword.isOn) {
        self.passWord.text = [defaults objectForKey:passwordKey];
    }

    //调用 文本变化 的方法
    [self textChange];

    // 如果 "自动登录" 勾选，让自动登录
    if (self.autoLoginSwitch.isOn) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loginBtnClick:nil];
        });
    }

}

//监听文本输入框变化
- (IBAction)textChange{
    NSLog(@"%s",__func__);

    self.logInBtn.enabled = (self.phoneNum.text.length != 0 && self.passWord.text.length != 0);
    //没有值，禁用登录按钮
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLayoutSubviews
{
    self.view.frame = CGRectMake(0, 64, __kScreenWidth, __kScreenHeight);
}



- (IBAction)loginBtnClick:(id)sender {

        //判断用户名密码是否正确定，只有正确的情况下，才能进行下一个界面
        NSString *account = self.phoneNum.text;
        NSString *password = self.passWord.text;

        //不添加toView参数，提示框是添加在window上
        [MBProgressHUD showMessage:@"正在登录中。。。"];

        //模拟登录有一个等待过程
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //登录完成 隐藏提示框
            [MBProgressHUD hideHUD];
            //[MBProgressHUD hideHUDForView:self.view];

            if ([account isEqualToString:@"123"] && [password isEqualToString:@"123"]) {
                //执行一个segue，就会进入segue所指的控制器
                [self dismissViewControllerAnimated:YES completion:nil];

                //保存用户帐和密码
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:account forKey:accountKey];
                //只有 "记住密码" 为开启的状态，才要保存
                if (self.rememberPassword.isOn) {
                    [defaults setObject:password forKey:passwordKey];
                }
                [defaults synchronize];
            }else{
                //给一个错误的提示
                [MBProgressHUD showError:@"帐号或者密码不正确"];
            }
        });
}


/**
 *  记录密码开关的值变化
 */
- (IBAction)rememberPwdSwitchChange {

    //如果记住密码 为 关闭状态，并且 自动登录为 开启的状态，此时，自动登录 应改为关闭
    if(self.rememberPassword.isOn == NO && self.autoLoginSwitch.isOn == YES){
        //self.autoLoginSwitch.on = NO;

        //添加动画
        [self.autoLoginSwitch setOn:NO animated:YES];
    }

    //保存开关数据
    [self saveSwitchToPreference];
}

/**
 *  自动登录开关的值变化
 */
- (IBAction)autoLoginSwitchChange {

    //如果 自动登录  为 开启状态 并且 记住密码为 关闭状态，些时，记住密码应改为开启
    if(self.autoLoginSwitch.isOn == YES  && self.rememberPassword.isOn == NO){
        [self.rememberPassword setOn:YES animated:YES];
    }
    [self saveSwitchToPreference];
}

/**
 *  保存开关数据 到 用户偏好设置
 */
-(void)saveSwitchToPreference{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.rememberPassword.isOn forKey:rememberPwdKey];
    [defaults setBool:self.autoLoginSwitch.isOn forKey:autoLoginKey];
    [defaults synchronize];
}
@end
