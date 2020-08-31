//
//  RefundTicketVC.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/25.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "RefundTicketVC.h"
#import "RefundTicketApplyTableView.h"
#import "SimpleAlertView.h"
#import "PCHeader.h"
@interface RefundTicketVC ()

@property (nonatomic, strong) RefundTicketApplyTableView *applyTableView;



@property (nonatomic, strong) NSArray *arr;

@end

@implementation RefundTicketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel.type = @"3";
    [self.viewModel.refreshCommand execute:self.applyTableView];
    [self initView];
    [self bindViewModel];
}

- (void)initView {
    
    [self.view addSubview:self.applyTableView];
}

- (void)bindViewModel {
    self.viewModel.nav = self.navigationController;
    RAC(self, arr) = RACObserve(self.viewModel, selectArr);
}

- (void)setArr:(NSArray *)arr {
    self.applyTableView.viewModel = self.viewModel;
}

#pragma mark - Lazyload

- (RefundTicketApplyTableView *)applyTableView {
    if (!_applyTableView) {
        _applyTableView = [[RefundTicketApplyTableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    }
    return _applyTableView;
}

@end
