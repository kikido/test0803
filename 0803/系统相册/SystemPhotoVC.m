//
//  SystemPhotoVC.m
//  0803
//
//  Created by dqh on 2017/11/15.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "SystemPhotoVC.h"
#import "JSPhotoBrowserVC.h"
#import "JSImageManager.h"

@interface SystemPhotoVC () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) PHFetchResult *assetResult;
@end

@implementation SystemPhotoVC

- (instancetype)initWithResults:(PHFetchResult *)result
{
    if (self = [super init]) {
        _assetResult = result;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageArray = @[].mutableCopy;
    if (!self.collectionView.superview) [self.view addSubview:self.collectionView];

    
    [self getRecosure];
//    [self getPhotoLibrary];
    // Do any additional setup after loading the view.
}


- (void)getRecosure
{
    JSImageManager *imageManager = [JSImageManager shareManager];

    NSInteger assetCount = self.assetResult.count;
    for (NSInteger i = 0; i < assetCount; i++) {
        PHAsset *asset = self.assetResult[i];
        
        [imageManager getPhotoWithAsset:asset
                                   size:CGSizeMake(81, 81*4/3.)
                            contentMode:PHImageContentModeAspectFit
                             resizeMode:PHImageRequestOptionsResizeModeExact
                            synchronous:YES
                       completionHnader:^(UIImage *photo, NSDictionary *info) {
                           
                           self.imageArray[i] = photo;
                           if (i == assetCount-1) {
                               [self.collectionView reloadData];
                           }
                           
        } progressHnader:nil];
        
//        [imageManager requestImageForAsset:asset
//                                targetSize:CGSizeMake(81, 81*4/3.)
//                               contentMode:PHImageContentModeAspectFit
//                                   options:options
//                             resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//
//                                 self.imageArray[i] = result;
//
//                                 if (i == assetFetchResult.count-1) {
//                                     [self.collectionView reloadData];
//                                 }
//                                 if (i == 0) {
//                                     NSLog(@"\n\n< PHImageResultIsInCloudKey : %@,\n<PHImageResultIsDegradedKey : %@\n<PHImageResultRequestIDKey : %@\n<PHImageCancelledKey : %@\n<PHImageErrorKey : %@\n<-------------------------------->\n",info[PHImageResultIsInCloudKey],info[PHImageResultIsDegradedKey],info[PHImageResultRequestIDKey],info[PHImageCancelledKey],info[PHImageErrorKey]);
//                                     NSLog(@"00000");
//                                 }
//                                 if (i == 10) {
//                                     NSLog(@"当前线程： %@",[NSThread currentThread]);
//                                     NSLog(@"10000");
//                                 }
//                             }
//         ];
    }
    
    
    
    NSLog(@"ss");
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(81, 81*4/3.);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    UIImage *image = self.imageArray[indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 81, 81*4/3.)];
    imageView.image = image;
    [cell.contentView addSubview:imageView];
    
    return cell;
}

#pragma mark - delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSPhotoBrowserVC *vc = [[JSPhotoBrowserVC alloc] initWithAssets:self.assetResult currentIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 其它
- (UIImage *)originImage
{
    
    
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
