//
//  RecordVideoVC.m
//  0803
//
//  Created by dqh on 2018/1/2.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "RecordVideoVC.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoPlayVC.h"
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface RecordVideoVC ()
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewlayer;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *FileOutput;

@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) MPMoviePlayerController *pp;
@end

@implementation RecordVideoVC
//- (AVCaptureSession *)captureSession
//{
//    if (_captureSession == nil) {
//        _captureSession = [[AVCaptureSession alloc] init];
//        if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
//            [_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
//        }
//    }
//    return _captureSession;
//}

#pragma mark - lazy load
- (AVCaptureSession *)session
{
    // 录制5秒钟视频 高画质10M,压缩成中画质 0.5M
    // 录制5秒钟视频 中画质0.5M,压缩成中画质 0.5M
    // 录制5秒钟视频 低画质0.1M,压缩成中画质 0.1M
    // 只有高分辨率的视频才是全屏的，如果想要自定义长宽比，就需要先录制高分辨率，再剪裁，如果录制低分辨率，剪裁的区域不好控制
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        if ([_session canSetSessionPreset:AVCaptureSessionPresetMedium]) {//设置分辨率
            _session.sessionPreset = AVCaptureSessionPresetMedium;
        }
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewlayer
{
    if (!_previewlayer) {
        _previewlayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewlayer;
}
- (NSURL *)videoUrl

{
    
    if (_videoUrl == nil) {
        
        //一个临时的地址   如果使用NSUserDefault 存储的话，重启app还是能够播放
        
        NSString *outputFilePath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];
        
        NSURL *fileUrl=[NSURL fileURLWithPath:outputFilePath];
        
        _videoUrl = fileUrl;
        
    }
    
    return _videoUrl;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setUp];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 40, 40)];
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button01 = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 40, 40)];
    button01.backgroundColor = [UIColor blackColor];
    [button01 addTarget:self action:@selector(aa:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button01];
    
    UIButton *button02 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 40, 40)];
    button02.backgroundColor = [UIColor blackColor];
    [button02 addTarget:self action:@selector(bb:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button02];
    
    // Do any additional setup after loading the view.
}

- (void)bb:(UIButton *)sender
{
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"question20171229" ofType:@"mp4"];
    if (musicPath) {
        NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
        MPMoviePlayerController *theAudioPlayer = [[MPMoviePlayerController alloc] initWithContentURL:musicURL];
        theAudioPlayer.view.frame = CGRectMake(0, 0, 300, 400);
        [self.view addSubview:theAudioPlayer.view];
        self.pp = theAudioPlayer;
        
        NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(mediaPlayerThumbnailRequestFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:self.pp];
//        [theAudioPlayer prepareToPlay];
        [self.pp requestThumbnailImagesAtTimes:@[@0.0] timeOption:MPMovieTimeOptionNearestKeyFrame];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [theAudioPlayer play];
//        });
    }
    
}

-(void)mediaPlayerThumbnailRequestFinished:(NSNotification *)notification{
    NSLog(@"视频截图完成.");
    UIImage *image=notification.userInfo[MPMoviePlayerThumbnailImageKey];
    //保存图片到相册(首次调用会请求用户获得访问相册权限)
//    self.pp.
}

- (void)aa:(UIButton *)sender
{
    VideoPlayVC *vc = [[VideoPlayVC alloc] init];
    vc.videoUrl = self.videoUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)startRecord:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self.FileOutput startRecordingToOutputFileURL:self.videoUrl recordingDelegate:self];
    } else {
        [self.FileOutput stopRecording];
        [self.session stopRunning];
    }
}

- (void)setUp
{
    [self clearFile];
    
    ///1. 设置视频的输入
    [self setUpVideo];
    
    ///2. 设置音频的输入
    [self setUpAudio];
    
    ///3.添加写入文件的fileoutput
    [self setUpFileOut];
    
    ///4. 视频的预览层
    [self setUpPreviewLayerWithType];
    
    ///5. 开始采集画面
    [self.session startRunning];
    
    /// 6. 将采集的数据写入文件（用户点击按钮即可将采集到的数据写入文件）
    
    /// 7. 增加聚焦功能（可有可无）
//    [self addFocus];
}

- (void)clearFile
{
    [[NSFileManager defaultManager] removeItemAtPath:self.videoUrl.absoluteString error:nil];
}

- (void)setUpVideo
{
    // 1.1 获取视频输入设备(摄像头)
    AVCaptureDevice *videoCaptureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    
    // 视频 HDR (高动态范围图像)
    // videoCaptureDevice.videoHDREnabled = YES;
    // 设置最大，最小帧速率
    //videoCaptureDevice.activeVideoMinFrameDuration = CMTimeMake(1, 60);
    // 1.2 创建视频输入源
    NSError *error=nil;
    self.videoInput= [[AVCaptureDeviceInput alloc] initWithDevice:videoCaptureDevice error:&error];
    // 1.3 将视频输入源添加到会话
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
        
    }
}

- (void)setUpAudio
{
    // 2.1 获取音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    NSError *error=nil;
    // 2.2 创建音频输入源
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    // 2.3 将音频输入源添加到会话
    if ([self.session canAddInput:self.audioInput]) {
        [self.session addInput:self.audioInput];
    }
}

- (void)setUpFileOut
{
    // 3.1初始化设备输出对象，用于获得输出数据
    self.FileOutput=[[AVCaptureMovieFileOutput alloc]init];
    
    // 3.2设置输出对象的一些属性
    AVCaptureConnection *captureConnection=[self.FileOutput connectionWithMediaType:AVMediaTypeVideo];
    //设置防抖
    //视频防抖 是在 iOS 6 和 iPhone 4S 发布时引入的功能。到了 iPhone 6，增加了更强劲和流畅的防抖模式，被称为影院级的视频防抖动。相关的 API 也有所改动 (目前为止并没有在文档中反映出来，不过可以查看头文件）。防抖并不是在捕获设备上配置的，而是在 AVCaptureConnection 上设置。由于不是所有的设备格式都支持全部的防抖模式，所以在实际应用中应事先确认具体的防抖模式是否支持：
    if ([captureConnection isVideoStabilizationSupported ]) {
        captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
    }
    //预览图层和视频方向保持一致
    captureConnection.videoOrientation = [self.previewlayer connection].videoOrientation;
    
    // 3.3将设备输出添加到会话中
    if ([_session canAddOutput:_FileOutput]) {
        [_session addOutput:_FileOutput];
    }
}

- (void)setUpPreviewLayerWithType
{
    self.previewlayer.frame = self.view.layer.frame;
    [self.view.layer insertSublayer:self.previewlayer atIndex:0];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL
      fromConnections:(NSArray *)connections
{
//    self.recordState = FMRecordStateRecording;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(refreshTimeLabel) userInfo:nil repeats:YES];
    NSLog(@"----开始录制-----");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    
    NSLog(@"----结束录制-----");
    
    CGFloat aa = [self getfileSize:outputFileURL.path];
    NSLog(@"wenjian = %f",aa);
    
}


#pragma mark - 获取摄像头
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

- (CGFloat)getfileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init] ;
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = fileDic.fileSize;
        filesize = 1*size;
    }
    return filesize;
    
    NSDictionary *outputFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSLog (@"file size: %f", (unsigned long long)[outputFileAttributes fileSize]/1024.00 /1024.00);
    return (CGFloat)[outputFileAttributes fileSize]/1024.00 /1024.00;
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
