//
//  ClassifyViewController.m
//  Pandas
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "ClassifyViewController.h"
#import "PullingRefreshTableView.h"
#import "GoodViewController.h"
#import "GoodActivityModel.h"
#import "GoodActivityTableViewCell.h"
#import "ActivityDetailViewController.h"
#import "VOSegmentedControl.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"




@interface ClassifyViewController ()<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;//请求的页码
}
@property(nonatomic,assign) BOOL refreshing;

@property (nonatomic, strong) PullingRefreshTableView *tableView;
//用来负责展示的数组
@property (nonatomic, strong) NSMutableArray *showDataArray;
//
@property (nonatomic, strong) NSMutableArray *showArray;
@property (nonatomic, strong) NSMutableArray *touristArray;
@property (nonatomic, strong) NSMutableArray *studyArray;
@property (nonatomic, strong) NSMutableArray *familyArray;
@property (nonatomic, strong) VOSegmentedControl *segementControl;
@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分类列表";
    [self showBackBtn];
    self.showArray = [NSMutableArray new];
    self.showDataArray = [NSMutableArray new];
    [self.view addSubview:self.segementControl];
    [self.view addSubview:self.tableView];
//    //第一次进入分类列表中，请求全部的接口数据
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tabBarController.tabBar.hidden = YES;
    
    
    
    
    [self getFourRequest];
    [self getRequestFamily];
    [self getRequestStudy];
    [self getRequestTourist];
//
//    //根据上一页选择的按钮，确定显示第几页数据
    [self showPreviousSelectButton];
  
    [self.tableView launchRefreshing];
    [self choseRequest];

    
}
//页面将要消失的时候
-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [ProgressHUD dismiss];

}
#pragma mark -----  UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodActivityTableViewCell *goodCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    GoodActivityModel *model = self.showDataArray[indexPath.row];
      NSLog(@"showData %@",self.showDataArray);
    goodCell.goodModel = model;
    return goodCell;
}



#pragma mark -----  UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodActivityModel *model = self.showDataArray[indexPath.row];
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *act = [main instantiateViewControllerWithIdentifier:@"miss"];
    
    //活动i
    act.activityId = model.activityId;
    [self.navigationController pushViewController:act animated:YES];


}


#pragma mark -----  PullingRefreshTableViewDelegate

//tableView上拉开始刷新的时候调用
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    _pageCount = 1;
    [self performSelector:@selector(getFourRequest) withObject:nil afterDelay:1.0];
    
}
//下拉
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.refreshing = NO;
    _pageCount+=1;
    [self performSelector:@selector(getFourRequest) withObject:nil afterDelay:1.0];
}



//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTool getsystemNewDate];
}

//手指拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
//手指结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.tableView tableViewDidEndDragging:scrollView];
    
}



#pragma mark -------- 自定义方法
-(void)choseRequest{

    switch (self.classifyType) {
        case ClassifyListTypeShowRepertoire:
        {
            [self getFourRequest];
            
        }
            break;
        case ClassifyListTypeTouristPlace:
        {
            [self getRequestTourist];
        }
            break;
            
        case ClassifyListTypeStudyPUZ:
        {
            
            [self getRequestStudy];
        }
            break;
            
        case ClassifyListTypeFamilyTravel:
        {
            [self getRequestFamily];
            
        }
            break;
            
            
        default:
            break;
    }
}
-(void)getRequestTourist{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    [ProgressHUD show:@"拼命加载中"];
    
    //typeid = 23 景点场馆
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%@&typeid=%@",Classify,@(1),@(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acArray = dict[@"acData"];
            for (NSDictionary *dic0 in acArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dic0];
                [self.touristArray addObject:model];
                
            }
        }
         [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error
                                ]];
        GYRLog(@"%@",error);
    }];
}
-(void)getRequestStudy{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中"];

    //typeid = 22 学习益智
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%@&typeid=%@",Classify,@(1),@(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        GYRLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acArray = dict[@"acData"];
            for (NSDictionary *dic0 in acArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dic0];
                [self.studyArray addObject:model];
                
            }
            
            
        }
        
       
         [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error
                                ]];
        GYRLog(@"%@",error);
    }];
    
   
    
}
-(void)getRequestFamily{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中"];

    //typeid = 21 亲子游戏
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%@&typeid=%@",Classify,@(1),@(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        GYRLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acArray = dict[@"acData"];
            for (NSDictionary *dic0 in acArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dic0];
                [self.familyArray addObject:model];
                
            }
            
            
        }
         [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error
                                ]];
        GYRLog(@"%@",error);
    }];

    
}
-(void)getFourRequest{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中"];
    //typeid = 6 演出剧目
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%@&typeid=%@",Classify,@(1),@(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        GYRLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        
        
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acArray = dict[@"acData"];
            for (NSDictionary *dic0 in acArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dic0];
                [self.showArray addObject:model];
                
            }
            NSLog(@"show =  %@",self.showArray);
          
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;
            [self.tableView reloadData];
                     }
         [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error
                                ]];
        GYRLog(@"%@",error);
    }];
    
    
   
}
-(void)showPreviousSelectButton{
    if (self.showDataArray.count > 0) {
        [self.showDataArray removeAllObjects];
    }

    switch (self.classifyType) {
        case ClassifyListTypeShowRepertoire:
        {
           

            self.showDataArray = self.showArray;
          
        }
            break;
        case ClassifyListTypeTouristPlace:
        {
            self.showDataArray = self.touristArray;
             NSLog(@"showData %@",self.showDataArray);
        }
            break;

        case ClassifyListTypeStudyPUZ:
        {
            
            self.showDataArray = self.studyArray;
             NSLog(@"showData %@",self.showDataArray);
        }
            break;

        case ClassifyListTypeFamilyTravel:
        {
            self.showDataArray = self.familyArray;
             NSLog(@"showData %@",self.showDataArray);
            
        }
            break;

            
        default:
            break;
    }
    [self.tableView reloadData];

}

