//
//  Business.h
//  0803
//
//  Created by dqh on 2017/12/12.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject
@property(nonatomic, assign)long long businessId;
@property(nonatomic, copy)NSString *title;


- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)businessWithDic:(NSDictionary *)dic;
@end
