//
//  SystemPhotoVC.h
//  0803
//
//  Created by dqh on 2017/11/15.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "RootViewController.h"
#import <Photos/Photos.h>


@interface SystemPhotoVC : RootViewController
- (instancetype)initWithResults:(PHFetchResult *)result;
@end
