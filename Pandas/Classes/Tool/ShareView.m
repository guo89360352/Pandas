//
//  ShareView.m
//  Pandas
//
//  Created by scjy on 16/1/14.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "ShareView.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "AppDelegate.h"

@interface ShareView ()<WeiboSDKDelegate>
@property (nonatomic,strong)  UIView *shareView;
@property (nonatomic,strong)  UIView *blockView;
@end

@implementation ShareView
-(instancetype)init{

    self = [super init];
    if (self) {
        [self config];
    }
    return self;

}
-(void)config{

  
      UIWindow  *window = [[UIApplication sharedApplication] .delegate window];
    self.blockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.blockView.backgroundColor = [UIColor blackColor];
    self.blockView.alpha = 0.8;
    [window addSubview:self.blockView];
    
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-170, kScreenWidth, 250)];
    self.shareView.backgroundColor = [UIColor lightGrayColor];
    self.shareView.alpha = 1;
    [window addSubview:self.shareView];
    
    
    
    
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(70, 30, 60, 60);
    [weiboBtn setImage:[UIImage imageNamed:@"ic_com_sina_weibo_sdk_logo"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(SendRequest) forControlEvents:UIControlEventTouchUpInside];
    [ self.shareView addSubview:weiboBtn];
    
    
    
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(150, 30, 60, 60);
    [friendBtn setImage:[UIImage imageNamed:@"share_friend"] forState:UIControlStateNormal];
    [friendBtn addTarget:self action:@selector(sendAuthRequest) forControlEvents:UIControlEventTouchUpInside];
    
    [self.shareView addSubview:friendBtn];
    
    
    
    UIButton *circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    circleBtn.frame = CGRectMake(230, 30, 60, 60);
    [circleBtn setImage:[UIImage imageNamed:@"py_normal"] forState:UIControlStateNormal];
    [circleBtn addTarget:self action:@selector(lineTime) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:circleBtn];
    
    
    
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(20, 100, kScreenWidth-40, 44);
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(goBacks) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:removeBtn];
    
    
    [UIView  animateWithDuration:1.0 animations:^{
        
        self.shareView.frame = CGRectMake(0, kScreenWidth+100, kScreenHeight, 300);
        
    }];
    
    



}
-(void)lineTime{
//    WXMediaMessage *message = [WXMediaMessage message];
//    [message setThumbImage:[UIImage imageNamed:@"Shamrock.png"]];
//    WXImageObject *imageobject = [WXImageObject object];
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"Shamrock" ofType:@".png"];
//    imageobject.imageData = [NSData dataWithContentsOfFile:filePath];
//    message.mediaObject = imageobject;
//    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    req.scene = WXSceneTimeline;
//    [WXApi sendReq:req];
    
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = @"这是一次测试微信分享的内容";
    req.bText = YES;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];



}
-(void)goBacks{
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.blockView.alpha = 0.0;
        self.shareView.frame = CGRectMake(0, kScreenWidth+100, kScreenHeight, 200);
        
    }];
    [self.blockView removeFromSuperview];
    [self.shareView removeFromSuperview];
    
    
}
-(void)sendAuthRequest{
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = @"分享的内容";
    req.bText = YES;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
    
    [self goBacks];
    
    
}
-(void)SendRequest{
    
    [self goBacks];
    
//    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//    request.redirectURI = kAppRedirectURL;
//    request.scope = @"all";
//    request.userInfo = @{@"SSO_From": @"MangoViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}
//                         };
//    [WeiboSDK sendRequest:request];
//    WBProvideMessageForWeiboResponse *response = [WBProvideMessageForWeiboResponse responseWithMessage:[self messageToShare]];
//    [WeiboSDK sendResponse:response];
    
    
    
   	AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kAppRedirectURL;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    
    [WeiboSDK sendRequest:request];
    
}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
    GYRLog(@"%@",response);
}
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{

      GYRLog(@"%@",request);
    
    
}

- (WBMessageObject *)messageToShare
{
    
    WBMessageObject *message = [WBMessageObject message];
    message.text = @"这是一次测试微博分享的内容";
   
    
    
//    WBMessageObject *message = [WBMessageObject message];
//    WBImageObject *image = [WBImageObject object];
//    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ic_com_sina_weibo_sdk_logo@2x" ofType:@".png"]];
//    message.imageObject = image;
    
    
    
    return message;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
