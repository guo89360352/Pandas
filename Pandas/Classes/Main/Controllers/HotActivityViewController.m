//
//  HotActivityViewController.m
//  Pandas
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "HotActivityViewController.h"
#import "UIViewController+Common.h"
#import "PullingRefreshTableView.h"
#import "ActivityDetailViewController.h"
#import "HotActivityTableViewCell.h"
#import "HotActivityModel.h"
#import "ActivityThemeView.h"
#import "ThemeDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
@interface HotActivityViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
@property(nonatomic,assign) BOOL refreshing;
@property(nonatomic,strong) PullingRefreshTableView *tableView;
@property(nonatomic,strong) NSMutableArray *listArray;

@end

@implementation HotActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"热门活动";
    [self showBackBtn];
    [self.view addSubview:self.tableView];
    
    //    self.tableView.tableFooterView = [[UIView alloc]init];
 
    [self.tableView registerNib:[UINib nibWithNibName:@"HotActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
    [self.tableView launchRefreshing];

}
#pragma mark-----------------UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotActivityTableViewCell *goodCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    HotActivityModel *model = self.listArray[indexPath.row];
    goodCell.hotModel = model;
    return goodCell;
}

#pragma mark----------------UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HotActivityModel *model = self.listArray[indexPath.row];
    ThemeDetailViewController *theme =[[ThemeDetailViewController alloc] init];
    theme.themeId = model.activityId;
   
    
    //活动i
    theme.themeId = model.activityId;
    [self.navigationController pushViewController:theme animated:YES];
    
    
    
    
    
}

#pragma mark----------PullingRefreshTableViewDelegate
//tableView上拉开始刷新的时候调用
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = NO;
    [self performSelector:@selector(requestModel) withObject:nil afterDelay:1.0];
    
}
//下拉
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(requestModel) withObject:nil afterDelay:1.0];
}



//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTool getsystemNewDate];
}

#pragma mark---------网络请求
-(void)requestModel{
    
    
    AFHTTPSessionManager *sessionManage = [AFHTTPSessionManager manager];
    sessionManage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManage GET:kHotActivity parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        GYRLog(@"%lld",downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"]integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            
            NSDictionary *dic = responseObject;
            NSString *status = dic[@"status"];
            NSInteger code = [dic[@"code"] integerValue];
            self.listArray = [NSMutableArray new];
            if ([status isEqualToString:@"success"] && code == 0) {
                NSDictionary *dict = dic[@"success"];
                NSArray *acArray = dict[@"rcData"];
                for (NSDictionary *acDic in acArray) {
                    HotActivityModel *model = [[HotActivityModel alloc]initWithDictionary:acDic];
                    [self.listArray addObject:model];
                 
                }
                [self.tableView tableViewDidFinishedLoading];
                self.tableView.reachedTheEnd = NO;
                [self.tableView reloadData];
                
            
            }
        }
            
      //   GYRLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        GYRLog(@"%@",error);
    }];
    
    
}

#pragma mark---------scrollViewDid

//手指拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
//手指结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.tableView tableViewDidEndDragging:scrollView];
    
}

#pragma mark-------------LazyLoading
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) pullingDelegate:self];
        self.tableView.rowHeight = 150;
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
