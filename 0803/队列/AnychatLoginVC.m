//
//  AnychatLoginVC.m
//  0803
//
//  Created by dqh on 2017/12/6.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "AnychatLoginVC.h"
#import "AnyChatDefine.h"
#import "AnyChatObjectDefine.h"
#import "AnychatHallVC.h"
#import "AnychatBusinessListVC.h"
#import "AnychatQueueVC.h"

#import "BusinessHall.h"

static const NSString *server = @"demo.anychat.cn";
static const NSString *port = @"8906";
static const NSString *username = @"ceshi1211";


@interface AnychatLoginVC () <AnyChatNotifyMessageDelegate,AnyChatObjectEventDelegate>

@property (nonatomic, assign) NSInteger selfUserId;
@property (nonatomic, strong) NSMutableArray *businessHallDicArr;//字典数组 【dic】
@property (nonatomic, copy) NSArray *businessHallObjArr;//模型数组【mode】
@property (nonatomic, assign) NSInteger waitingBusinessId;//队列id

@end

@implementation AnychatLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAnychat];
    [self jsp_createUI];
    
    // Do any additional setup after loading the view.
}

- (void)setupAnychat
{
    [AnyChatPlatform InitSDK:0];
    
    // 2.设置AnyChat的通知监听
    // 功能:运用通知中心机制,实现监听“连接服务器、用户登录、进入房间、与服务器网络连接”等事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AnyChatNotifyHandler:) name:@"ANYCHATNOTIFY" object:nil];
    
    //3.初始化sdk的核心类对象 AnyChatPlatform
    self.anyChat = [AnyChatPlatform getInstance];
    
    //4.设置通知代理
    self.anyChat.notifyMsgDelegate = self;
    self.anyChat.objectDelegate = self;
}

#pragma mark - NSNotification Method
//消息观察者方法
- (void)AnyChatNotifyHandler:(NSNotification*)notify
{
    NSDictionary* dict = notify.userInfo;
    [self.anyChat OnRecvAnyChatNotify:dict];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ANYCHATNOTIFY" object:nil];
}

- (void)jsp_createUI
{
    UIButton *abutton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100., 40., 40.)];
    abutton.backgroundColor = [UIColor blackColor];
    [abutton setTitle:@"ss" forState:UIControlStateNormal];
    [abutton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [abutton addTarget:self action:@selector(bbbbb:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:abutton];
}

- (void)bbbbb:(UIButton *)sender
{
    NSLog(@"正在登录...");
    
    [AnyChatPlatform Connect:server : [port intValue]];
    [AnyChatPlatform Login:username :nil];
}

// 初始化本地对象信息
- (void)InitClientObjectInfo:(int)mSelfUserId :(int)dwAgentFlags {
    // 业务对象身份初始化
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_OBJECT_INITFLAGS : dwAgentFlags]; // 0 普通用户 2 坐席
    // 客户端用户对象优先级
    [AnyChatPlatform ObjectSetIntValue:ANYCHAT_OBJECT_TYPE_CLIENTUSER :mSelfUserId :ANYCHAT_OBJECT_INFO_PRIORITY :10];
    
    //坐席  开启自动路由
    if(dwAgentFlags == ANYCHAT_OBJECT_FLAGS_AGENT+ANYCHAT_OBJECT_FLAGS_AUTOMODE){
        
        int attribute = 0;
//        if(self.cash.isChecked){
//
//            attribute = attribute + 1;
//        }
//        if(self.manage.isChecked){
//
//            attribute = attribute + 2;
//        }
//        if(self.loan.isChecked){
//
//            attribute = attribute + 4;
//        }
//
        [AnyChatPlatform ObjectSetIntValue:ANYCHAT_OBJECT_TYPE_CLIENTUSER :mSelfUserId :ANYCHAT_OBJECT_INFO_ATTRIBUTE :10];
    }
    else{
        
        [AnyChatPlatform ObjectSetIntValue:ANYCHAT_OBJECT_TYPE_CLIENTUSER :mSelfUserId :ANYCHAT_OBJECT_INFO_ATTRIBUTE :-1];
    }
    
    // 向服务器发送数据同步请求指令
    [AnyChatPlatform ObjectControl: ANYCHAT_OBJECT_TYPE_AREA :ANYCHAT_INVALID_OBJECT_ID :ANYCHAT_OBJECT_CTRL_SYNCDATA :mSelfUserId :0 :0 :0 :nil];
}

#pragma mark - AnyChat Delegate
// 连接服务器消息
- (void) OnAnyChatConnect:(BOOL) bSuccess {
    if (bSuccess) {
    }else {
        NSLog(@"连接服务器失败");
    }
}

