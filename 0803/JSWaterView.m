//
//  JSWaterView.m
//  0803
//
//  Created by dqh on 2017/12/13.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "JSWaterView.h"

@implementation JSWaterView

- (void)drawRect:(CGRect)rect {
    
    // 半径
    CGFloat rabius = 60;
    // 开始角
    CGFloat startAngle = 0;
    
    // 中心点
    CGPoint point = CGPointMake(100, 100);  // 中心店我手动写的,你看看怎么弄合适 自己在搞一下
    
    // 结束角
    CGFloat endAngle = 2*M_PI;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:rabius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path.CGPath;       // 添加路径 下面三个同理
    
    UIColor *yellow = [UIColor colorWithRed:255/255. green:235/255. blue:126/255. alpha:1.];
    layer.strokeColor = [UIColor clearColor].CGColor;
    layer.fillColor = yellow.CGColor;
    
    
    [self.layer addSublayer:layer];
    
}

@end
