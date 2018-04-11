//
//  SystemPhotoVC.m
//  0803
//
//  Created by dqh on 2017/11/15.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "JSPickerImageVC.h"
#import "JSPhotoBrowserVC.h"
#import "JSImageManager.h"
#import "JSPhotoBrowserCell.h"

static const NSInteger kButtonTag = 100;

@interface JSPickerImageVC () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, weak) id<JSImagePickerControllerDelegate> delegate;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<UIImage *> *imageArray;//缩略图
@property (nonatomic, strong) PHFetchResult *assetResult;//某个相册里面所有的phasset
@property (nonatomic, strong) NSMutableDictionary *cellIdentifierDic;//防止uicollectionview因为复用

@property (nonatomic, strong) NSMutableArray *selectItemArray;//max is 50;
@property (nonatomic, strong) NSMutableDictionary<NSString* ,UIImage*> *selectItemDict;
@end

@implementation JSPickerImageVC

- (instancetype)initWithResults:(PHFetchResult *)result delegate:(id<JSImagePickerControllerDelegate>)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
        _assetResult = result;
        _imageArray = @[].mutableCopy;
        _selectItemArray = @[].mutableCopy;
        _selectItemDict = @{}.mutableCopy;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"批量上传";

    [self jsp_creatUI];
    [self jsp_getRecosure];
//    [self getPhotoLibrary];
    // Do any additional setup after loading the view.
}

- (void)jsp_creatUI
{
    if (!self.collectionView.superview) [self.view addSubview:self.collectionView];

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 45., self.view.bounds.size.width, 45.)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:bottomView aboveSubview:self.collectionView];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont fontWithName:SY_FontNormal size:15.];
    doneButton.backgroundColor = [UIColor blackColor];
    doneButton.layer.cornerRadius = 5.;
    [doneButton addTarget:self action:@selector(jsp_finishPickImage:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.equalTo(@0.);
        make.size.equalTo(@(CGSizeMake(60., 30.)));
    }];
}
//传uiimage或者是phasset 1、内存大，不方便删除 2.转换的时候会很慢
- (void)jsp_getRecosure
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
    }
    NSLog(@"ss");
}

- (void)jsp_finishPickImage:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingWithMedia:)]) {
        [self showHudWithText:@"正在转换..."];
        [self.delegate imagePickerController:self didFinishPickingWithMedia:self.selectItemArray];
    }
}

- (void)finishPickImage
{
    [self showSuccessWithText:@"选择成功" animation:1.5];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(81, 81*4/3.);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 45., 0);
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[JSPhotoBrowserCell class] forCellWithReuseIdentifier:@"JSPhotoBrowserCell"];
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
    NSString *identifier = [_cellIdentifierDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    
    if(identifier == nil){
        identifier = [NSString stringWithFormat:@"selectedBtn%@", [NSString stringWithFormat:@"%@", indexPath]];
        [_cellIdentifierDic setObject:identifier forKey:[NSString  stringWithFormat:@"%@",indexPath]];
        // 注册Cell（把对cell的注册写在此处）
        [_collectionView registerClass:[JSPhotoBrowserCell class] forCellWithReuseIdentifier:identifier];
    }
    JSPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    UIImage *image = self.imageArray[indexPath.row];
    cell.imageView.image = image;
    cell.selectButton.tag = kButtonTag + indexPath.row;
    [cell.selectButton addTarget:self action:@selector(jsp_cellSelctTheButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)jsp_cellSelctTheButton:(UIButton *)sender
{

    sender.selected = !sender.selected;
    JSImageManager *imageManager = [JSImageManager shareManager];
    NSInteger buttonIndex = sender.tag - kButtonTag;
    PHAsset *asset = self.assetResult[buttonIndex];
    
    
    if (sender.isSelected) {
        [sender setImage:[UIImage imageNamed:@"icon_xin_allchoose_pressed"] forState:UIControlStateNormal];
        
//        [imageManager getPhotoWithAsset:asset
////                                   size:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)
//                                   size:PHImageManagerMaximumSize
//                            contentMode:PHImageContentModeAspectFit
//                             resizeMode:PHImageRequestOptionsResizeModeExact
//                            synchronous:YES
//                       completionHnader:^(UIImage *photo, NSDictionary *info) {
//
//                           [_selectItemArray addObject:photo];
//                           _selectItemDict[[NSString stringWithFormat:@"%ld",buttonIndex]] = photo;
//
//                       } progressHnader:nil];
        [self.selectItemArray addObject:asset];
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_xin_allchoose"] forState:UIControlStateNormal];
        UIImage *saveImage = self.selectItemDict[[NSString stringWithFormat:@"%ld",buttonIndex]];
        [self.selectItemArray removeObject:saveImage];
    }
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
