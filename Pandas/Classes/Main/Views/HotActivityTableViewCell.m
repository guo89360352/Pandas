//
//  HotActivityTableViewCell.m
//  Pandas
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "HotActivityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface HotActivityTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *hotImage;

@end



@implementation HotActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setHotModel:(HotActivityModel *)hotModel{

    [self.hotImage sd_setImageWithURL:[NSURL URLWithString:hotModel.image]  placeholderImage:nil];
    
    
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
