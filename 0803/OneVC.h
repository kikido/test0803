//
//  OneVC.h
//  0803
//
//  Created by dqh on 17/8/24.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneVC : UIViewController
@property (nonatomic, copy) CGFloat (^aa)(NSString *dd);
@property (nonatomic, strong, readonly) NSString *name;
- (instancetype)initWithName:(NSString *)name NS_DESIGNATED_INITIALIZER;
@end

@protocol JJDelegate <NSObject>
@property (nonatomic) NSString *name;
@end
