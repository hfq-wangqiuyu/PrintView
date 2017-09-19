//
//  ViewController.m
//  PaintViewDemo
//
//  Created by qiuyu on 2017/9/18.
//  Copyright © 2017年 qiuyu wang. All rights reserved.
//

#import "ViewController.h"
#import "PaintView.h"

@interface ViewController ()
{
    PaintView *paintView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    float width=[[UIScreen mainScreen] bounds].size.width;
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 100, 20)];
    lab1.text = @"画布上边距";
    [self.view addSubview:lab1];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 49,width , 1)];
    line1.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line1];
    
    paintView=[[PaintView alloc]initWithFrame:CGRectMake(0, 50,width, 400)];
    [self.view addSubview:paintView];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(paintView.frame)+1, 100, 20)];
    lab2.text = @"画布下边距";
    [self.view addSubview:lab2];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(paintView.frame),width , 1)];
    line2.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line2];
    
    __block typeof(self)weakself = self;
    paintView.imgBlock = ^(UIImage *resultImg){
        [weakself snapImg:resultImg];
    };
    
    UIButton *cancleButton=[[UIButton alloc]initWithFrame:CGRectMake(60, [UIScreen mainScreen].bounds.size.height-100, 80, 40)];
    [cancleButton setBackgroundColor:[UIColor greenColor]];
    [cancleButton setTitle:@"撤销" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:cancleButton];
    
    UIButton *snapBtn=[[UIButton alloc]initWithFrame:CGRectMake(140, [UIScreen mainScreen].bounds.size.height-100, 80, 40)];
    [snapBtn setBackgroundColor:[UIColor blueColor]];
    [snapBtn setTitle:@"截图" forState:UIControlStateNormal];
    [snapBtn addTarget:self action:@selector(snapBtnClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:snapBtn];
}
- (void)cancel{
    [paintView cancelPrintMethod];
}
- (void)snapBtnClick{
    [paintView cutScreen];
}
//旋转保存到相册
-(void)snapImg:(UIImage *)viewImage{
//旋转90度
//    UIImage *resultImg = [self image:viewImage rotation:UIImageOrientationLeft];
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);  //保存到相册
}
//旋转90度
- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
