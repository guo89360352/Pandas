//
//  ActivityDetailViewController.m
//  Pandas
//  活动详情
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "UIViewController+Common.h"
#import "ActivityDetailView.h"
#import "AppDelegate.h"
#import "GoodActivityModel.h"


@interface ActivityDetailViewController ()
{
    NSString *_phoneNumber;
    
}

@property (strong, nonatomic) IBOutlet ActivityDetailView *activityDetailView;




@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    [self showBackBtn];
    
    //去地图页面
    //打电话
  // [self.activityDetailView.makeCallButton addTarget:self action:@selector(makeCallButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
    
    [self getModel];
    
    
}
#pragma mark ------------------  自定义方法
//地图
-(void)mapButtonAction:(UIButton *)btn{

}
//打电话
-(void)makeCallButtonAction:(UIButton *)btn{
    
     //程序外打电话，打完电话不返回当前应用程序
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneNumber]]];
    
    
    
    //程序内打电话，打完电话返回当前应用程序
    UIWebView *cellPhoneWebView = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneNumber]]] ;
    [cellPhoneWebView loadRequest:request];
    [self.view addSubview:cellPhoneWebView];
                             
    
    
    
    
    
}

-(void)getModel{

    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:@"%@&id=%@",kActivity,self.activityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"]&&code == 0) {
            NSDictionary *successDic = dic[@"success"];
            self.activityDetailView.dataDic = successDic;
             _phoneNumber = dic[@"tel"];
            
        }else {
        
        
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];


}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
