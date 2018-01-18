//
//  AnychatLoginVC.h
//  0803
//
//  Created by dqh on 2017/12/6.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "RootViewController.h"
#import "AnyChatPlatform.h"


@interface AnychatLoginVC : RootViewController
@property (nonatomic, strong) AnyChatPlatform *anyChat;
@property (assign, nonatomic) int remoteUserId;                 //坐席客服id
@property (assign, nonatomic) int customerId;                   //客户id


@end
