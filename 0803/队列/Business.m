//
//  Business.m
//  0803
//
//  Created by dqh on 2017/12/12.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "Business.h"

@implementation Business
- (instancetype)initWithDic:(NSDictionary *)dic {
    
    self = [super init];
    if (self) {
        self.title = [dic objectForKey:@"title"];
        self.businessId = [[dic objectForKey:@"id"] longLongValue];
    }
    return self;
}

+ (instancetype)businessWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
