#import "VideoTestViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface VideoTestViewController ()<AVCaptureFileOutputRecordingDelegate>

//会话 负责输入和输出设备之间的数据传递
@property (strong,nonatomic) AVCaptureSession    *captureSession;
//设备输入 负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureDeviceInput    *videoCaptureDeviceInput;
@property (strong,nonatomic) AVCaptureDeviceInput    *audioCaptureDeviceInput;
//视频输出流
@property (strong,nonatomic) AVCaptureMovieFileOutput    *captureMovieFileOutput;
//相机拍摄预览图层
@property (strong,nonatomic) AVCaptureVideoPreviewLayer    *captureVideoPreviewLayer;

//自定义UI控件容器
@property (strong,nonatomic) UIView    *viewContainer;
//聚焦图标
@property (strong,nonatomic) UIImageView    *focusCursor;
//录制时长
@property (strong,nonatomic) UILabel    *timeLabel;
//切换前后摄像头
@property (strong,nonatomic) UIButton    *switchCameraBtn;
//改变焦距
@property (strong,nonatomic) UIButton    *scaleBtn;
//计时器
@property (strong,nonatomic) NSTimer    *timer;


@end

@implementation VideoTestViewController {
@private
    NSInteger _num;
    CGFloat _kCameraScale;
}


- (UIView *)viewContainer {
    if (!_viewContainer) {
        _viewContainer = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        UIButton *takeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        takeButton.backgroundColor = [UIColor redColor];
        [takeButton setTitle:@"start" forState:UIControlStateNormal];
        [takeButton addTarget:self action:@selector(takeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor redColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont boldSystemFontOfSize:20];
        _timeLabel.text = @"00:00";
        
        
        _switchCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchCameraBtn setTitle:@"switch" forState:UIControlStateNormal];
        _switchCameraBtn.backgroundColor = [UIColor redColor];
        [_switchCameraBtn addTarget:self action:@selector(switchCameraBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _scaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scaleBtn setTitle:@"1X" forState:UIControlStateNormal];
        _scaleBtn.backgroundColor = [UIColor redColor];
        [_scaleBtn addTarget:self action:@selector(scaleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_viewContainer addSubview:takeButton];
        [_viewContainer addSubview:_timeLabel];
        [_viewContainer addSubview:_scaleBtn];
        [_viewContainer addSubview:_switchCameraBtn];
        [takeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 40));
            make.centerX.mas_equalTo(_viewContainer);
            make.bottom.mas_equalTo(_viewContainer).offset(-64);
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_viewContainer);
            make.height.mas_equalTo(@30);
            make.top.mas_equalTo(_viewContainer);
        }];
        [_scaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 40));
            make.left.mas_equalTo(_viewContainer).offset(10);
            make.top.mas_equalTo(_viewContainer);
        }];
        [_switchCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 40));
            make.top.mas_equalTo(100);
            make.left.mas_equalTo(30.);
        }];
        
        _focusCursor = [[UIImageView alloc] init];
//        kBorder(_focusCursor, 1, [UIColor yellowColor]);
        _focusCursor.alpha = 0;
        [_viewContainer addSubview:self.focusCursor];
        [_focusCursor mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.center.mas_equalTo(_viewContainer);
        }];
        
    }
    return _viewContainer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频录制";
    _kCameraScale = 1.0f;
    //初始化会话对象
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    
    NSError *error = nil;
    
    //获取视频输入对象
    AVCaptureDevice *videoCaptureDevice = [self cameraDeviceWithPosition:(AVCaptureDevicePositionBack)];
    if (!videoCaptureDevice) {
        NSLog(@"获取后置摄像头失败！");
        return;
    }
    _videoCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得视频设备输入对象时出错");
        return;
    }
    
    
    //获取音频输入对象
    AVCaptureDevice *audioCatureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    _audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCatureDevice error:&error];
    if (error) {
        NSLog(@"取得音频设备输入对象时出错");
        return;
    }
    
    //初始化设备输出对象
    _captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_videoCaptureDeviceInput]) {
        [_captureSession addInput:_videoCaptureDeviceInput];
        [_captureSession addInput:_audioCaptureDeviceInput];
        
        //防抖功能
        AVCaptureConnection *captureConnection = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeAudio];
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    
    
    //创建视频预览图层
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    self.viewContainer.layer.masksToBounds = YES;
    _captureVideoPreviewLayer.frame = self.viewContainer.bounds;
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_captureVideoPreviewLayer];
    
    //显示自定义控件
    [self.view addSubview:self.viewContainer];
    
    //添加点按聚焦手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.viewContainer addGestureRecognizer:tapGesture];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.captureVideoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(1, 1)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//开始 + 暂停录制