// 用户登陆消息
- (void) OnAnyChatLogin:(int) dwUserId : (int) dwErrorCode {
    if (dwErrorCode == 0) {
        self.businessHallDicArr = nil;
        self.selfUserId = dwUserId;
        // 初始化本地对象信息
        [self InitClientObjectInfo:dwUserId :0];
    }else {
        NSLog(@"登录失败");
    }
}

// 用户进入房间消息
- (void) OnAnyChatEnterRoom:(int) dwRoomId : (int) dwErrorCode {
    NSLog(@"用户进入房间");
//    if (dwErrorCode == 0) {
//        VideoViewController *videoVC = [[VideoViewController alloc] init];
//        if ([self.role.text isEqualToString:@"普通用户"]) {
//            videoVC.remoteUserId = self.remoteUserId;
//        }else if([self.role.text isEqualToString:@"坐席"]) {
//            videoVC.remoteUserId = self.customerId;
//        }
//        [self.navigationController pushViewController:videoVC animated:YES];
//        _videoViewController=videoVC;
//    }
}

// 房间在线用户消息
- (void) OnAnyChatOnlineUser:(int) dwUserNum : (int) dwRoomId {
//    [self.videoViewController openRemoteView];
}
// 用户进入房间消息
- (void) OnAnyChatUserEnterRoom:(int) dwUserId {
//    if (dwUserId == self.videoViewController.remoteUserId) {
//        [self.videoViewController openRemoteView];
//    }
}
// 用户退出房间消息
- (void) OnAnyChatUserLeaveRoom:(int) dwUserId {}
// 网络断开消息
- (void) OnAnyChatLinkClose:(int) dwErrorCode {
    NSLog(@"网络断开");
    // 注销系统
    [AnyChatPlatform Logout];
//    [MBProgressHUD hideHUD];
//    [MBProgressHUD showError:@"网络断线，请稍后再试"];
//    self.businessHallDicArr = nil;
    self.selfUserId = -1;
//    self.customerId = 0;
//    self.remoteUserId = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - AnyChatObjectEventDelegate
- (void) OnAnyChatObjectEventCallBack: (int) dwObjectType : (int) dwObjectId : (int) dwEventType : (int) dwParam1 : (int) dwParam2 : (int) dwParam3 : (int) dwParam4 : (NSString*) lpStrParam {
    switch (dwEventType) {
        case ANYCHAT_OBJECT_EVENT_UPDATE:// 1.对象数据更新
            [self AnyChatObjectUpdate:dwObjectType :dwObjectId];
            break;
        case ANYCHAT_OBJECT_EVENT_SYNCDATAFINISH:// 2.对象数据同步结束
            [self AnyChatObjectSynDataFinish:dwObjectType];
            break;
            
        case ANYCHAT_AREA_EVENT_USERENTER:// 3.用户进入服务区域
            [self AnyChatUserEnterArea:dwObjectType :dwObjectId :dwParam1 :dwParam2 :dwParam3 :dwParam4];
            break;
        case ANYCHAT_AREA_EVENT_ENTERRESULT:// 4.进入服务区域结果
            [self AnyChatEnterAreaResult:dwObjectType :dwObjectId :dwParam1];
            break;
        case ANYCHAT_AREA_EVENT_USERLEAVE:// 5.用户离开服务区域
            [self AnyChatUserLeaveArea:dwObjectType :dwObjectId :dwParam1 :dwParam2];
            break;
        case ANYCHAT_AREA_EVENT_LEAVERESULT:// 6.离开服务区域结果
            [self AnyChatLeaveAreaResult:dwObjectType :dwObjectId :dwParam1];
            break;
        case ANYCHAT_AREA_EVENT_STATUSCHANGE:// 7.服务区域状态变化
            [self AnyChatAreaStatusChanged:dwObjectType :dwObjectId];
            break;
            
        case ANYCHAT_QUEUE_EVENT_USERENTER:// 8.进入队列
            [self AnyChatUserEnterQueue:dwObjectType :dwObjectId :dwParam1];
            break;
        case ANYCHAT_QUEUE_EVENT_ENTERRESULT:// 9.用户进入队列结果
            [self AnyChatEnterQueueResult:dwObjectType :dwObjectId :dwParam1];
            break;
        case ANYCHAT_QUEUE_EVENT_USERLEAVE:// 10.用户离开队列
            [self AnyChatUserLeaveQueue:dwObjectType :dwObjectId :dwParam1];
            break;
        case ANYCHAT_QUEUE_EVENT_LEAVERESULT:// 11.用户离开队列结果
            [self AnyChatLeaveQueueResult:dwObjectType :dwObjectId :dwParam1];
            break;
        case ANYCHAT_QUEUE_EVENT_STATUSCHANGE:// 12.队列状态变化
            [self AnyChatQueueStatusChanged:dwObjectType :dwObjectId];
            break;
//
//        case ANYCHAT_AGENT_EVENT_STATUSCHANGE:// 13.坐席状态变化
//            [self AnyChatAgentStatusChanged:dwObjectType :dwObjectId];
//            break;
//        case ANYCHAT_AGENT_EVENT_SERVICENOTIFY:// 14.坐席服务通知（哪个用户到哪个客服办理业务）
//            [self AnyChatAgentServiceNotify:dwParam1 :dwParam2];
//            break;
//        case ANYCHAT_AGENT_EVENT_WAITINGUSER:// 15.暂时没有客户，请等待
//            [self AnyChatAgentWaitingUser:dwObjectType];
//            break;
//
        default:
            break;
    }
}

// 1.对象数据更新(进和出都会触发)
-(void) AnyChatObjectUpdate:(int)dwObjectType :(int)dwObjectId {
    NSLog(@"对象数据更新事件");
    if(dwObjectType == ANYCHAT_OBJECT_TYPE_AREA) {
        // 获取营业厅名称
        NSString *areaName = [AnyChatPlatform ObjectGetStringValue:dwObjectType :dwObjectId :ANYCHAT_OBJECT_INFO_NAME];
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:areaName,@"areaName",[NSString stringWithFormat:@"%d",dwObjectId],@"areaId", nil];
        
        [self.businessHallDicArr addObject:dic];
        
        NSLog(@"服务区域");
    }else if(dwObjectType == ANYCHAT_OBJECT_TYPE_QUEUE) {
        NSLog(@"队列");
    }
    
}

