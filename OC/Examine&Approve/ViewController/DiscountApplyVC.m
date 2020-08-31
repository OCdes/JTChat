//
//  DiscountApplyVC.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/25.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "DiscountApplyVC.h"
#import "DiscountApplyTableView.h"
#import "PCHeader.h"
@interface DiscountApplyVC ()

@property (nonatomic, strong) DiscountApplyTableView *applyTableView;



@property (nonatomic, strong) NSArray *arr;

@end

@implementation DiscountApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel.type = @"4";
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

- (DiscountApplyTableView *)applyTableView {
    if (!_applyTableView) {
        _applyTableView = [[DiscountApplyTableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    }
    return _applyTableView;
}

@end