- (void)takeButtonClick:(UIButton *)sender {
    if ([self.captureMovieFileOutput isRecording]) {
        [self.captureMovieFileOutput stopRecording];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        AVCaptureConnection *captureConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        captureConnection.videoOrientation = [self.captureVideoPreviewLayer connection].videoOrientation;
        
        NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Movie.mov"];
        NSLog(@"%@",filePath);
        [self.captureMovieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:filePath] recordingDelegate:self];
        
        
//        self.switchCameraBtn.hidden = YES;
        
        sender.backgroundColor  = [UIColor greenColor];
        [sender setTitle:@"stop" forState:UIControlStateNormal];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

//切换摄像头
- (void)switchCameraBtnClick {
    AVCaptureDevicePosition currentPosition = self.videoCaptureDeviceInput.device.position;
    AVCaptureDevicePosition toPosition;
    if (currentPosition == AVCaptureDevicePositionUnspecified ||
        currentPosition == AVCaptureDevicePositionFront) {
        toPosition = AVCaptureDevicePositionBack;
    } else {
        toPosition = AVCaptureDevicePositionFront;
    }
    
    AVCaptureDevice *toCapturDevice = [self cameraDeviceWithPosition:toPosition];
    if (!toCapturDevice) {
        NSLog(@"获取要切换的设备失败");
        return;
    }
    
    NSError *error = nil;
    AVCaptureDeviceInput *toVideoDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:toCapturDevice error:&error];
    if (error) {
        NSLog(@"获取要切换的设备输入失败");
        return;
    }
    
    //改变会话配置
    [self.captureSession beginConfiguration];
    
    [self.captureSession removeInput:self.videoCaptureDeviceInput];
    if ([self.captureSession canAddInput:toVideoDeviceInput]) {
        [self.captureSession addInput:toVideoDeviceInput];
        
        self.videoCaptureDeviceInput = toVideoDeviceInput;
    }
    //提交会话配置
    [self.captureSession commitConfiguration];
}


//点按手势
- (void)tapScreen:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self.viewContainer];
    
    //将界面point对应到摄像头point
    CGPoint cameraPoint = [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    
    //设置聚光动画
    self.focusCursor.center = point;
    self.focusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha = 1.0f;
    [UIView animateWithDuration:1 animations:^{
        self.focusCursor.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha = 0.0f;
        
    }];
    
    //设置聚光点坐标
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
    
}


/**设置聚焦点*/
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    
    AVCaptureDevice *captureDevice= [self.videoCaptureDeviceInput device];
    NSError *error = nil;
    //设置设备属性必须先解锁 然后加锁
    if ([captureDevice lockForConfiguration:&error]) {
        
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        //        //曝光
        //        if ([captureDevice isExposureModeSupported:exposureMode]) {
        //            [captureDevice setExposureMode:exposureMode];
        //        }
        //        if ([captureDevice isExposurePointOfInterestSupported]) {
        //            [captureDevice setExposurePointOfInterest:point];
        //        }
        //        //闪光灯模式
        //        if ([captureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
        //            [captureDevice setFlashMode:AVCaptureFlashModeAuto];
        //        }
        
        //加锁
        [captureDevice unlockForConfiguration];
        
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}



//调整焦距
-(void)scaleBtnClick:(UIButton *)sender
{
    _kCameraScale += 0.5;
    if(_kCameraScale > 3.0) {
        _kCameraScale = 1.0;
    }
    //改变焦距
    AVCaptureDevice *videoDevice = self.videoCaptureDeviceInput.device;
    NSError *error = nil;
    if ([videoDevice lockForConfiguration:&error]) {
        
        [videoDevice setVideoZoomFactor:_kCameraScale];
        
        [videoDevice unlockForConfiguration];
        
        [sender setTitle:[NSString stringWithFormat:@"%lgX",_kCameraScale] forState:UIControlStateNormal];
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.25];
        [self.captureVideoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(_kCameraScale, _kCameraScale)];
        [CATransaction commit];
        
    } else {
        NSLog(@"修改设备属性失败!")
    }
}



#pragma mark --------  AVCaptureFileOutputRecordingDelegate  ----------
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    NSLog(@"开始录制");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    NSLog(@"录制结束");
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
        }
    }];
}

//录制计时
- (void)timeAction {
    self.timeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld",_num/60,_num%60];
    _num ++;
}


/**取得指定位置的摄像头*/
- (AVCaptureDevice *)cameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}



@end
