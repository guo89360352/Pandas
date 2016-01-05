//
//  MainViewController.m
//  Pandas
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "MainModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部列表数据
@property (nonatomic, strong) NSMutableArray *listArray;
//推荐活动数据
@property (nonatomic, strong) NSMutableArray *activityArray;
//推荐专题数据
@property (nonatomic, strong) NSMutableArray *themeArray;

@property (nonatomic, strong) NSMutableArray *adArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    UIBarButtonItem *leftbtn=[[UIBarButtonItem alloc]initWithTitle:@"洛阳≡" style:UIBarButtonItemStylePlain target:self action:@selector(selectCity)];
    
    
    leftbtn.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=leftbtn;
    
    
    //导航栏上navigationItem
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(seachActivity)];
    //1.设置导航栏上的左右按钮  把leftBarButton设置为navigationItem左按钮
    
    rightBarButton.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    [self configTableViewHeaderView];
    
    //请求网络数据
    [self requestModel];
    
}
#pragma mark -- 设置tableview的代理方法UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.activityArray.count;
    }
    return self.themeArray.count;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;


}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MainTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableArray *array = [NSMutableArray new];
   array = self.listArray[indexPath.section];
    MainModel *model = array[indexPath.row];
    mainCell.model = model;
    
    return mainCell;
    
    
}



#pragma mark -- 设置tableview的代理方法UITableViewdelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 203;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 25;
}
//自定义分区头部
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    
    UIImageView *sectionView= [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-160, 5, 320, 16)];

    UIImage *image;
    if (section == 0) {
             image = [UIImage imageNamed:@"home_recommed_ac"];

    } else {

        image = [UIImage imageNamed:@"home_recommd_rc"];

    }
   
    sectionView.image = image;
    [view addSubview:sectionView];
    return view;


}

//自定义tableview的区头
-(void)configTableViewHeaderView{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 343)];
   // view.backgroundColor = [UIColor grayColor];
    
    UIScrollView *carourselView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 186)];
    //让scroll能够滑动
    carourselView.contentSize = CGSizeMake(self.adArray.count * [UIScreen mainScreen].bounds.size.width, 186);
    for (int i = 0; i < self.adArray.count ; i++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width, 186)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:self.adArray[i]] placeholderImage:nil];
        [carourselView addSubview:imageV];
    }
    [view addSubview:carourselView];
    self.tableView.tableHeaderView = view;
    
    
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * [UIScreen mainScreen].bounds.size.width / 4, 186, [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 4);
        NSString *imageStr = [NSString stringWithFormat:@"home_icon_%02d",i + 1];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(mainActivity:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        
    }
    
    UIButton *activitybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    activitybtn.frame = CGRectMake(0, 176+[UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.width / 4);
   
    [activitybtn setImage:[UIImage imageNamed:@"home_00"] forState:UIControlStateNormal];
    activitybtn.tag = 100;
    [activitybtn addTarget:self action:@selector(hotActivity:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:activitybtn];
    
    
    UIButton *themeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    themeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2, 176+[UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.width / 4);
    
    [themeBtn setImage:[UIImage imageNamed:@"home_01"] forState:UIControlStateNormal];
    themeBtn.tag = 101;
    [themeBtn addTarget:self action:@selector(hotActivity:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:themeBtn];
    

}
-(void)hotActivity:(UIButton *)btn{



}
-(void)mainActivity:(UIButton *)btn{
    
    
    
}

-(void)requestModel{
    
    NSString *urlString = @"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=1&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1";
    AFHTTPSessionManager *sessionManage = [AFHTTPSessionManager manager];
    sessionManage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManage GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%lld",downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"]integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            
            NSDictionary *dic = resultDic[@"success"];
            //推荐活动
            NSArray *acDataArray = dic[@"acData"];
            
            for (NSDictionary *dic00 in acDataArray) {
                MainModel *model = [[MainModel alloc] initWithDictionary:dic00];
                [self.activityArray addObject:model];
            }
            [self.listArray addObject:self.activityArray];
            //广告
            NSArray *adDataArray = dic[@"adData"];
            for (NSDictionary *dic01 in adDataArray) {
                [self.adArray addObject:dic01[@"url"]];
            }
            
            
            //推荐专题
            NSArray *rcDataArray = dic[@"rcData"];
            
            for (NSDictionary *dic02 in rcDataArray) {
                MainModel *model = [[MainModel alloc] initWithDictionary:dic02];
                [self.themeArray addObject:model];
            }
            [self.listArray addObject:self.themeArray];
            //刷新tableview数据
            [self.tableView reloadData];
            
            
            //拿到数据之后重新刷新
            [self configTableViewHeaderView];
            
            NSString *cityName = dic[@"cityName"];
            //以请求回来的导航栏按钮标题
            self.navigationItem.leftBarButtonItem.title = cityName;
            
        } else {
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
}

//懒加载
-(NSMutableArray *)listArray{
    
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}
-(NSMutableArray *)activityArray{
    if (_activityArray == nil) {
        self.activityArray = [NSMutableArray new];
    }
    return _activityArray;
}
-(NSMutableArray *)themeArray{
    if (_themeArray == nil) {
        self.themeArray = [NSMutableArray new];
    }
    return _themeArray;
    
}
-(NSMutableArray *)adArray{
    if (_adArray == nil) {
        self.adArray = [NSMutableArray new];
    }
    return _adArray;


}

-(void)selectCity{

}
-(void)seachActivity{
    
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
