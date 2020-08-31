//
//  OCBaseViewController.m
//  Swift-jtyh
//
//  Created by LJ on 2020/6/3.
//  Copyright © 2020 WanCai. All rights reserved.
//

#import "OCBaseViewController.h"
#import "PCHeader.h"
#import "OCWaterMarkView.h"
@interface OCBaseViewController ()

@property (nonatomic, strong) OCWaterMarkView *waterV;

@end

@implementation OCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,40)];
    [self.backBtn setImage:[UIImage imageNamed:@"whitNavBack"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,40)];
    [self.closeBtn setImage:[UIImage imageNamed:@"backToHome"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    UIBarButtonItem *backToHomeItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeBtn];
    
    if (self.navigationController.viewControllers.count>1) {
        self.navigationItem.leftBarButtonItems = @[ backItem];
    }
    if (self.navigationController.viewControllers.count > 2) {
        self.navigationItem.leftBarButtonItems = @[ backItem,backToHomeItem];
    }
    
    self.waterV = [[OCWaterMarkView alloc] initWithFrame:self.view.bounds text:emp_code ];
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closedBtnClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.waterV];
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
