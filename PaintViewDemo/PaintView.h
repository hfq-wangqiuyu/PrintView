//
//  PaintView.h
//  UIDay4_Paint
//
//  Created by lanou3g on 15/4/27.
//  Copyright (c) 2015年 张永涛. All rights reserved.
//

#import <UIKit/UIKit.h>
//是否可点击的判断
typedef void (^clickBlock)(BOOL isCanClick);

typedef void (^imageBloc)(UIImage  *resultImg);

@interface PaintView : UIView
{
    int font;
    UIButton *b1;
    UIButton *b2;
    CGContextRef contex;
    
    NSMutableArray *ziArry;//字arry
    UIColor *color;//记录每个笔画的颜色
}
- (void)cancelPrintMethod;
- (void)cutScreen;

@property(nonatomic,strong)imageBloc imgBlock;

@property(copy,nonatomic)clickBlock clickTapBlock;//块

@end
