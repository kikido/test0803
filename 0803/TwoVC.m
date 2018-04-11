//
//  TwoVC.m
//  0803
//
//  Created by dqh on 17/8/28.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "TwoVC.h"
#import "VideoTestViewController.h"

@interface TwoVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.superview ? nil : [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor greenColor];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(aaa) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)aaa
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.navigationController popViewControllerAnimated:YES];
//    });
//    
//    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"测试" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:0 handler:nil]];
//    [self presentViewController:alertC animated:YES completion:nil];
    VideoTestViewController *vc = [[VideoTestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 55.;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = @"sss";
    return cell;
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
