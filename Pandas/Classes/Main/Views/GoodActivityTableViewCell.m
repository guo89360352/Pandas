//
//  GoodActivityTableViewCell.m
//  Pandas
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "GoodActivityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GoodActivityTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *activityDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveCountButton;
@property (weak, nonatomic) IBOutlet UIImageView *ageBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation GoodActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kScreenWidth, 90);
}
-(void)setGoodModel:(GoodActivityModel *)goodModel{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.image] placeholderImage:nil];
    self.headImageView.layer.cornerRadius = 10;
    
    self.activityTitleLabel.text = goodModel.title;
    self.activityPriceLabel.text = goodModel.price;
    self.activityDistanceLabel.text = @"666km";
    self.ageLabel.text = goodModel.age;

    [self.loveCountButton setTitle:[NSString stringWithFormat:@"%@",goodModel.counts] forState:UIControlStateNormal];
//    if ([goodModel.type integerValue]!=) {
//        self.loveCountButton.hidden = YES;
//        
//    } else {
//        
//        self.loveCountButton.hidden = NO;
//        
//    }


    


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
