//
//  BusinessHall.h
//  0803
//
//  Created by dqh on 2017/12/11.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessHall : NSObject

@property(nonatomic, assign)long long hallId;       //营业厅id号
@property(nonatomic, copy)NSString *title;          //标题
@property(nonatomic, copy)NSString *icon;           //图标

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (instancetype)businessHallWithDic:(NSDictionary *)dic;

@end
