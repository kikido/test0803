//
//  AnychatQueueVC.m
//  0803
//
//  Created by dqh on 2017/12/6.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "AnychatQueueVC.h"
#import "AnychatLoginVC.h"

#import "AnyChatPlatform.h"
#import "AnyChatDefine.h"
#import "AnyChatErrorCode.h"
#import "AnyChatObjectDefine.h"

@interface AnychatQueueVC () <AnyChatVideoCallDelegate>
@property (nonatomic, weak) AnychatLoginVC *loginVC;
@property(strong, nonatomic) AnyChatPlatform *anyChat;                  //anyChat对象

@property(nonatomic, assign) NSInteger remoteUserId;                           //客服人员id号
@property(nonatomic, assign) NSInteger queueUserCount;                         //队列人数
@property(nonatomic, assign) NSInteger queueUserSite;                          //队列中用户位置

@property (nonatomic, strong) UILabel *queueWaitingTimeLabel;
@property(nonatomic, strong)  NSTimer *timer;                             //定时器
@end

@implementation AnychatQueueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.loginVC = [self.navigationController.viewControllers objectAtIndex:0];
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isMemberOfClass:[AnychatLoginVC class]]) {
            self.loginVC = (AnychatLoginVC *)vc;
        }
    }
    self.anyChat = self.loginVC.anyChat;
    self.anyChat.videoCallDelegate = self;
    
    self.queueUserSite = [AnyChatPlatform ObjectGetIntValue:ANYCHAT_OBJECT_TYPE_QUEUE :self.businessId :ANYCHAT_QUEUE_INFO_BEFOREUSERNUM] + 1;
    self.queueUserCount = [AnyChatPlatform ObjectGetIntValue:ANYCHAT_OBJECT_TYPE_QUEUE :self.businessId :ANYCHAT_QUEUE_INFO_QUEUELENGTH];
    
    NSString *businessName = [AnyChatPlatform ObjectGetStringValue:ANYCHAT_OBJECT_TYPE_QUEUE :(int)self.businessId :ANYCHAT_OBJECT_INFO_NAME];
    NSLog(@"%@",[NSString stringWithFormat:@"%@-排队等待中",businessName]);
    
    //
    UILabel *queuUserSiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 320, 50)];
    queuUserSiteLabel.textColor = [UIColor blackColor];
    queuUserSiteLabel.text = [NSString stringWithFormat:@"你现在排在第%d位",self.queueUserSite];
    [self.view addSubview:queuUserSiteLabel];
    self.queuUserSiteLabel = queuUserSiteLabel;
    
    UILabel *queueUserCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 320, 50)];
    queueUserCountLabel.textColor = [UIColor blackColor];
    queueUserCountLabel.text = [NSString stringWithFormat:@"当前排队人数共:%d人",self.queueUserCount];
    [self.view addSubview:queueUserCountLabel];
    self.queueUserCountLabel = queueUserCountLabel;
    
    //排队等待时间
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setWaitingTimeLabel) userInfo:nil repeats:YES];
    self.timer = timer;
    

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 防止锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setWaitingTimeLabel
{
    if (self.queueWaitingTimeLabel == nil) {
        UILabel *queueWaitingTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 320, 50)];
        queueWaitingTimeLabel.textColor = [UIColor blackColor];
        [self.view addSubview:queueWaitingTimeLabel];
        self.queueWaitingTimeLabel = queueWaitingTimeLabel;
    }
    
    int waitingTime = [AnyChatPlatform ObjectGetIntValue:ANYCHAT_OBJECT_TYPE_QUEUE :self.businessId :ANYCHAT_QUEUE_INFO_WAITTIMESECOND];
    NSString *timeLabelText = [NSString stringWithFormat:@"%d时 %d分 %d秒", waitingTime/(60*60), (waitingTime%(60*60))/60, waitingTime%60];
    self.queueWaitingTimeLabel.text = [NSString stringWithFormat:@"已等待时长 %@",timeLabelText];
}

#pragma mark - AnyChat Call Delegate
- (void) OnAnyChatVideoCallEventCallBack:(int) dwEventType : (int) dwUserId : (int) dwErrorCode : (int) dwFlags : (int) dwParam : (NSString*) lpUserStr{
    self.remoteUserId = dwUserId;
    self.loginVC.remoteUserId = dwUserId;
    switch (dwEventType) {
            
        case BRAC_VIDEOCALL_EVENT_REQUEST://呼叫请求 1
        {
//            NSString *serviceName = [AnyChatPlatform ObjectGetStringValue:ANYCHAT_OBJECT_TYPE_AGENT :dwUserId :ANYCHAT_OBJECT_INFO_NAME];
//            self.requestAlertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"客服 %@请求与您视频通话，是否接受?",serviceName] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"接受",@"拒绝" ,nil];
//            self.requestAlertView.delegate = self;
//            [self.requestAlertView show];
//
//            [self.theAudioPlayer play];
            NSLog(@"呼叫请求");
            
            break;
        }
            
        case BRAC_VIDEOCALL_EVENT_REPLY:// 呼叫请求回复 2
        {
            switch (dwErrorCode)
            {
                case GV_ERR_VIDEOCALL_CANCEL: // 源用户主动放弃会话
                {
//                    if (self.requestAlertView != nil) [self.requestAlertView dismissWithClickedButtonIndex:self.requestAlertView.cancelButtonIndex animated:YES];
//                    [MBProgressHUD showError:@"坐席取消会话"];
//                    [self.navigationController popViewControllerAnimated:YES];
                    NSLog(@"作息取消会话");
                    break;
                }
                    
                case GV_ERR_VIDEOCALL_TIMEOUT:// 会话请求超时
                {
//                    if (self.requestAlertView != nil) [self.requestAlertView dismissWithClickedButtonIndex:self.requestAlertView.cancelButtonIndex animated:YES];
//                    [MBProgressHUD showError:@"请求超时"];
//                    [self.navigationController popViewControllerAnimated:YES];
                    NSLog(@"会话超时");
                    break;
                }
                    
                case GV_ERR_VIDEOCALL_DISCONNECT:// 网络断线
                {
//                    [MBProgressHUD showError:@"网络断线"];
                    NSLog(@"网络断线");
                    break;
                }
                    
                    
                    
            }
            break;
        }
            
        case BRAC_VIDEOCALL_EVENT_START://视频呼叫会话开始事件 3
        {
            //进入房间
            [AnyChatPlatform EnterRoom:dwParam :nil];
            break;
        }
            
        case BRAC_VIDEOCALL_EVENT_FINISH://挂断（结束）呼叫会话 4
        {
            // 关闭设备
            [AnyChatPlatform UserSpeakControl: -1 : NO];
            [AnyChatPlatform UserCameraControl: -1 : NO];
            [AnyChatPlatform UserSpeakControl: dwUserId : NO];
            [AnyChatPlatform UserCameraControl: dwUserId : NO];
            // 离开房间
            [AnyChatPlatform LeaveRoom:-1];
//            [MBProgressHUD showSuccess:@"视频通话结束"];
            NSLog(@"视频通话结束");
            // 跳转
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            
            break;
        }
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