- (void)loadData{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld",Classify,_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",downloadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        HWQLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acArray = dict[@"acData"];
            //  for (NSDictionary *acDic in acArray) {
            //                GoodActivityModel *model = [[GoodActivityModel alloc]initWithDictionary:acDic];
            if (self.refreshing) {
                if (self.showDataArray.count > 0) {
                    [self.showDataArray removeAllObjects];
                    
                }
                
            }
            for (NSDictionary *dic in acArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dic];
                [self.showDataArray addObject:model];
            }
            
            
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;
            [self.tableView reloadData];
            
        }else{
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
    
    //完成加载
    
    
}




#pragma mark -----  懒加载
-(VOSegmentedControl *)segementControl{

    if (_segementControl == nil) {
        self.segementControl = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"演出剧目"},@{VOSegmentText:@"景点场馆"},@{VOSegmentText:@"学习益智"},@{VOSegmentText:@"亲子游戏"}]];
        self.segementControl.contentStyle = VOContentStyleTextAlone;
          self.segementControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
          self.segementControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
         self.segementControl.selectedBackgroundColor =   self.segementControl.backgroundColor;
          self.segementControl.allowNoSelection = NO;
          self.segementControl.frame = CGRectMake(0, 0, kScreenWidth, 40);
        self.segementControl.indicatorThickness = 4;
        self.segementControl.selectedSegmentIndex = self.classifyType-1;
        [self.view addSubview:self.segementControl];

        [  self.segementControl setIndexChangeBlock:^(NSInteger index) {
            
            NSLog(@"1: block --> %@", @(index));
        }];

        [  self.segementControl addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];

    }
    return _segementControl;
}
- (IBAction)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    NSLog(@"%@: value --> %@",@(segmentCtrl.tag), @(segmentCtrl.selectedSegmentIndex));

    self.classifyType = segmentCtrl.selectedSegmentIndex;
    [self choseRequest];
}

-(PullingRefreshTableView *)tableView{

    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight-64-40) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight= 90;
        
    }

    return _tableView;
}
-(NSMutableArray *)showDataArray{
    if (_showDataArray == nil) {
        self.showDataArray = [NSMutableArray new];
    }
    return _showDataArray;
}
-(NSMutableArray *)showArray{
    if (_showArray == nil) {
        self.showArray = [NSMutableArray new];
    }
    return _showArray;


}
-(NSMutableArray *)touristArray{

    if (_touristArray  == nil) {
        self.touristArray = [NSMutableArray new];
    }
    return _touristArray;


}
-(NSMutableArray *)studyArray{

    if (_studyArray == nil) {
        self.studyArray = [NSMutableArray new];
    }
    return _studyArray;


}
-(NSMutableArray *)familyArray{

    if (_familyArray == nil) {
        self.familyArray = [NSMutableArray new];
    }
    return _familyArray;


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
