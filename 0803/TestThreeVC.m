//
//  TestThreeVC.m
//  0803
//
//  Created by dqh on 2017/11/22.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "TestThreeVC.h"

@interface TestThreeVC () <NSURLSessionDelegate>

@end

@implementation TestThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    // Do any additional setup after loading the view.
}

- (void)creatUI
{
//    CGFloat lineWidth = 100;
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(100. + .5*lineWidth, 100.-3)];
//    [path addLineToPoint:CGPointMake(100., 100 + sin(M_PI/3.) * lineWidth)];
//    [path addLineToPoint:CGPointMake(100. - .5*lineWidth, 100.-3)];
//    [path addLineToPoint:CGPointMake(100. + .5*lineWidth, 100.)];
    
//    [path closePath];
//    path.lineWidth = 5.;
//    [path stroke];
//    [[UIColor yellowColor] setFill];
//    [[UIColor blackColor] setStroke];
    
//    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
//    shaperLayer.lineWidth = 3.;
//    shaperLayer.path = path.CGPath;
//    shaperLayer.strokeColor = [UIColor blackColor].CGColor;
//    shaperLayer.fillColor = [UIColor whiteColor].CGColor;
//    shaperLayer.backgroundColor = [UIColor redColor].CGColor;
//    [self.view.layer addSublayer:shaperLayer];
    
   
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 44.)];
////    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:[UIImage imageNamed:@"dqh_add"] forState:UIControlStateNormal];
//    [btn setTitle:@"离线上传" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn.backgroundColor = [UIColor yellowColor];
//
//    btn.titleLabel.font = [UIFont systemFontOfSize:7.];
//    btn.imageView.backgroundColor = btn.backgroundColor;
//
//    CGSize titleSize = btn.titleLabel.bounds.size;
//    CGSize imageSize = btn.imageView.bounds.size;
//    CGFloat interval = 1.0;
//
////    [btn setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + interval, -(imageSize.width + interval), 0, 0)];
////    [btn setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleSize.height + interval, -(titleSize.width + interval))];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    NSArray *aa = @[@1,@2,@3,@4,@5,@6];
    NSArray *bb = @[@1,@2,@3,@4,@5,@7];

    
    
    for (NSNumber *numberA in aa) {
        
        BOOL isSame = NO;
        for (NSNumber *numberB in bb) {
            if ([numberA integerValue] == [numberB integerValue]) {
                NSLog(@"%@相同，已删除",numberA);
                isSame = YES;
                continue;
            }
            break;
        }
    }
    

}

- (void)testNet
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
