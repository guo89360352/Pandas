//
//  MineViewController.m
//  Pandas
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "MineViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <MessageUI/MessageUI.h>
#import "WeiboSDK.h"
#import "ProgressHUD.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *headerImageButton;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic,strong)  UIView *shareView;
@property (nonatomic, strong) UILabel *nikeNameLabel;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    
    self.navigationController.navigationBar.barTintColor = mineColor;
   
   
    
     self.titleArray = [NSMutableArray arrayWithObjects:@"清除缓存",@"用户反馈",@"分享给朋友",@"给我评分",@"当前版本1.0" ,nil];
   
    self.imageArray = @[@"icon_ac",@"icon_msg",@"icon_ordered",@"icon_shop",@"icon_user"];
    [self setUpTableViewHeaderView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    SDImageCache *cashes = [SDImageCache sharedImageCache];
    NSInteger casheSize = [cashes getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除图片缓存大小(%.02fM)",(float)casheSize/1024/1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    

}

#pragma mark ------- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdent];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdent];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
       cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
       cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.titleArray[indexPath.row];

    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
        {
          
          
        GYRLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            [imageCache clearDisk];
            [self.titleArray replaceObjectAtIndex:0 withObject:@"清除图片缓存"];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        }
            break;
        case 1:
        {
            //发送邮件
            [self sendEmail];
            
            
        }
            break;
        case 2:
        {
            [self share];
        }
            break;
        case 3:
        {//评分
            NSString *str = [NSString stringWithFormat:
                             
                             @"itms-apps://itunes.apple.com/app"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

            
        }
            break;
        case 4:
        {
            [ProgressHUD show:@"O_O"];
            [self performSelector:@selector(checkAppVersion) withObject:nil afterDelay:2.0];
            
        }
            break;
       
            
        default:
            break;
    }

}

#pragma mark ------- UITableViewDelegate

#pragma mark ------- 自定义方法
-(void)share{
   self.window = [[UIApplication sharedApplication] .delegate window];
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-350, kScreenWidth, 350)];
    [self.window addSubview:self.shareView];
   self.shareView.backgroundColor = [UIColor cyanColor];
    
    
    
  
    
[UIView  animateWithDuration:1.0 animations:^{
    
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(20, 40, 35, 35);
    [weiboBtn setImage:[UIImage imageNamed:@"ic_com_sina_weibo_sdk_logo"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(SendRequest) forControlEvents:UIControlEventTouchUpInside];
    [ self.shareView addSubview:weiboBtn];
    
    
    
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(130, 40, 70, 70);
    [friendBtn setImage:[UIImage imageNamed:@"py_normal"] forState:UIControlStateNormal];
    [self.shareView addSubview:friendBtn];
    
    
    
    UIButton *circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    circleBtn.frame = CGRectMake(210, 40, 70, 70);
    [circleBtn setImage:[UIImage imageNamed:@"py_normal"] forState:UIControlStateNormal];
    [self.shareView addSubview:circleBtn];
    
    
    
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(20, 100, kScreenWidth-40, 44);
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(goBacks) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:removeBtn];

    
}];


}
-(void)goBacks{

    [self.shareView removeFromSuperview];
   

}
-(void)SendRequest{
   // self.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI =kAppRedirectURL;
    request.scope = @"all";
    request.userInfo = @{@"登陆":@"",@"":@"",@"":@"",@"":@"",@"":@"",};
    


}
-(void)checkAppVersion{

    [ProgressHUD showSuccess:@"=3="];

}
-(void)sendEmail{
    Class mailClass = NSClassFromString(@"MFMailComposeViewController");
    if (mailClass == nil) {
        if ([MFMailComposeViewController canSendMail]) {
            
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            //设置主题
            [picker setSubject:@"博客园-FlyElephant"];
            
            //设置收件人
            NSArray *toRecipients = [NSArray arrayWithObjects:@"1036956742@qq.com",
                                     nil];
            
            [picker setToRecipients:toRecipients];
            
            
            // 设置邮件发送内容
            NSString *emailBody = @"请留下你宝贵的意见";
            [picker setMessageBody:emailBody isHTML:NO];
            
            //邮件发送的模态窗口
            [self presentViewController:picker animated:NO completion:nil];

        }else{
        
            GYRLog(@"T_T");
        }
    }else {
    
    GYRLog(@"T_T");
    }
    
 }



-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: //取消
            NSLog(@"MFMailComposeResultCancelled-取消");
            break;
        case MFMailComposeResultSaved: // 保存
            NSLog(@"MFMailComposeResultSaved-保存邮件");
            break;
        case MFMailComposeResultSent: // 发送
            NSLog(@"MFMailComposeResultSent-发送邮件");
            break;
        case MFMailComposeResultFailed: // 尝试保存或发送邮件失败
            NSLog(@"MFMailComposeResultFailed: %@...",[error localizedDescription]);
            break;
    }
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];


}
-(void)setUpTableViewHeaderView{

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
    headView.backgroundColor = mineColor;
    self.tableView.tableHeaderView = headView;
    [headView addSubview:self.headerImageButton ];
    [headView addSubview:self.nikeNameLabel];
    
    


}

#pragma mark ------ 懒加载
-(UILabel *)nikeNameLabel{
    if (_nikeNameLabel == nil) {
        self.nikeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 75, kScreenWidth-200, 60)];
        self.nikeNameLabel.text = @"欢迎来到Pandas";
        self.nikeNameLabel.textColor = [UIColor whiteColor];
        self.nikeNameLabel.numberOfLines= 0;
        
    }
    return _nikeNameLabel;

}
-(UIButton *)headerImageButton{

    if (_headerImageButton == nil) {
        self.headerImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headerImageButton.frame = CGRectMake(20, 40, 130, 130);
        [self.headerImageButton setTitle:@"登陆/注册" forState:UIControlStateNormal];
        [self.headerImageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.headerImageButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        self.headerImageButton.layer.cornerRadius =65;
        [self.headerImageButton setBackgroundColor:[UIColor whiteColor]];
        self.headerImageButton.clipsToBounds = YES;
    
    }
    return _headerImageButton;
    

}
-(void)login{


}
-(UITableView *)tableView{

    if (_tableView == nil) {
        self.tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;

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
