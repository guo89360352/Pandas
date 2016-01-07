//
//  ActivityDetailView.h
//  Pandas
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailView : UIView

@property (weak, nonatomic) IBOutlet UIButton *mapButton;

@property (weak, nonatomic) IBOutlet UIButton *makeCallButton;

@property(strong,nonatomic) NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UILabel *activityPhoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *activityAddressLabel;

@end
