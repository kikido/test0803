//
//  ThreeVC.m
//  0803
//
//  Created by dqh on 17/8/28.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "ThreeVC.h"
#import "FourVC.h"
#import "RDVTabBarController.h"


@interface ThreeVC ()

@end

@implementation ThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(aa:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.rdv_tabBarController.tabBarHidden) {
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    }
}

- (void)aa:(UIButton *)sender
{
    FourVC *vc = [[FourVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
