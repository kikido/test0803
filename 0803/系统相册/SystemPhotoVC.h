//
//  SystemPhotoVC.h
//  0803
//
//  Created by dqh on 2017/11/15.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "RootViewController.h"
#import <Photos/Photos.h>

@class SystemPhotoVC;

@protocol JSImagePiclerControllerDelegate<NSObject>
@optional
- (void)imagePickerController:(SystemPhotoVC *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;
- (void)imagePickerControllerDidCancel:(SystemPhotoVC *)picker;
@end

@interface SystemPhotoVC : RootViewController
@property (nonatomic, weak) id<JSImagePiclerControllerDelegate> delegate;

- (instancetype)initWithResults:(PHFetchResult *)result;

- (void)finishPickImage;
@end
