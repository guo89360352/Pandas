//
//  ActivityDetailView.m
//  Pandas
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "ActivityDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HWTool.h"
#import "UIView+Extenstin.h"
#import "HWDefine.h"
#import "PrefixHeader.pch"
@interface ActivityDetailView ()
{
//保存上一次图片底部的高度
    CGFloat _previousImageBottom;
//上张图片的高度
    CGFloat _previousImageHeight;
}
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitle;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *favouriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;





@end


@implementation ActivityDetailView

-(void)awakeFromNib{

 self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, 10000);
}


//在set方法中赋值
-(void)setDataDic:(NSDictionary *)dataDic{
    NSArray *urls = dataDic[@"urls"];
    NSString *str = urls[0];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
    self.activityTitle.text = dataDic[@"title"];
    //多少人喜欢
    self.favouriteLabel.text = [NSString stringWithFormat:@"%@人喜欢",dataDic[@"fav"]];
    //参考价格
    self.priceLabel.text = [NSString stringWithFormat:@"价格参考：%@",dataDic[@"pricedesc"]];
    //活动起止时间
    NSString *startTime = [HWTool getDateFromString:dataDic[@"new_start_date"]];
    NSString *endTime = [HWTool getDateFromString:dataDic[@"new_end_date"]];
    
    
    
    self.activityTimeLabel.text = [NSString stringWithFormat:@"%@ - %@",startTime,endTime];
    //活动地址
    self.activityAddressLabel.text = dataDic[@"address"];
    //活动电话
    self.activityPhoneLabel.text = dataDic[@"tel"];
//活动详情

    [self drawContentWithArray:dataDic[@"content"]];
}
-(void)drawContentWithArray:(NSArray *)contentArray{
    
    
    
    for (NSDictionary *dic in contentArray) {
             //每一段活动信息
        
         CGFloat height = [HWTool getTextHeightWithText:dic[@"description"] bigestSize:CGSizeMake(kScreenWidth, 1000) textFont:15.0];
        CGFloat y;
        //如果图片底部没有值（小于500），说明也就是加载第一个label，那么y的值不应减去500
        if (_previousImageBottom > 500) {
            //
            y = 500 + _previousImageBottom -500;
        }else {
            y = 500 + _previousImageBottom;
        }
        //如果标题存在,标题的高度应该是上次图片的底部高度
        NSString *title = dic[@"title"];
        if (title != nil) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kScreenWidth -20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //下面详细信息label显示的时候，高度的坐标应该再加30，也就是标题的高度
            y+=30;
        }

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, kScreenWidth-20, height)];
              label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.mainScrollView addSubview:label];
        NSArray *urlsArray = dic[@"urls"];
        if (urlsArray == nil) {
            //当某个段落中没有图片的时候使用上次label的底部高度+10
            _previousImageBottom = label.bottom +10;
        }else {
            for (NSDictionary *urlDic in urlsArray) {
                 CGFloat imageHeight;
                if (urlsArray.count > 1) {
                //多张图片
                    imageHeight = label.bottom + _previousImageHeight;
                
                }else {
                //单张图片
                    imageHeight = label.bottom;
                }
                
                CGFloat width =[urlDic[@"width"] integerValue];
                CGFloat height01 =[urlDic[@"height"] integerValue];
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, label.bottom, kScreenWidth -20 , (kScreenWidth -20)/width *height01)];
                [imageV sd_setImageWithURL:urlDic[@"url"] placeholderImage:nil];
                [self.mainScrollView addSubview:imageV];
                //每次都保留最新的图片的高度
                _previousImageBottom = imageV.bottom;
            }

        
        }
            
        for (NSDictionary *urlDic in urlsArray) {
            
            CGFloat width =[urlDic[@"width"] integerValue];
            CGFloat height01 =[urlDic[@"height"] integerValue];
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, label.bottom, kScreenWidth -20 , (kScreenWidth -20)/width *height01)];
            [imageV sd_setImageWithURL:urlDic[@"url"] placeholderImage:nil];
            [self.mainScrollView addSubview:imageV];
            //每次都保留最新的图片的高度
            _previousImageBottom = imageV.bottom;
        }
    }
    
    

}
@end
