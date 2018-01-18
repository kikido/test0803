//
//  JSPhotoBrowserVC.m
//  0803
//
//  Created by dqh on 2017/11/16.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "JSPhotoBrowserVC.h"
#import <Photos/Photos.h>

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)


@interface JSPhotoBrowserVC () <UIScrollViewDelegate>
@property (nonatomic, copy) NSArray *assetArray;
@property (nonatomic, assign, readonly) NSInteger currentIndex;

@property (nonatomic, strong) UIScrollView *photoBrowserView;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *isOriginImageArray;//@Bool
@property (nonatomic, strong) NSMutableArray<UIImage *> *originImageArray;
@property (nonatomic, strong) PHImageManager *phImageManager;

@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) UIImageView *zoomView;
@property (nonatomic, strong) UIScrollView *zoomScrollView;
@property (nonatomic, assign, getter=isViewZoom) BOOL viewZoom;
@end

@implementation JSPhotoBrowserVC

- (instancetype)initWithAssets:(PHFetchResult *)assets currentIndex:(NSInteger)currentIndex
{
    if (self = [super init]) {
        _assetArray = assets.copy;
        _currentIndex = currentIndex;
        _viewZoom = NO;
        
        _isOriginImageArray = [NSMutableArray arrayWithCapacity:assets.count];
        _originImageArray = [NSMutableArray arrayWithCapacity:assets.count];
        for (NSInteger i = 0; i < assets.count; i++) {
            _isOriginImageArray[i] = @NO;
            _originImageArray[i] = [NSNull null];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self jsp_creatUI];
    [self jsp_downloadOriginImage:self.currentIndex];
    [self jsp_initZoomViewWithIndex:self.currentIndex];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)jsp_creatUI
{
    if (!self.photoBrowserView.superview) [self.view addSubview:self.photoBrowserView];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.photoBrowserView.contentOffset = CGPointMake(self.currentIndex * width, 0);

//navi
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375., 64.)];
    naviView.backgroundColor = [UIColor colorWithWhite:1. alpha:.8];
    [self.view insertSubview:naviView aboveSubview:self.photoBrowserView];
    self.naviView = naviView;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(jsp_backAction) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0.);
        make.left.equalTo(@15.);
    }];
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setImage:[UIImage imageNamed:@"icon_xin_allchoose"] forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(jsp_backAction) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0.);
        make.right.equalTo(@-15.);
    }];
    
//Bottom
    
}

- (void)jsp_backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 加载原图
- (void)jsp_downloadOriginImage:(NSInteger)imageIndex;
{
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    NSArray *numberArray = @[@-1,@0,@1];
    NSInteger totalCount = self.assetArray.count;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    for (NSInteger i = 0; i < 3; i++) {
        NSInteger assetIndex = imageIndex + [numberArray[i] integerValue];
        if (assetIndex >= totalCount || assetIndex < 0) continue;
        
        PHAsset *currentAsset = self.assetArray[assetIndex];
        if (!currentAsset) return;

        __block UIImage *currentOriginImage = nil;
        
        if ([self.isOriginImageArray[assetIndex] boolValue]) {
            
        } else {
            @weakify(self)
            __block UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(assetIndex * width, 0, width, height)];
            imageView.tag = 100+assetIndex;
            NSLog(@"创建：imageview: %ld",imageView.tag);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.photoBrowserView addSubview:imageView];
            [self jsp_addGestureRecognizerForView:imageView];
            
            [self.phImageManager requestImageForAsset:currentAsset
//                                           targetSize:PHImageManagerMaximumSize/*CGSizeMake(width, height)*/
                                           targetSize:CGSizeMake(width, height)
                                          contentMode:PHImageContentModeDefault
                                              options:requestOptions
                                        resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                            @strongify(self)
//                                            NSLog(@"当前线程： %@",[NSThread currentThread]);
                                            
                                            
//                                            NSLog(@"\n<-------------------------------------------------------->\n< PHImageResultIsInCloudKey : %@,\n<PHImageResultIsDegradedKey : %@\n<PHImageResultRequestIDKey : %@\n<PHImageCancelledKey : %@\n<PHImageErrorKey : %@\n<------------------------------------------------------>\n",info[PHImageResultIsInCloudKey],info[PHImageResultIsDegradedKey],info[PHImageResultRequestIDKey],info[PHImageCancelledKey],info[PHImageErrorKey]);

                                            currentOriginImage = result;
                                            self.originImageArray[assetIndex] = currentOriginImage;
                                            imageView.image = currentOriginImage;
                                        }];
            self.isOriginImageArray[assetIndex] = @YES;

        }
    }
}


- (void)jsp_addGestureRecognizerForView:(UIView *)thisView
{
    if ([thisView isKindOfClass:[UIView class]]) {
        thisView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jsp_singalTapAction:)];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jsp_doubleTapAction:)];
        
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        doubleTap.numberOfTapsRequired = 2;
        
        [thisView addGestureRecognizer:singleTap];
        [thisView addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap]; //如果双击了，则不响应单击事件
    }
}

