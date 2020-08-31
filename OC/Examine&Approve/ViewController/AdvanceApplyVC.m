//
//  AdvanceApplyVC.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/24.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "AdvanceApplyVC.h"
#import "AdvanceApplyTableView.h"
#import "PCHeader.h"
@interface AdvanceApplyVC ()

@property (nonatomic, strong) AdvanceApplyTableView *applyTableView;



@property (nonatomic, strong) NSArray *arr;

@end

@implementation AdvanceApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel.requestType = @"3";
    [self.viewModel.refreshCommand execute:self.applyTableView];
    [self initView];
    [self bindViewModel];
}

- (void)initView {
    
    [self.view addSubview:self.applyTableView];
}

- (void)bindViewModel {
    self.viewModel.nav = self.navigationController;
    RAC(self, arr) = RACObserve(self.viewModel, ccList);
}

- (void)setArr:(NSArray *)arr {
    self.applyTableView.viewModel = self.viewModel;
}

#pragma mark - Lazyload

- (AdvanceApplyTableView *)applyTableView {
    if (!_applyTableView) {
        _applyTableView = [[AdvanceApplyTableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    }
    return _applyTableView;
}

@end
