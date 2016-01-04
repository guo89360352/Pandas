//
//  MainTableViewCell.m
//  Pandas
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "MainTableViewCell.h"

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