- (void)jsp_singalTapAction:(UITapGestureRecognizer *)tap
{
    self.naviView.hidden = !self.naviView.isHidden;
}

- (void)jsp_doubleTapAction:(UITapGestureRecognizer *)tap
{
    if (_zoomScrollView.zoomScale == 1) {
        CGFloat newScale = _zoomScrollView.zoomScale * 2;
        CGRect zoomRect = [self zoomRectForScale:newScale location:[tap locationInView:tap.view]];
        [_zoomScrollView zoomToRect:zoomRect animated:YES];
    } else {
        CGFloat newScale = _zoomScrollView.zoomScale / 2;
        CGRect zoomRect = [self zoomRectForScale:newScale location:[tap locationInView:tap.view]];
        [_zoomScrollView zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(CGFloat)newScale location:(CGPoint)center
{
    CGRect zoomRect;
    // 大小
    zoomRect.size.width = self.photoBrowserView.frame.size.width / newScale;
    zoomRect.size.height = self.photoBrowserView.frame.size.height / newScale;
    
    // 原点
    zoomRect.origin.x = center.x - zoomRect.size.width / 2;
    zoomRect.origin.y = center.y - zoomRect.size.height / 2;
    return zoomRect;
}


#pragma mark - 创建缩放需要的ScrollView
- (void)jsp_initZoomViewWithIndex:(NSInteger)imageIndex
{
    self.viewZoom = YES;
    UIImageView *imageView = [self.photoBrowserView viewWithTag:100 + imageIndex];
    _zoomView = imageView;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(_currentIndex * ScreenWidth, 0., ScreenWidth, ScreenHeight)];
    scrollView.pagingEnabled = NO;
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 2;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = YES;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor blackColor];
    [scrollView setZoomScale:1];
    _zoomScrollView = scrollView;
    
    [imageView removeFromSuperview];
    [self.photoBrowserView addSubview:scrollView];
    imageView.frame = CGRectMake(0., 0, ScreenWidth, ScreenHeight);
    [scrollView addSubview:imageView];
}

#pragma mark - 销毁缩放需要的Scrollview
- (void)jsp_destoryZoomView
{
    self.viewZoom = NO;
    
    _zoomView.frame = _zoomScrollView.frame;
    [_zoomView removeFromSuperview];
    [self.photoBrowserView addSubview:_zoomView];
    
    [_zoomScrollView removeFromSuperview];
    _zoomScrollView = nil;
    _zoomView = nil;
}
//|==============================================================================================================================
#pragma mark - 停止滑动的时候才去创建缩放需要的scrollview，节约开销
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.photoBrowserView) return;
    
    CGFloat offCoungF = scrollView.contentOffset.x / ScreenWidth;
    NSLog(@"停止滑动了，偏差量：%.2f",offCoungF);
    
    if (fabs(_currentIndex- offCoungF) > .5) {
        _currentIndex = (NSInteger)offCoungF;
        [self jsp_initZoomViewWithIndex:self.currentIndex];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != self.photoBrowserView) return;
    
    CGFloat offCoungF = scrollView.contentOffset.x / ScreenWidth;
    
    if (_currentIndex - offCoungF > .5000000) {
        if (self.isViewZoom) {
            [self jsp_destoryZoomView];
        }
        [self jsp_downloadOriginImage:(NSInteger)offCoungF];
    } else if (offCoungF - _currentIndex > .500000) {
        if (self.isViewZoom) {
            [self jsp_destoryZoomView];
        }
        [self jsp_downloadOriginImage:(NSInteger)offCoungF];
    }
}

#pragma mark UIScrollViewDelegaete

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView == self.photoBrowserView) return nil;
    return self.zoomView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView == self.photoBrowserView) return;

    UIView *anyView;
    anyView = self.zoomView;
    
    CGFloat offsetX = 0.0;
    if (scrollView.bounds.size.width > scrollView.contentSize.width)
    {
        offsetX = (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5;
    }
    CGFloat offsetY = 0.0;
    if ((scrollView.bounds.size.height > scrollView.contentSize.height))
    {
        offsetY = (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5;
    }
    
    anyView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale + 0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}

- (UIScrollView *)photoBrowserView
{
    if (_photoBrowserView == nil) {
        _photoBrowserView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _photoBrowserView.delegate = self;
        _photoBrowserView.contentSize = CGSizeMake(ScreenWidth * self.assetArray.count, 0);
        _photoBrowserView.pagingEnabled = YES;
        _photoBrowserView.showsHorizontalScrollIndicator = NO;
        _photoBrowserView.backgroundColor = [UIColor yellowColor];
    }
    return _photoBrowserView;
}

- (PHImageManager *)phImageManager
{
    if (_phImageManager == nil) {
        _phImageManager = [PHImageManager defaultManager];
    }
    return _phImageManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
