//
//  AnychatBusinessListVC.m
//  0803
//
//  Created by dqh on 2017/12/6.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "AnychatBusinessListVC.h"
#import "Business.h"

#import "AnyChatPlatform.h"
#import "AnyChatDefine.h"
#import "AnyChatErrorCode.h"
#import "AnyChatObjectDefine.h"

@interface AnychatBusinessListVC ()
@property (nonatomic, copy) NSArray *businesses;
@end

@implementation AnychatBusinessListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self jsp_setUpBackButton];
    // Do any additional setup after loading the view.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"business";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    Business *business = self.businesses[indexPath.row];
    cell.textLabel.text =  business.title;
    int queueId = [self.businessListIdArray[indexPath.row] intValue];
    int queuePeopleCount = [AnyChatPlatform ObjectGetIntValue:ANYCHAT_OBJECT_TYPE_QUEUE :queueId :ANYCHAT_QUEUE_INFO_QUEUELENGTH];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"有%d人在排队",queuePeopleCount];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"正在连接中，请稍等...");
    // 进队列
    [AnyChatPlatform ObjectControl:ANYCHAT_OBJECT_TYPE_QUEUE :[self.businessListIdArray[indexPath.row] intValue] :ANYCHAT_QUEUE_CTRL_USERENTER :0 :0 :0 :0 :nil];
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

- (void)backAction:(UIButton *)sender
{
    // 退出营业厅
    [AnyChatPlatform ObjectControl:ANYCHAT_OBJECT_TYPE_AREA :self.businessHallId :ANYCHAT_AREA_CTRL_USERLEAVE :0 :0 :0 :0 :nil];
    [self.navigationController popViewControllerAnimated:YES];
}


// 懒加载
- (NSArray *)businesses {
    if (_businesses == nil) {
        NSMutableArray *businessesObjArr = [NSMutableArray array];
        for (NSString *businessId in self.businessListIdArray) {
            //获取队列名称
            NSString *businessName = [AnyChatPlatform ObjectGetStringValue:ANYCHAT_OBJECT_TYPE_QUEUE :[businessId intValue] :ANYCHAT_OBJECT_INFO_NAME];
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:businessName,@"title", businessId,@"id",nil];
            Business *business = [Business businessWithDic:dic];
            [businessesObjArr addObject:business];
        }
        _businesses = businessesObjArr;
    }
    
    return _businesses;
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
