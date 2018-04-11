//
//  JSImageManager.m
//  0803
//
//  Created by dqh on 2017/11/20.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "JSImageManager.h"


@interface JSImageManager()
@property (nonatomic, strong) PHImageManager *imageManager;
@end

@implementation JSImageManager

CGSize const JSImageManagerHeadImageSize = {60., 80.};


+ (instancetype)shareManager
{
    static JSImageManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[super allocWithZone:NULL] init];
            manager.allowMorePhotoes = YES;
        }
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self shareManager];
}

- (BOOL)authorizationStatus
{
    NSInteger status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusAuthorized) {
        return YES;
    } else {
        return NO;
    }
}

- (void)getAllAlbumsContainVideo:(BOOL)containVideo completionHnader:(void(^)(NSArray<JSAlbumMode *> *albumsArray))completionHander
{
    //用户的 iCloud 照片流
    PHFetchResult<PHAssetCollection *> *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
    //列出所有用户创建的相册
    PHFetchResult<PHCollection *> *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    //
    PHFetchResult<PHAssetCollection *> *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    //用户使用 iCloud 共享的相册
    PHFetchResult<PHAssetCollection *> *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
    //智能相册
    PHFetchResult<PHAssetCollection *> *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    NSArray *allAlbums = @[myPhotoStreamAlbum, smartAlbums, topLevelUserCollections, syncedAlbums, sharedAlbums];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    NSMutableArray *ttf = @[].mutableCopy;
    
    for (PHFetchResult *fetchResult in allAlbums) {
        
        for (PHAssetCollection *collection in fetchResult) {
            // 有可能是PHCollectionList类的的对象，过滤掉
            if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
            
            PHFetchResult<PHAsset *> *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            // 过滤无照片的相册
            if (fetchResult.count < 1) continue;
            
            NSString *albumTitle = collection.localizedTitle;
            if ([albumTitle isEqualToString:@"Camera Roll"] || [albumTitle isEqualToString:@"相机胶卷"] || [albumTitle isEqualToString:@"所有照片"] || [albumTitle isEqualToString:@"All Photos"]) {
                [ttf insertObject:[self jsp_modelWithName:albumTitle result:fetchResult] atIndex:0];
            } else {
                [ttf addObject:[self jsp_modelWithName:albumTitle result:fetchResult]];
            }
        }
    }
    
    if (completionHander) {
        completionHander(ttf.copy);
    }
}

- (JSAlbumMode *)jsp_modelWithName:(NSString *)albumName result:(PHFetchResult *)result
{
    JSAlbumMode *mode = [JSAlbumMode new];
    mode.title = albumName;
    mode.result = result;
    mode.count = result.count;

    return mode;
}

- (void)getAlbumFirstImage:(JSAlbumMode *)mode completionHnader:(void(^)(UIImage *firstImage))completionHnader
{
    PHAsset *lastAsset = mode.result.lastObject;
    
    [self getPhotoWithAsset:lastAsset
                       size:JSImageManagerHeadImageSize
                contentMode:PHImageContentModeAspectFill
                 resizeMode:PHImageRequestOptionsResizeModeExact
                synchronous:YES
           completionHnader:^(UIImage *photo, NSDictionary *info) {
               
               if (mode.result.count > 90) {
                   NSLog(@"ttt");
               }
               
               if (photo) {
                   completionHnader(photo);
               }
    } progressHnader:nil];
}

- (PHImageRequestID)getPhotoWithAsset:( PHAsset *)asset
                                 size:(CGSize)size
                          contentMode:(PHImageContentMode)contentMode
                           resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
                          synchronous:(BOOL)synchronous
                     completionHnader:(void(^)(UIImage *photo, NSDictionary *info))completionHnader
                       progressHnader:(void(^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHnader
{
    if (![asset isKindOfClass:[PHAsset class]]) return PHInvalidImageRequestID;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
        if (progressHnader) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progressHnader(progress, error, stop, info);
            });
        }
    };
    options.networkAccessAllowed = YES;
    options.resizeMode = resizeMode;
    options.synchronous = synchronous;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;

     PHImageRequestID imageRequestId =  [self.imageManager requestImageForAsset:asset
                                                                     targetSize:size
                                                                    contentMode:contentMode
                                                                        options:options
                                                                  resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                                      
//                                                                      BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                                                                      
                                                                      if (result) {
                                                                          if (completionHnader) {
                                                                              completionHnader(result, info);
                                                                          }
                                                                      }
                                        }];
    return imageRequestId;
}

- (PHImageManager *)imageManager
{
    if (_imageManager == nil) {
        _imageManager = [PHImageManager defaultManager];
    }
    return _imageManager;
}

@end

@implementation JSAlbumMode
@end
