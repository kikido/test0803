//
//  ViewController.m
//  渐变色圆环
//
//  Created by Self_Improve on 17/2/24.
//  Copyright © 2017年 ZWiOS. All rights reserved.
//

#import "ViewController.h"
#import "SystemPhotoVC.h"
#import "GradualColor_View.h"
#import "OneVC.h"
#import "TwoVC.h"
#import "ThreeVC.h"
#import "TestSSVC.h"
#import <AVFoundation/AVFoundation.h>
#import "JSImageManager.h"
#import "TestTwoVC.h"
#import "TestThreeVC.h"



#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define GRADUALVIE_WIDTH 200

typedef NS_ENUM(NSInteger, AAType){
    AATypeOne = -1,
    AATypeTwo = 2,
    AATypeThree
};



@interface ViewController () <UIScrollViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchControllerDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) GradualColor_View *gradualView;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) CGFloat white;
@property (nonatomic, strong) UIView *bigView;

@property (nonatomic, assign) CGPoint orginPoint;
@property (nonatomic, strong) AVCaptureSession *session;

//
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"测试";
    
   
    JSImageManager *manager = [JSImageManager shareManager];
    BOOL ss = [manager authorizationStatus];
    NSLog(@"这是1.0.1版本")
    
    [self addViewThree];
}

- (void)addViewThree
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 100., 40., 40.)];
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"ss" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        SystemPhotoVC *vc = [SystemPhotoVC new];
//        TestSSVC *vc = [TestSSVC new];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[TestTwoVC new]];
//        [self presentViewController:nav animated:YES completion:nil];
//        TestTwoVC *vc = [TestTwoVC new];
        TestThreeVC *vc = [TestThreeVC new];
        [self.navigationController pushViewController:vc animated:NO];
//        NSURL *url = [NSURL URLWithString:@"app-prefs:root=Photos"];//UIApplicationOpenSettingsURLString
//        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];//UIApplicationOpenSettingsURLString
//        if ([[UIApplication sharedApplication] canOpenURL:url]) {
//            [[UIApplication sharedApplication] openURL:url];
//        }
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
{
    NSLog(@"safeAreaInsets = %@",NSStringFromUIEdgeInsets(scrollView.safeAreaInsets));
    NSLog(@"contentInset = %@",NSStringFromUIEdgeInsets(scrollView.contentInset));
    NSLog(@"adjustedContentInset = %@",NSStringFromUIEdgeInsets(scrollView.adjustedContentInset));
}
- (void)addViewTwo
{
//    self.view.preservesSuperviewLayoutMargins = YES;
//    self.view.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(0, 50, 0, 50.);
    
    UIButton *appearance = [UIButton appearance];
    appearance.backgroundColor = [UIColor blackColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 100., 40., 40.)];
    [button setTitle:@"ss" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        OneVC *vc = [OneVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)addViewOne
{
    self.tableView.superview ? nil : [self.view addSubview:self.tableView];
    
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    [self.tableView reloadData];
    
    //设置searchcontroller
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.searchResultsUpdater = self;
//    self.searchController.dimsBackgroundDuringPresentation = NO;;
//    self.searchController.hidesNavigationBarDuringPresentation = YES;
//    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 40);
//    self.searchController.delegate = self;
//
//    if (@available(iOS 11.0, *)) {
//        self.navigationController.navigationBar.prefersLargeTitles = YES;
//        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
//
//        self.navigationItem.searchController = self.searchController;
//        self.navigationItem.hidesSearchBarWhenScrolling = NO;
//    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"safeAreaInsets = %@",NSStringFromUIEdgeInsets(tableView.safeAreaInsets));
    NSLog(@"contentInset = %@",NSStringFromUIEdgeInsets(tableView.contentInset));
    NSLog(@"adjustedContentInset = %@",NSStringFromUIEdgeInsets(tableView.adjustedContentInset));

    
    OneVC *vc = [OneVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
//    NSLog(@"first size = %@",NSStringFromCGSize(tableView.contentSize));
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = @"测试";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0)
//{
//    return 20.;
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    return [[UIView alloc] initWithFrame:CGRectMake(0., 0, 0, 30)];
//    return [UIView new];
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    return [[UIView alloc] initWithFrame:CGRectMake(0., 0, 0, 30)];
    return nil;
//    return [UIView new];
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 55.;
        
        
        _tableView.estimatedRowHeight = 0.;
        _tableView.estimatedSectionHeaderHeight = 0.;
        _tableView.estimatedSectionFooterHeight = 0.;
    }
    return _tableView;
}
@end
