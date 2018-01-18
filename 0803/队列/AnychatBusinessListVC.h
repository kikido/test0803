//
//  AnychatBusinessListVC.h
//  0803
//
//  Created by dqh on 2017/12/6.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnychatBusinessListVC : UITableViewController

@property(nonatomic, strong)NSArray *businessListIdArray;   //队列id数组
@property(nonatomic, assign)int businessHallId;                 //营业厅id
@end
