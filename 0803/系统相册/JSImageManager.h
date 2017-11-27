//
//  JSImageManager.h
//  0803
//
//  Created by dqh on 2017/11/20.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@class JSAlbumMode;

@interface JSImageManager : NSObject

//当做头像时的大小
extern CGSize const JSImageManagerHeadImageSize;

+ (instancetype)shareManager;

- (BOOL)authorizationStatus;


/**
 拿到所有的相册

 @param containVideo 是否包含视频
 @param completionHander block
 */
- (void)getAllAlbumsContainVideo:(BOOL)containVideo completionHnader:(void(^)(NSArray<JSAlbumMode *> *albumsArray))completionHander;

/**
 拿到相册最新的一张照片

 @param mode mode
 @param completionHnader block
 */
- (void)getAlbumFirstImage:(JSAlbumMode *)mode completionHnader:(void(^)(UIImage *firstImage))completionHnader;


/**
 根据phasset拿到图片资源

 @param asset asset
 @param size 需要图片的大小
 @param resizeMode sizemode
 @param completionHnader block
 @param progressHnader 进度block
 @return 图片的标识id
 */
- (PHImageRequestID)getPhotoWithAsset:( PHAsset *)asset
                                 size:(CGSize)size
                          contentMode:(PHImageContentMode)contentMode
                           resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
                          synchronous:(BOOL)synchronous
                     completionHnader:(void(^)(UIImage *photo, NSDictionary *info))completionHnader
                       progressHnader:(void(^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHnader;
@end

@interface JSAlbumMode : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) PHFetchResult *result;
//@property (nonatomic, copy, readonly) NSString *title;

@end
