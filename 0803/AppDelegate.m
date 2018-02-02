//
//  AppDelegate.m
//  0803
//
//  Created by dqh on 17/8/3.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "AppDelegate.h"
#import "RootNavigationController.h"
#import "ViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"

#import "OneVC.h"
#import "TwoVC.h"
#import "ThreeVC.h"

@interface AppDelegate () <RDVTabBarControllerDelegate>
@property (strong, nonatomic) UIViewController *viewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//
//    self.window.backgroundColor = [UIColor whiteColor];
//
//    RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:[ViewController new]];
//    self.window.rootViewController = nav;
//
//    [self.window makeKeyAndVisible];
    
    [self setRootController];
    
    
    
    return YES;
}


- (void)setRootController
{
    RootNavigationController *home = [[RootNavigationController alloc] initWithRootViewController:[[OneVC alloc] init]];
    RootNavigationController *xindai = [[RootNavigationController alloc] initWithRootViewController:[[TwoVC alloc] init]];
    //    RootNavigationViewController *baoquan = [[RootNavigationViewController alloc] initWithRootViewController:[[BaoQuanVC alloc] init]];
    RootNavigationController *user = [[RootNavigationController alloc] initWithRootViewController:[[ThreeVC alloc] init]];
    
    RDVTabBarController *tabbarVC = [[RDVTabBarController alloc] init];
    tabbarVC.viewControllers = @[home,xindai/*,baoquan*/,user];
    tabbarVC.delegate = self;
    self.viewController = tabbarVC;
    
    [self customizeTabBarForController:tabbarVC];
    [self setRoot];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController
{
    //    NSArray *tabBarItemImages = @[@"icon_table1.png",@"icon_table2.png",@"icon_table3.png",@"icon_table4.png"];
    //    NSArray *selectedImages = @[@"icon_table1_press.png",@"icon_table2_press.png",@"icon_table3_press.png",@"icon_table4_press.png"];
    NSArray *tabBarItemImages = @[@"icon_table1.png",@"icon_table2.png",@"icon_table4.png"];
    NSArray *selectedImages = @[@"icon_table1_press.png",@"icon_table2_press.png",@"icon_table4_press.png"];
    
    
    NSInteger index = 0;
    tabBarController.tabBar.translucent = NO;

    
    for (RDVTabBarItem *item in tabBarController.tabBar.items)
    {
        UIImage *selectedimage = [UIImage imageNamed:[selectedImages objectAtIndex:index]];
        UIImage *unselectedimage = [UIImage imageNamed:[tabBarItemImages objectAtIndex:index]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        UIColor *sel = [UIColor redColor];
        UIColor *unsel = [UIColor grayColor];
        
        NSDictionary *unseleAtrr = @{
                                     NSFontAttributeName: [UIFont systemFontOfSize:11.],//修改过的字体
                                     NSForegroundColorAttributeName: unsel
                                     };
        NSDictionary *seleAtrr = @{
                                   NSFontAttributeName: [UIFont systemFontOfSize:11.],
                                   NSForegroundColorAttributeName: sel,
                                   };
        [item setUnselectedTitleAttributes:unseleAtrr];
        [item setSelectedTitleAttributes:seleAtrr];
        [item setTitle:@[@"首页",@"信贷"/*,@"保全"*/,@"我的"][index]];
        [item setTitlePositionAdjustment:UIOffsetMake(0, 5)];
        index++;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0., 0.5)];
    view.backgroundColor = [UIColor blackColor];
    [tabBarController.tabBar.backgroundView addSubview:view];
    
    
    if (isIphoneX) {
        [tabBarController.tabBar setHeight:83];
        [tabBarController.tabBar setContentEdgeInsets:UIEdgeInsetsMake(18, 0, 0, 0)];
    }
}

- (void)setRoot
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    nav.navigationBar.hidden = YES;
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
