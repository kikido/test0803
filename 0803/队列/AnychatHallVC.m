//
//  AnychatHallVC.m
//  0803
//
//  Created by dqh on 2017/12/6.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "AnychatHallVC.h"
#import "BusinessHall.h"

#import "AnyChatPlatform.h"
#import "AnyChatDefine.h"
#import "AnyChatErrorCode.h"
#import "AnyChatObjectDefine.h"

@interface AnychatHallVC ()

@end

@implementation AnychatHallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 60.;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self jsp_setUpBackButton];
    // Do any additional setup after loading the view.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.businessHallObjectArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessHall *mode = self.businessHallObjectArr[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = mode.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"正在连接中。。。");
    
    BusinessHall *mode = self.businessHallObjectArr[indexPath.row];
    // 进营业厅
    [AnyChatPlatform ObjectControl:ANYCHAT_OBJECT_TYPE_AREA :(int)mode.hallId :ANYCHAT_AREA_CTRL_USERENTER :0 :0 :0 :0 :nil];
}


- (void)jsp_setUpBackButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 17, 30)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    //    [backButton setBackgroundImage:[UIImage imageNamed:@"nav_back_hover"] forState:UIControlStateHighlighted];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)backAction:(UIControlEvents *)event {
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"您确定退出排队系统吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    actionSheet.delegate = self;
//    [actionSheet showInView:self.view];
    NSLog(@"您确定退出排队系统吗");
     [AnyChatPlatform Logout];
    [self.navigationController popViewControllerAnimated:YES];
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
