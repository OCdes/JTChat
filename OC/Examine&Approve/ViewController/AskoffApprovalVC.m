//
//  AskoffApprovalVC.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/26.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "AskoffApprovalVC.h"
#import "AskoffApprovalTableView.h"
#import "PCHeader.h"
@interface AskoffApprovalVC ()

@property (nonatomic, strong) AskoffApprovalTableView *applyTableView;



@property (nonatomic, strong) NSArray *arr, *typeArr;

@end

@implementation AskoffApprovalVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel.requestType = @"7";
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

- (AskoffApprovalTableView *)applyTableView {
    if (!_applyTableView) {
        _applyTableView = [[AskoffApprovalTableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    }
    return _applyTableView;
}

@end
