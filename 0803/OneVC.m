//
//  OneVC.m
//  0803
//
//  Created by dqh on 17/8/24.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "OneVC.h"
#import "Tool.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIImageView+WebCache.h>
#import <UIImage+AFNetworking.h>
#import <AFImageDownloader.h>

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface OneVC ()
@property (nonatomic, strong) ARSCNView *arSCNView;
@property (nonatomic, strong) ARSession *arSession;
@property (nonatomic, strong) ARConfiguration *arConfiguration;
@property (nonatomic, strong) SCNNode *planeNode;

@property (nonatomic, strong) MASConstraint *width;
@end

@implementation OneVC


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    self.arSCNView.superview ? nil : [self.view addSubview:self.arSCNView];
//    [self.view addSubview:self.arSCNView];    
//    [self.arSession runWithConfiguration:self.arConfiguration];
    
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *path = [bundle pathForResource:@"ship.scn" ofType:@"scn"];
//    NSURL *url = [NSURL fileURLWithPath:path];
//    SCNScene *ss = [SCNScene sceneWithURL:url options:nil error:nil];
//
//    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    NSLog(@"版本02");
    
    NSLog(@"分支01");
//    NSString *ss = @"这是测试";
//
//    NSData *dd = [ss dataUsingEncoding:NSUTF8StringEncoding];
//
//    NSData *cc = [dd base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
//
//    NSLog(@"cc = %@\n dd=%@",dd,cc);
}



- (ARConfiguration *)arConfiguration
{
    if (_arConfiguration == nil) {
        ARWorldTrackingConfiguration *tranckConfigration = [[ARWorldTrackingConfiguration alloc] init];
        tranckConfigration.planeDetection = ARPlaneDetectionHorizontal;
        _arConfiguration = tranckConfigration;
        
        _arConfiguration.lightEstimationEnabled = YES;
    }
    return _arConfiguration;
}

- (ARSCNView *)arSCNView
{
    if (_arSCNView == nil) {
        _arSCNView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
        _arSCNView.session = self.arSession;
        _arSCNView.automaticallyUpdatesLighting = YES;
    }
    return _arSCNView;
}

- (ARSession *)arSession
{
    if (_arSession == nil) {
        _arSession = [[ARSession alloc] init];
    }
    return _arSession;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
//    SCNNode *ship = scene.rootNode.childNodes[0];
    
//    self.arSCNView.scene = scene;
//    [self.arSCNView.scene.rootNode addChildNode:ship];
    
    //1.使用场景加载scn文件（scn格式文件是一个基于3D建模的文件，使用3DMax软件可以创建，这里系统有一个默认的3D飞机）--------在右侧我添加了许多3D模型，只需要替换文件名即可
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    //2.获取飞机节点（一个场景会有多个节点，此处我们只写，飞机节点则默认是场景子节点的第一个）
    //所有的场景有且只有一个根节点，其他所有节点都是根节点的子节点
    SCNNode *shipNode = scene.rootNode.childNodes[0];
    
    

    
    //3.将飞机节点添加到当前屏幕中
    [self.arSCNView.scene.rootNode addChildNode:shipNode];

}

static void aa()
{
}

- (void)viewWillAppear:(BOOL)animated
{
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
