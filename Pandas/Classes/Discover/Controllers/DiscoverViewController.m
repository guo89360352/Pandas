//
//  DiscoverViewController.m
//  Pandas
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewCell.h"
#import "PullingRefreshTableView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
#import "DiscoverModel.h"
#import "GoodActivityModel.h"
#import "ActivityDetailViewController.h"


@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, strong) NSMutableArray *gouwuArray;
@property (nonatomic, strong) NSMutableArray *likeArray;

@property (nonatomic, assign) BOOL refreshing;

@end

@implementation DiscoverViewController
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
     self.tabBarController.tabBar.hidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.allArray = [NSMutableArray new];
    self.gouwuArray = [NSMutableArray new];
    self.likeArray = [NSMutableArray new];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.rowHeight = 95;
     self.navigationController.navigationBar.barTintColor = mineColor;
  
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoverTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView launchRefreshing];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [ProgressHUD dismiss];
    
    
}
#pragma mark -----  UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.likeArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellIdent = @"cell";
    DiscoverTableViewCell *goodCell = [self.tableView dequeueReusableCellWithIdentifier:cellIdent forIndexPath:indexPath];;
    
    if (goodCell == nil) {
        goodCell = [[DiscoverTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdent];
    }
    
    goodCell.model = self.likeArray[indexPath.row];
    
    
    return goodCell;
}



#pragma mark -----  UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodActivityModel *model = self.likeArray[indexPath.row];
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *activity = [main instantiateViewControllerWithIdentifier:@"miss"];
    activity.activityId = model.activityId;
    [self.navigationController pushViewController:activity animated:NO];
    
    
}
#pragma mark   -------- PullingRefrishing

-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(getRequest) withObject:nil afterDelay:1.0];
    
}

-(NSDate *)pullingTableViewRefreshingFinishedDate{
    
    return [HWTool getsystemNewDate];
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
    
    
}
#pragma mark ----- 自定义方法

-(void)getRequest{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [ProgressHUD show:@"拼命加载中。。。"];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:kDiscover parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSString *code = dic[@"code"] ;
        if ([status isEqualToString:@"success"] &&[ code integerValue]== 0) {
            
            NSDictionary *success = dic[@"success"];
  //        NSArray *gouwu = success[@"gouwu"];
            NSArray *like = success[@"like"];
            if (self.refreshing) {
                if (self.likeArray.count>0) {
                    [self.likeArray removeAllObjects];
                }
            }
            
            for (NSDictionary *dic0 in like) {
                DiscoverModel *model = [[DiscoverModel alloc] initWithDic:dic0];
                [self.likeArray addObject:model];
            }
            
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;
            [self.tableView reloadData];
            
            
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // [ProgressHUD showError:error];
    }];
    
    
}


#pragma  mark --------懒加载

-(UITableView *)tableView{
    
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) pullingDelegate:self];
        self.tableView.delegate = self;
        [self.tableView setHeaderOnly:YES];
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
