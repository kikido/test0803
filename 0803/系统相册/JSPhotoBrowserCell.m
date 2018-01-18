//
//  JSPhotoBrowserCell.m
//  0803
//
//  Created by dqh on 2017/12/4.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "JSPhotoBrowserCell.h"

@interface JSPhotoBrowserCell ()
@end

@implementation JSPhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_xin_allchoose"] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo((@-2.));
            make.top.equalTo(@(2.));
        }];
        self.selectButton = button;
    }
    return self;
}


@end