// 2.对象数据同步结束
-(void)AnyChatObjectSynDataFinish:(int)dwObjectType {
    NSLog(@"对象数据同步结束");
    if(dwObjectType == ANYCHAT_OBJECT_TYPE_AREA) { //营业厅
        // 跳转到营业厅
        AnychatHallVC *businessHallVC = [[AnychatHallVC alloc] init];
        businessHallVC.businessHallObjectArr = self.businessHallObjArr;
        
        self.businessHallDicArr = nil;
        [self.navigationController pushViewController:businessHallVC animated:YES];
        
        NSLog(@"服务区域");
    }
}


// 3.用户进入服务区域
-(void) AnyChatUserEnterArea:(int)dwObjectType :(int)dwObjectId :(int)dwUserId :(int)dwFlags :(int)dwAttribute :(int)dwPriority {
    NSLog(@"用户进入服务区域");
}


// 4.进入服务区域结果
-(void) AnyChatEnterAreaResult:(int)dwObjectType :(int)dwObjectId :(int)dwErrorCode {
    if(dwErrorCode == 0) {
        NSLog(@"进入服务区域成功");
        
        NSMutableArray *queuesArray= [AnyChatPlatform ObjectGetIdList:ANYCHAT_OBJECT_TYPE_QUEUE];
        
        // 界面跳转
        if (YES) {
            AnychatBusinessListVC *businessListVC = [[AnychatBusinessListVC alloc] init];
            businessListVC.businessListIdArray = queuesArray;
            businessListVC.businessHallId = dwObjectId;
            [self.navigationController pushViewController:businessListVC animated:YES];
        }
        
    }else {
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showError:@"进入服务区域失败"];
    }
}

// 5.用户离开服务区域
-(void) AnyChatUserLeaveArea:(int)dwObjectType :(int)dwObjectId :(int)dwUserId :(int)dwErrorCode {
    NSLog(@"用户离开服务区域");
}

// 6.离开服务区域结果
-(void) AnyChatLeaveAreaResult:(int)dwObjectType :(int)dwObjectId :(int)dwErrorCode {
    
    //移除营业厅中的字典
    if (dwErrorCode == 0) {
        NSLog(@"离开服务区域成功");
        for (NSDictionary *dic in self.businessHallDicArr) {
            NSString *areaId = [dic objectForKey:@"areaId"];
            if ([areaId intValue] == dwObjectId) {
                [self.businessHallDicArr removeObject:dic];
            }
        }
    }
}

// 7.服务区域状态变化
- (void) AnyChatAreaStatusChanged:(int)dwObjectType :(int)dwObjectId {
    NSLog(@"服务区域状态变化");
}

