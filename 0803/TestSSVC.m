//
//  IJSPreviewImageCell.m
//  JSPhotoSDK
//
//  Created by shan on 2017/6/6.
//  Copyright © 2017年 shan. All rights reserved.
//

#import "TestSSVC.h"

#define JSScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define JSScreenHeight ([UIScreen mainScreen].bounds.size.height)

@interface TestSSVC () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *backImageView;
@end

@implementation TestSSVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.scrollView.superview) [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.backImageView];
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


- (UIImageView *)backImageView
{
    if (!_backImageView)
    {
        _backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        UIImage *image = [UIImage imageNamed:@"meet.jpg"];
        _backImageView.image = image;
        _backImageView.backgroundColor = [UIColor yellowColor];
//        _backImageView.backgroundColor = [UIColor colorWithRed:(34 / 255.0) green:(34 / 255.0) blue:(34 / 255.0) alpha:1.0];
//        [self _addTapWithView:_backImageView];
    }
    return _backImageView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.pagingEnabled = NO;
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 2;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor yellowColor];
        [_scrollView setZoomScale:1];
    }
    return _scrollView;
}



// 设置大小
- (void)_setBackViewFrame:(UIView *)view height:(CGFloat)height
{
    view.frame = CGRectMake(0, 0, JSScreenWidth, height);
    view.center = CGPointMake(JSScreenWidth / 2, JSScreenHeight / 2);
}
// 给view添加手势
- (void)_addTapWithView:(UIView *)view
{
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTwoFingerTap:)];
    
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    doubleTap.numberOfTapsRequired = 2;       //需要点两下
    twoFingerTap.numberOfTouchesRequired = 2; //需要两个手指touch
    
    [view addGestureRecognizer:singleTap];
    [view addGestureRecognizer:doubleTap];
    [view addGestureRecognizer:twoFingerTap];
    
    [self.scrollView addGestureRecognizer:singleTap]; // 当视频区域小的时候响应时间
    
    [singleTap requireGestureRecognizerToFail:doubleTap]; //如果双击了，则不响应单击事件
}



#pragma mark - 双击
- (void)_handleDoubleTap:(UITapGestureRecognizer *)doubleTap
{
    if (doubleTap.numberOfTapsRequired == 2)
    {
        if (self.scrollView.zoomScale == 1)
        {
            CGFloat newScale = self.scrollView.zoomScale * 2;
            CGRect zoomRect = [self zoomRectForScale:newScale location:[doubleTap locationInView:doubleTap.view]];
            [self.scrollView zoomToRect:zoomRect animated:YES];
        }
        else
        {
            CGFloat newScale = self.scrollView.zoomScale / 2;
            CGRect zoomRect = [self zoomRectForScale:newScale location:[doubleTap locationInView:doubleTap.view]];
            [self.scrollView zoomToRect:zoomRect animated:YES];
        }
    }
}

#pragma mark 捏合

- (void)_handleTwoFingerTap:(UITapGestureRecognizer *)tap
{
    CGFloat newScale = self.scrollView.zoomScale / 2;
    CGRect zoomRect = [self zoomRectForScale:newScale location:[tap locationInView:tap.view]];
    [self.scrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark 获取缩放的大小

- (CGRect)zoomRectForScale:(CGFloat)newScale location:(CGPoint)center
{
    CGRect zoomRect;
    // 大小
    zoomRect.size.width = self.scrollView.frame.size.width / newScale;
    zoomRect.size.height = self.scrollView.frame.size.height / newScale;
    
    // 原点
    zoomRect.origin.x = center.x - zoomRect.size.width / 2;
    zoomRect.origin.y = center.y - zoomRect.size.height / 2;
    return zoomRect;
}

#pragma mark UIScrollViewDelegaete
/**
 *  scroll view处理缩放和平移手势，必须需要实现委托下面两个方法,另外 maximumZoomScale和minimumZoomScale两个属性要不一样
 */
// 1.返回要缩放的图片
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.backImageView;
}

// 让图片保持在屏幕中央，防止图片放大时，位置出现跑偏
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *anyView;
    anyView = self.backImageView;

    CGFloat offsetX = 0.0;
    if (self.scrollView.bounds.size.width > self.scrollView.contentSize.width)
    {
        offsetX = (self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5;
    }
    CGFloat offsetY = 0.0;
    if ((self.scrollView.bounds.size.height > self.scrollView.contentSize.height))
    {
        offsetY = (self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5;
    }
    
    anyView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX, self.scrollView.contentSize.height * 0.5 + offsetY);
}

// 2.重新确定缩放完后的缩放倍数
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale + 0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}

@end

