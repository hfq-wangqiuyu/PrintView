//
//  PaintView.m
//  UIDay4_Paint
//
//  Created by lanou3g on 15/4/27.
//  Copyright (c) 2015年 张永涛. All rights reserved.
//

#import "PaintView.h"

@implementation PaintView

-(id)initWithFrame:(CGRect)frame
{
    
    if ([super initWithFrame:frame]) {
        self.backgroundColor=[UIColor clearColor];
        color=[UIColor blackColor];
        //初始化字arry
        ziArry=[[NSMutableArray alloc]init];
        font=5;
        
//        float width=[[UIScreen mainScreen] bounds].size.width;
//        cancleButton=[[UIButton alloc]initWithFrame:CGRectMake(60, [UIScreen mainScreen].bounds.size.height-100, (width-120)/2, 40)];
//        [cancleButton setBackgroundColor:[UIColor orangeColor]];
//        [cancleButton setTitle:@"撤销" forState:UIControlStateNormal];
//        [cancleButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchDown];
//        [self addSubview:cancleButton];
//        
//        b2=[[UIButton alloc]initWithFrame:CGRectMake((width-120)/2+60, [UIScreen mainScreen].bounds.size.height-100, (width-120)/2, 40)];
//        [b2 setTitle:@"橡皮" forState:UIControlStateNormal];
//        [b2 setBackgroundColor:[UIColor cyanColor]];
//        [b2 addTarget:self action:@selector(Rubber) forControlEvents:UIControlEventTouchDown];
//        [self addSubview:b2];
        
    }
    
    return self;
}
//橡皮擦
-(void)Rubber
{
    color=[UIColor whiteColor];
    font=20;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //创建笔画的数组
    NSMutableArray *arry=[[NSMutableArray alloc]init];
    //将颜色添加到笔画数组中
    [arry addObject:color];
    [arry addObject:[NSNumber numberWithInt:font]];
    //得到触摸对象
    UITouch *touch=[touches anyObject];
    //将触摸对象装化为触摸点
    CGPoint point=[touch locationInView:self];
    //将point转换为对象类型
    NSValue *pointValue=[NSValue valueWithCGPoint:point];
    //将得到的起点添加到数组里面
    [arry addObject:pointValue];
    //将笔画数组放在子数组里面
    [ziArry addObject:arry];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //得到触摸对象
    UITouch *touch=[touches anyObject];
    //将触摸对象装化为触摸点
    CGPoint point=[touch locationInView:self];
    //将point转换为对象类型
    NSValue *pointValue=[NSValue valueWithCGPoint:point];
    //通过ziarry取到笔画数组
    NSMutableArray *bihuaArry=[ziArry lastObject];
    //将对象point添加到笔画数组
    [bihuaArry addObject:pointValue];
    //视图重绘，不是准备工作，而是子绘画中使用
    [self setNeedsDisplay];
    
    if (ziArry.count>0) {
        if(self.clickTapBlock){
            self.clickTapBlock(YES);
        }
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}


-(void)cancelPrintMethod
{
//    [ziArry removeObject:[ziArry lastObject]];
    [ziArry removeAllObjects];
    [self setNeedsDisplay];
    
    if(self.clickTapBlock){
        self.clickTapBlock(NO);
    }
}
//截图
-(void)cutScreen{
    //1、获得图片的画布（上下文）
    //2、画布的上下文
    //3、设置截图的参数 截图
    //4、关闭图片的上下文
    //5、保存
    UIGraphicsBeginImageContext(self.frame.size);
    /**
     *  size ：图片尺寸
     * opaque: 是否不透明
     * scale :比例
     */
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 1);
    //    [self addRound];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:ctx];
    
    //开始截图
    UIImage *image =   UIGraphicsGetImageFromCurrentImageContext();
    //关闭截图上下文
    UIGraphicsEndImageContext();
    
    NSData* imageData =  UIImagePNGRepresentation(image);
    UIImage* pngImage = [UIImage imageWithData:imageData];
    
    if (self.imgBlock) {
        self.imgBlock(pngImage);
    }
//    UIImageWriteToSavedPhotosAlbum(pngImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
}
- (void)drawRect:(CGRect)rect
{
    //循环一个字有多少笔画
    for (int i=0; i<[ziArry count]; i++) {
        NSMutableArray *bihua=[ziArry objectAtIndex:i];
        //设置绘画属性、
        //拿到画笔
        contex=UIGraphicsGetCurrentContext();
        //设置画笔的粗细
        CGContextSetLineWidth(contex, [bihua[1] intValue]);
        //设置画笔的颜色
        CGContextSetStrokeColorWithColor(contex, [bihua[0] CGColor]);
        //内层循环是用来处理每个笔画有多少个点
        for (int j=2; j<[bihua count]-2; j++) {
            //将点连成线
            //将对象类型的点从数组中取出来
            NSValue *pointValue=[bihua objectAtIndex:j];
            //将对象类型转换成point
            CGPoint first=[pointValue CGPointValue];
            //两点画线，取到后面的一个点
            CGPoint second=[[bihua objectAtIndex:j+1] CGPointValue];
            //设定线的起点和终点
            CGContextMoveToPoint(contex, first.x, first.y);
            //用点连接成线
            CGContextAddLineToPoint(contex, second.x, second.y);
            //提交画笔
            CGContextStrokePath(contex);
            
        }
    }
}
@end
