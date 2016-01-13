//
//  DiscoverModel.h
//  Pandas
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, strong) NSString *type;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end
