//
//  PurchaseApplyVC.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/11.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "PurchaseApplyVC.h"
#import "PurchaseApplyTableView.h"
#import "PCHeader.h"
@interface PurchaseApplyVC ()

@property (nonatomic, strong) PurchaseApplyTableView *applyTableView;



@property (nonatomic, strong) NSArray *arr;

@end

@implementation PurchaseApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel.requestType = @"1";
    self.viewModel.nav = self.navigationController;
    [self.viewModel.refreshCommand execute:self.applyTableView];
    [self initView];
    [self bindViewModel];
}

- (void)initView {
    
    [self.view addSubview:self.applyTableView];
}

- (void)bindViewModel {
    
    RAC(self, arr) = RACObserve(self.viewModel, ccList);
}

- (void)setArr:(NSArray *)arr {
    self.applyTableView.viewModel = self.viewModel;
}

#pragma mark - Lazyload

- (PurchaseApplyTableView *)applyTableView {
    if (!_applyTableView) {
        _applyTableView = [[PurchaseApplyTableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    }
    return _applyTableView;
}

@end
