//
//  SystemPhotoVC.h
//  0803
//
//  Created by dqh on 2017/11/15.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "RootViewController.h"
#import <Photos/Photos.h>

@class JSPickerImageVC;

@protocol JSImagePickerControllerDelegate<NSObject>
@optional
- (void)imagePickerController:(JSPickerImageVC *)picker didFinishPickingWithMedia:(NSArray *)mediaArray;
- (void)imagePickerControllerDidCancel:(JSPickerImageVC *)picker;
@end

@interface JSPickerImageVC : RootViewController

- (instancetype)initWithResults:(PHFetchResult *)result delegate:(id<JSImagePickerControllerDelegate>)delegate;

- (void)finishPickImage;
@end
