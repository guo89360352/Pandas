//
//  UIViewController+Common.m
//  Pandas
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 苹果IOS. All rights reserved.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)
-(void)showBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    


}
- (void)backBtn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
