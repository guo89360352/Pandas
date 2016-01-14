//
//  AppDelegate.h
//  Pandas
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *wbtoken;
    NSString *wbCurrentUserID;
    
}
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)NSString *wbtoken;
@property(strong,nonatomic)NSString *wbRefreshToken;
@property(strong,nonatomic)NSString *wbCurrentUserID;

@property (strong, nonatomic) UIWindow *windoww;

@property (strong, nonatomic) UITabBarController *tabBarVC;


@end

