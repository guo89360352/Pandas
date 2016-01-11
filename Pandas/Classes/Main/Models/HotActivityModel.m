//
//  HotActivityModel.m
//  Pandas
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "HotActivityModel.h"

@implementation HotActivityModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.title = dict[@"title"];
        self.image = dict[@"img"];
        self.counts = dict[@"counts"];
        self.price = dict[@"description"];
        self.activityId = dict[@"id"];
        self.address = dict[@"address"];
        self.type = dict[@"type"];
    }
    return self;
}

@end