// 8.用户进入队列
-(void) AnyChatUserEnterQueue:(int)dwObjectType :(int)dwObjectId :(int)dwUserId {
    NSLog(@"用户进入队列");
    int controllersCount = (int)self.navigationController.viewControllers.count;
    if(controllersCount == 4){
//        [self updateQueueUserCountLabel:dwObjectId];
        int queueUserNum = [AnyChatPlatform ObjectGetIntValue:ANYCHAT_OBJECT_TYPE_QUEUE :dwObjectId :ANYCHAT_QUEUE_INFO_QUEUELENGTH];
        NSLog(@"%@,",[NSString stringWithFormat:@"当前排队人数共:%d人",queueUserNum]);
        int queuUserSite = [AnyChatPlatform ObjectGetIntValue:ANYCHAT_OBJECT_TYPE_QUEUE :dwObjectId :ANYCHAT_QUEUE_INFO_BEFOREUSERNUM] + 1;
        NSLog(@"%@",[NSString stringWithFormat:@"你现在排在第%d位",queuUserSite]);
    }
}

// 9.用户进入队列结果
-(void) AnyChatEnterQueueResult:(int)dwObjectType :(int)dwObjectId :(int)dwErrorCode {
    if(dwErrorCode == 0) {
        // 进入队列成功
        NSLog(@"用户进入队列成功");
//        [MBProgressHUD hideHUD];
        AnychatQueueVC *queueVC = [[AnychatQueueVC alloc] init];
        queueVC.businessId = dwObjectId;
        self.waitingBusinessId = dwObjectId;
        [self.navigationController pushViewController:queueVC animated:YES];
    }else {
        NSLog(@"error 用户进入队列失败");
//        [MBProgressHUD showError:@"用户进入队列失败"];
    }
}

// 10.用户离开队列
-(void) AnyChatUserLeaveQueue:(int)dwObjectType :(int)dwObjectId :(int)dwUserId {
    NSLog(@"用户离开队列");
    int controllersCount = (int)self.navigationController.viewControllers.count;
    if(controllersCount == 4){
        [self updateQueueUserCountLabel:dwObjectId];
    }
}

// 11.用户离开队列结果
-(void) AnyChatLeaveQueueResult :(int)dwObjectType :(int)dwObjectId :(int)dwErrorCode {
    if (dwErrorCode == 0) {
        NSLog(@"用户离开队列成功");
    }
}

// 12.队列状态变化
-(void) AnyChatQueueStatusChanged:(int)dwObjectType :(int)dwObjectId {
    NSLog(@"队列状态变化");
    
    int controllersCount = (int)self.navigationController.viewControllers.count;
    if(controllersCount == 3 || controllersCount == 4){
        if ([self.navigationController.viewControllers[2] isKindOfClass:[AnychatBusinessListVC class]]) {
            AnychatBusinessListVC *businessListVC = self.navigationController.viewControllers[2];
            [businessListVC.tableView reloadData];
        }
    }
    if (controllersCount == 4) {
        if ([self.navigationController.viewControllers[3] isKindOfClass:[AnychatQueueVC class]]) {
            if (self.waitingBusinessId == dwObjectId) {
                [self updateQueueUserCountLabel:dwObjectId];
            }
        }
    }
}

// 更新排队人数Label
- (void)updateQueueUserCountLabel:(int)queueId {
    int navNum = (int)self.navigationController.viewControllers.count;
    if (navNum==4) {
        AnychatQueueVC *queueVC = [self.navigationController.viewControllers objectAtIndex:3];
        int queueUserNum = [AnyChatPlatform ObjectGetIntValue:ANYCHAT_OBJECT_TYPE_QUEUE :queueId :ANYCHAT_QUEUE_INFO_QUEUELENGTH];
        queueVC.queueUserCountLabel.text = [NSString stringWithFormat:@"当前排队人数共:%d人",queueUserNum];
        
        int queuUserSite = [AnyChatPlatform ObjectGetIntValue:ANYCHAT_OBJECT_TYPE_QUEUE :queueId :ANYCHAT_QUEUE_INFO_BEFOREUSERNUM] + 1;
        //        if (beforeNum < 0) beforeNum = 0;
        queueVC.queuUserSiteLabel.text = [NSString stringWithFormat:@"你现在排在第%d位",queuUserSite];
        
    }
}


- (NSMutableArray *)businessHallDicArr {
    
    if (_businessHallDicArr == nil) {
        NSMutableArray *businessHallDicArray = [NSMutableArray array];
        _businessHallDicArr = businessHallDicArray;
    }
    return _businessHallDicArr;
}

- (NSArray *)businessHallObjArr {
    if (_businessHallObjArr == nil) {
        _businessHallObjArr = [NSMutableArray array];
    }
    //将字典转成模型
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in self.businessHallDicArr) {
        
        BusinessHall *bhall = [BusinessHall businessHallWithDic:dic];
        
        [arr addObject:bhall];
    }
    _businessHallObjArr = arr;
    return _businessHallObjArr;
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
