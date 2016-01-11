//
//  CYBarCodeViewController.m
//  驾考刷题
//
//  Created by 程俊亚 on 15/12/26.
//  Copyright © 2015年 john. All rights reserved.
//

#import "CYBarCodeViewController.h"
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD+MJ.h"
@interface CYBarCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)creatCode:(id)sender;
- (IBAction)watchCode:(id)sender;

@property (nonatomic, weak) AVCaptureVideoPreviewLayer *layer;
@property (weak, nonatomic) IBOutlet UITextField *textField;


/** 捕捉会话 */
@property (nonatomic, weak) AVCaptureSession *session;

@end

@implementation CYBarCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)creatCode:(id)sender {
    // 1.创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];

    // 2.设置相关的信息
    [filter setDefaults];
    // 3.设置二维码的数据
    NSString *dataString = self.textField.text;
    NSString *regex = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:dataString];
    if (isValid) {
        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        // KVO 方式
        [filter setValue:data forKeyPath:@"inputMessage"];

        // 4.获取输出的图片
        CIImage *outputImage = [filter outputImage];

        // 5.设置到imageView上即可
        self.imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    }else{
        [MBProgressHUD showError:@"不是有效的网址"];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *dataString = textField.text;
    NSString *regex = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:dataString];
    if (!isValid) {
        [MBProgressHUD showError:@"不是有效的网址"];
    }
    self.textField.text = textField.text;
    [self.view endEditing:YES];
    return YES;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));

    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (IBAction)watchCode:(id)sender {
    // 1.创建捕捉会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];

    // 2.给会话设置输入源(input)
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [session addInput:input];

    // 3.给会话设置输出接口
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];

    // 4.添加预览图层
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
    self.layer = layer;

    // 5.开始扫描
    [session startRunning];
    self.session = session;
}

- (void)keyboardFrameWillChanged:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardF.origin.y;

    CGFloat transformValue = keyboardY - self.view.frame.size.height;
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformValue);

    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 实现AVCaptureMetadataOutput代理方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];

    if (object) {
        NSLog(@"%@", object.stringValue);
        NSString *regex = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isValid = [predicate evaluateWithObject:object.stringValue];
        if (isValid) {
            NSURL *url = [NSURL URLWithString:object.stringValue];
            [[UIApplication sharedApplication] openURL:url];
        }else{
            [MBProgressHUD showMessage:@"暂不支持解析该二维码"];
            [MBProgressHUD hideHUD];
        }

        // 去掉预览图层
        [self.layer removeFromSuperlayer];

        // 停止扫描
        [self.session stopRunning];
    }
}
@end
