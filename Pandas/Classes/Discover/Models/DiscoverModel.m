//
//  DiscoverModel.m
//  Pandas
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "DiscoverModel.h"

@implementation DiscoverModel

-(instancetype)initWithDic:(NSDictionary *)dic{

    self = [super init];
    if (self) {
        self.title = dic[@"title"];
        self.image = dic[@"image"];
        self.activityId = dic[@"id"];
        self.type = dic[@"type"];
    }
    return self;

}





@end
