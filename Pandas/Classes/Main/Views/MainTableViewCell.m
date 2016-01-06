//
//  MainTableViewCell.m
//  Pandas
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "MainTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MainTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *activiityImageView;
//活动价格

@property (weak, nonatomic) IBOutlet UILabel *activityPricLabel;
//
@property (weak, nonatomic) IBOutlet UIButton *activityDisButton;
//
@property (weak, nonatomic) IBOutlet UILabel *activityNameLabel;

@end

@implementation MainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
//在重写方法中赋值
-(void)setModel:(MainModel *)model{

    [self.activiityImageView sd_setImageWithURL:[NSURL URLWithString:model.image_big] placeholderImage:nil];
    self.activityNameLabel.text = model.title;
    self.activityPricLabel.text = model.price;
    if ([model.type integerValue]!=RecommendTypeActivity) {
        self.activityDisButton.hidden = YES;

    } else {
    
        self.activityDisButton.hidden = NO;
    
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
