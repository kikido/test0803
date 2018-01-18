//
//  BusinessHall.m
//  0803
//
//  Created by dqh on 2017/12/11.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "BusinessHall.h"

@implementation BusinessHall

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self != nil) {
        self.hallId = [[dic objectForKey:@"areaId"] longLongValue];
        self.title = [dic objectForKey:@"areaName"];
        self.icon = [NSString stringWithFormat:@"stronghold_0%i",(arc4random()%4)+1];
    }
    return self;
}

+ (instancetype)businessHallWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}

@end
