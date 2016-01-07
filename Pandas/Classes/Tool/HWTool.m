//
//  HWTool.m
//  Pandas
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "HWTool.h"

@implementation HWTool

#pragma mark --- 时间转换相关方法
+(NSString *)getDateFromString:(NSString *)timestamp{
    NSTimeInterval time = [timestamp doubleValue];
    NSDate *data = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy.MM.dd"];
    NSString *timer = [dateFormater stringFromDate:data];
        return timer;
}

#pragma mark ----根据文字最大显示宽高和文字内容返回文字高度
+(CGFloat)getTextHeightWithText:(NSString *)text bigestSize:(CGSize)bigSize textFont:(CGFloat)font{

    
    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil];
    
    
    
    
    return textRect.size.height;

}

@end
