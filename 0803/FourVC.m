//
//  FourVC.m
//  0803
//
//  Created by dqh on 2018/1/31.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "FourVC.h"
#import "RDVTabBarController.h"

@interface FourVC ()

@end

@implementation FourVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.view.backgroundColor = [UIColor blueColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.rdv_tabBarController.tabBarHidden) {
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    }
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
