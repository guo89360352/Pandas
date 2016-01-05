//
//  MainModel.m
//  Pandas
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel
-(instancetype)initWithDictionary:(NSDictionary *)dic{

    self = [super init];
    if (self) {
        self.type = dic[@"type"];
        if ([self.type integerValue] == RecommendTypeActivity) {
            //如果是推荐活动
            self.address = dic[@"address"];
            self.counts = dic[@"counts"];
            self.endTime = dic[@"endTime"];
            self.image_big = dic[@"image_big"];
            self.startTime = dic[@"startTime"];
            self.price = dic[@"price"];
            self.title = dic[@"title"];
            self.activityId = dic[@"id"];
            self.lat = [dic[@"lat"] floatValue];
            self.lng = [dic[@"lng"]floatValue];
        } else {
            //如果推荐专题
            self.activityDescription = dic[@"description"];
        }
        self.image_big = dic[@"image_big"];
        self.title = dic[@"title"];
        self.activityId = dic[@"id"];

       
    }

    return self;
}
-(void)getWithDic:(NSDictionary *)dic{

    

}
@end
