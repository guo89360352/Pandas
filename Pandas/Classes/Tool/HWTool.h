//
//  HWTool.h
//  Pandas
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"
@interface HWTool : NSObject


+(NSString *)getDateFromString:(NSString *)timestamp;

+(CGFloat)getTextHeightWithText:(NSString *)text bigestSize:(CGSize)bigSize textFont:(CGFloat)font;
@end
