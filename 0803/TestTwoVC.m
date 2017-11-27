//
//  TestTwoVC.m
//  0803
//
//  Created by dqh on 2017/11/20.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "TestTwoVC.h"
#import "JSImageManager.h"
#import "JSAlbumBrowserCell.h"
#import "SystemPhotoVC.h"

@interface TestTwoVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;
@end

@implementation TestTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = @[];
    [self aa];
    
    if (self.dataArray.count != 0) {
        JSAlbumMode *mode = self.dataArray[0];
        SystemPhotoVC *vc = [[SystemPhotoVC alloc] initWithResults:mode.result];
        [self.navigationController pushViewController:vc animated:NO];
    }
    // Do any additional setup after loading the view.
}

- (void)aa
{
    if (!self.tableView.superview) [self.view addSubview:self.tableView];
    
    JSImageManager *manager = [JSImageManager shareManager];
    @weakify(self)
    [manager getAllAlbumsContainVideo:YES completionHnader:^(NSArray<JSAlbumMode *> *albumsArray) {
        @strongify(self)
        self.dataArray = albumsArray.copy;
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSAlbumBrowserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSAlbumBrowserCell"];
    
    JSAlbumMode *mode = self.dataArray[indexPath.row];
    cell.mode = mode;
    
    return cell;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 100.;
        [_tableView registerClass:[JSAlbumBrowserCell class] forCellReuseIdentifier:@"JSAlbumBrowserCell"];
    }
    return _tableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSAlbumMode *mode = self.dataArray[indexPath.row];
    
    SystemPhotoVC *vc = [[SystemPhotoVC alloc] initWithResults:mode.result];
    [self.navigationController pushViewController:vc animated:YES];
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
