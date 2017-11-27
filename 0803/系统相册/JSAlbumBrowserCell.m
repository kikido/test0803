//
//  JSAlbumBrowserCell.m
//  0803
//
//  Created by dqh on 2017/11/20.
//  Copyright © 2017年 juesheng. All rights reserved.
//

#import "JSAlbumBrowserCell.h"
#import "JSImageManager.h"

@implementation JSAlbumBrowserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setMode:(JSAlbumMode *)mode
{
    if (_mode != mode) {
        _mode = mode;
        
        self.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",mode.title,mode.count];
        @weakify(self)
        [[JSImageManager shareManager] getAlbumFirstImage:mode completionHnader:^(UIImage *firstImage) {
            @strongify(self)
            self.imageView.image = firstImage;
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
