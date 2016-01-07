//
//  ActivityDetailView.m
//  Pandas
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "ActivityDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface ActivityDetailView ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitle;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *favouriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;





@end


@implementation ActivityDetailView

-(void)awakeFromNib{

 self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, 100);
}


//在set方法中赋值
-(void)setDataDic:(NSDictionary *)dataDic{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    self.activityTimeLabel.text = dataDic[@"title"];
    self.favouriteLabel.text = [NSString stringWithFormat:@"%@人喜欢",dataDic[@"fav"]];
    self.priceLabel.text = dataDic[@"price"];
    self.activityAddressLabel.text = dataDic[@"address"];
    self.activityPhoneLabel.text = dataDic[@"tel"];


}
@end
