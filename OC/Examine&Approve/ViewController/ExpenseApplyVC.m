//
//  ExpenseApplyVC.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/24.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "ExpenseApplyVC.h"
#import "ExpenseApplyTableView.h"
#import "PCHeader.h"
@interface ExpenseApplyVC ()

@property (nonatomic, strong) ExpenseApplyTableView *applyTableView;

@property (nonatomic, strong) NSArray *arr, *typeArr;

@end

@implementation ExpenseApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel.requestType = @"2";
    //    [self.viewModel.refreshCommand execute:self.viewModel.requestType];
    [self.viewModel.refreshCommand execute:self.applyTableView];
    [self initView];
    [self bindViewModel];
}

- (void)initView {
    
    [self.view addSubview:self.applyTableView];
}

- (void)bindViewModel {
    self.viewModel.nav = self.navigationController;
    RAC(self, typeArr) = RACObserve(self.viewModel, approvalTypeList);
    RAC(self, arr) = RACObserve(self.viewModel, ccList);
}

- (void)setTypeArr:(NSArray *)typeArr {
    self.applyTableView.viewModel = self.viewModel;
}

- (void)setArr:(NSArray *)arr {
    self.applyTableView.viewModel = self.viewModel;
}

#pragma mark - Lazyload

- (ExpenseApplyTableView *)applyTableView {
    if (!_applyTableView) {
        _applyTableView = [[ExpenseApplyTableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    }
    return _applyTableView;
}


@end
