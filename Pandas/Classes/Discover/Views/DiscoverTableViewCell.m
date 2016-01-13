//
//  DiscoverTableViewCell.m
//  Pandas
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "DiscoverTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface DiscoverTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation DiscoverTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setModel:(DiscoverModel *)model{

    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    self.titleLabel.text = model.title;


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
