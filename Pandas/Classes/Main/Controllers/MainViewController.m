//
//  MainViewController.m
//  Pandas
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}
#pragma mark -- 设置tableview的代理方法UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 20;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MainTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return mainCell;


}



#pragma mark -- 设置tableview的代理方法UITableViewdelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 203;

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
