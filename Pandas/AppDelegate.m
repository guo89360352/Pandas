//
//  AppDelegate.m
//  Pandas
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "AppDelegate.h"
#import "WeiboSDK.h"
#import "WXApiObject.h"
#import "WXApi.h"

@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate>
@property(retain,nonatomic)UINavigationController *nav;

@end
@interface WBBaseRequest ()
-(void)debugPrint;
@end
@interface WBBaseResponse ()
-(void)debugPrint;
@end

@implementation AppDelegate
@synthesize wbtoken;
@synthesize wbCurrentUserID;
@synthesize wbRefreshToken;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    
    [WXApi registerApp:@"wxd59a15de92d6a502"];
    
    
    
    // Override point for customization after application launch.
    
    //UITableBarControllers
    self.tabBarVC = [[UITabBarController alloc] init];
 
    //创建被tabBarVC管理的视图控制器
    //主页
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *mainNAV = mainStory.instantiateInitialViewController;
    mainNAV.tabBarItem.image = [UIImage imageNamed:@"ft_home_normal_ic"];
    //设置选中图片按照图片原始状态显示
    UIImage *mainsec =[UIImage imageNamed:@"ft_home_selected_ic"];
    mainNAV.tabBarItem.selectedImage = [mainsec imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //规定图片显示的位置：上左下右的顺序设置
       mainNAV.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //发现
    UIStoryboard *discoverStro = [UIStoryboard storyboardWithName:@"Discover" bundle:nil];
    
    UINavigationController *discoverNAV = discoverStro.instantiateInitialViewController;
   
    discoverNAV.tabBarItem.image = [UIImage imageNamed:@"ft_found_normal_ic"];
    discoverNAV.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    UIImage *sec =[UIImage imageNamed:@"ft_found_selected_ic"];
    discoverNAV.tabBarItem.selectedImage = [sec imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //我
    UIStoryboard *mineStro = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    
    UINavigationController *mineNAV = mineStro.instantiateInitialViewController;
    mineNAV.tabBarItem.image = [UIImage imageNamed:@"ft_person_normal_ic"];
    mineNAV.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    UIImage *minesec =[UIImage imageNamed:@"ft_person_selected_ic"];
    mineNAV.tabBarItem.selectedImage = [minesec imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //添加被管理的视图控制器
    self.tabBarVC.viewControllers = @[mainNAV,discoverNAV,mineNAV];
    self.window.rootViewController = self.tabBarVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
    
    
    
}
-(void) onReq:(BaseReq*)req
{
   }

-(void) onResp:(BaseResp*)resp
{
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if([WeiboSDK isCanSSOInWeiboApp]){
        
        return [WeiboSDK handleOpenURL:url delegate:self];
        
    }
    return [WXApi handleOpenURL:url delegate:self];
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
  
    if([WeiboSDK isCanSSOInWeiboApp]){
        
     return [WeiboSDK handleOpenURL:url delegate:self];
        
    }
    

    return [WXApi handleOpenURL:url delegate:self];



}
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *title = NSLocalizedString(@"认证结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        [alert show];
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
        NSString *title = NSLocalizedString(@"支付结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if([response isKindOfClass:WBSDKAppRecommendResponse.class])
    {
        NSString *title = NSLocalizedString(@"邀请结果", nil);
        NSString *message = [NSString stringWithFormat:@"accesstoken:\n%@\nresponse.StatusCode: %d\n响应UserInfo数据:%@\n原请求UserInfo数据:%@",[(WBSDKAppRecommendResponse *)response accessToken],(int)response.statusCode,response.userInfo,response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }

    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
