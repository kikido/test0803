//
//  JSPhotoBrowserVC.h
//  0803
//
//  Created by dqh on 2017/11/16.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "RootViewController.h"
#import <Photos/Photos.h>

@interface JSPhotoBrowserVC : RootViewController
- (instancetype)initWithAssets:(PHFetchResult *)assets currentIndex:(NSInteger)currentIndex;
@end
