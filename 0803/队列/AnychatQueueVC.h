//
//  AnychatQueueVC.h
//  0803
//
//  Created by dqh on 2017/12/6.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "RootViewController.h"

@interface AnychatQueueVC : RootViewController
@property(nonatomic, assign)int businessId;                             // 队列id
@property (weak, nonatomic) IBOutlet UILabel *queuUserSiteLabel;        // 队列用户位置
@property (weak, nonatomic) IBOutlet UILabel *queueUserCountLabel;      // 队列人数
@end
