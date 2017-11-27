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
    
   
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 120., 60.)];
    [btn setImage:[UIImage imageNamed:@"dqh_add"] forState:UIControlStateNormal];
    [btn setTitle:@"测试01" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor yellowColor];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:15.];
    btn.imageView.backgroundColor = btn.backgroundColor;
    
    CGSize titleSize = btn.titleLabel.bounds.size;
    CGSize imageSize = btn.imageView.bounds.size;
    CGFloat interval = 1.0;

    [btn setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + interval, -(imageSize.width + interval), 0, 0)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleSize.height + interval, -(titleSize.width + interval))];
    
    [self.view addSubview:btn];
}

- (void)testNet
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.kikido.upload01"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:<#(nonnull NSURLRequest *)#> fromData:<#(nullable NSData *)#> completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        <#code#>
    }]
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
