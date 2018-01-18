//
//  VideoPlayVC.m
//  0803
//
//  Created by dqh on 2018/1/3.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "VideoPlayVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface VideoPlayVC ()
@property (nonatomic, strong) MPMoviePlayerController *videoPlayer;

@end

@implementation VideoPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.videoPlayer = [[MPMoviePlayerController alloc] init];
    [self.videoPlayer.view setFrame:self.view.bounds];
    self.videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.videoPlayer.view];
    [self.videoPlayer prepareToPlay];
    self.videoPlayer.controlStyle = MPMovieControlStyleNone;
    self.videoPlayer.shouldAutoplay = YES;
    self.videoPlayer.repeatMode = MPMovieRepeatModeOne;
    self.title = NSLocalizedString(@"PreView", nil);
    
    
    self.videoPlayer.contentURL = self.videoUrl;
    [self.videoPlayer play];
    // Do any additional setup after loading the view.
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
