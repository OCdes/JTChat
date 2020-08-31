//
//  MyApplyListVC.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/18.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "MyApplyListVC.h"
#import "MyApplyTableView.h"
#import "ApplyDetailVC.h"
#import "ScrollBtnView.h"
#import "FreeTicketApplyDetailVC.h"
#import "AdvanceApplyDetailVC.h"
#import "ExpenseApplyDetailVC.h"
#import "RefundDetailVC.h"
#import "DiscountApplyDetailVC.h"
#import "AskoffApprovalDetailVC.h"
#import "PCHeader.h"
@interface MyApplyListVC ()

@property (nonatomic, strong) MyApplyTableView *listTableView;

@property (nonatomic, strong) UIButton *searchBtn, *screenBtn;

@property (nonatomic, strong) ScrollBtnView *scrollBtnView;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation MyApplyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self bindViewModel];
}

- (void)initView {
    [self.view addSubview:self.scrollBtnView];
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.screenBtn];
    [self.view addSubview:self.listTableView];
    
}

- (void)bindViewModel {
    @weakify(self)
    [self.listTableView jt_addRefreshHeaderWithHandler:^{
        @strongify(self)
        [self.viewModel.refreshCommand execute:self.listTableView];
    }];
    [self.listTableView jt_startRefresh];
    
    RAC(self, dataArr) = RACObserve(self.viewModel, dataArr);
    [self.listTableView.tapRowSubject subscribeNext:^(id  _Nullable x) {
        ApplyDetailViewModel *model = [[ApplyDetailViewModel alloc] init];
        model.eventNo = x[@"eventNo"];
        model.type = self.viewModel.type;
        model.state = x[@"state"];
        [model.refreshSubject subscribeNext:^(id  _Nullable x) {
            [self.viewModel.refreshCommand execute:self.listTableView];
        }];
        if ([x[@"eventClassify"] isEqualToNumber:@(1)]) {//采购
            ApplyDetailVC *vc = [[ApplyDetailVC alloc] init];
            vc.viewModel = model;
            vc.title = @"申请详情";
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([x[@"eventClassify"] isEqualToNumber:@(2)]) {//报销
            ExpenseApplyDetailVC *vc = [[ExpenseApplyDetailVC alloc] init];
            vc.viewModel = model;
            vc.title = @"申请详情";
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([x[@"eventClassify"] isEqualToNumber:@(3)]) {//用款
            AdvanceApplyDetailVC *vc = [[AdvanceApplyDetailVC alloc] init];
            vc.viewModel = model;
            vc.title = @"申请详情";
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([x[@"eventClassify"] isEqualToNumber:@(4)]) {//免票
            FreeTicketApplyDetailVC *vc = [[FreeTicketApplyDetailVC alloc] init];
            vc.viewModel = model;
            vc.title = @"申请详情";
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([x[@"eventClassify"] isEqualToNumber:@(5)]) {//退票
            RefundDetailVC *vc = [[RefundDetailVC alloc] init];
            vc.viewModel = model;
            vc.title = @"申请详情";
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([x[@"eventClassify"] isEqualToNumber:@(6)]) {//打折
            DiscountApplyDetailVC *vc = [[DiscountApplyDetailVC alloc] init];
            vc.viewModel = model;
            vc.title = @"申请详情";
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([x[@"eventClassify"] isEqualToNumber:@(7)]) {//请假
            AskoffApprovalDetailVC *vc = [[AskoffApprovalDetailVC alloc] init];
            vc.viewModel = model;
            vc.title = @"申请详情";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    
    [self.scrollBtnView.tapSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.viewModel.screenType = NSStringFormate(@"%@",x);
        [self.viewModel.scrollCommand execute:nil];
    }];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    self.listTableView.dataArr = dataArr;
    if (self.viewModel.type == ApprovalLIistTypeApproval) {
        if ([self.viewModel.screenType isEqualToString:@"1"]) {
            [self.scrollBtnView relodaData:@[(self.viewModel.originArr.count - self.dataArr.count) ? NSStringFormate(@"待审批(%li)", (self.viewModel.originArr.count - self.dataArr.count)):@"待审批", self.dataArr.count? NSStringFormate(@"已审批(%li)",self.dataArr.count) : @"已审批"]];
        } else {
            [self.scrollBtnView relodaData:@[self.dataArr.count ? NSStringFormate(@"待审批(%li)", self.dataArr.count):@"待审批", (self.viewModel.originArr.count - self.dataArr.count)? NSStringFormate(@"已审批(%li)",(self.viewModel.originArr.count - self.dataArr.count)) : @"已审批"]];
        }
    } else {
        if ([self.viewModel.screenType isEqualToString:@"1"]) {
            [self.scrollBtnView relodaData:@[(self.viewModel.originArr.count - self.dataArr.count) ? NSStringFormate(@"未完成(%li)", (self.viewModel.originArr.count - self.dataArr.count)):@"未完成", self.dataArr.count? NSStringFormate(@"已完成(%li)",self.dataArr.count) : @"已完成"]];
        } else {
            [self.scrollBtnView relodaData:@[self.dataArr.count ? NSStringFormate(@"未完成(%li)", self.dataArr.count):@"未完成", (self.viewModel.originArr.count - self.dataArr.count)? NSStringFormate(@"已完成(%li)",(self.viewModel.originArr.count - self.dataArr.count)) : @"已完成"]];
        }
    }
    
    
}

- (void)searchBtnClicked:(UIButton *)btn {
    
}

- (void)screenBtnClicked:(UIButton *)btn {
    
}

#pragma mark - Lazyload

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(self.scrollBtnView.frame), Screen_Width/2., 44)];
        _searchBtn.title = @"    搜索";
        _searchBtn.image = @"search2";
        _searchBtn.backgroundColor = HexColor(@"#F9F9F9");
        _searchBtn.titleColor = HEX_333;
        _searchBtn.titleLabel.font = SYS_FONT(14);
        [_searchBtn addTarget:self action:@selector(searchBtnClicked:)];
    }
    return _searchBtn;
}

- (UIButton *)screenBtn {
    if (!_screenBtn) {
        _screenBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searchBtn.frame), self.searchBtn.frame.origin.y, self.searchBtn.frame.size.width, self.searchBtn.frame.size.height)];
        _screenBtn.title = @"    筛选";
        _screenBtn.image = @"screen2";
        _screenBtn.backgroundColor = HexColor(@"#F9F9F9");
        _screenBtn.titleColor = HEX_333;
        _screenBtn.titleLabel.font = SYS_FONT(14);
        [_screenBtn addTarget:self action:@selector(screenBtnClicked:)];
    }
    return _screenBtn;
}

- (MyApplyTableView *)listTableView {
    if (!_listTableView) {
        CGFloat vheight = self.view.frame.size.height;
        CGFloat y = CGRectGetMaxY(self.scrollBtnView.frame);
        _listTableView = [[MyApplyTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollBtnView.frame), Screen_Width, self.view.frame.size.height-64-CGRectGetMaxY(self.scrollBtnView.frame)) style:UITableViewStyleGrouped];
    }
    return _listTableView;
}

- (ScrollBtnView *)scrollBtnView {
    if (!_scrollBtnView) {
        _scrollBtnView = [[ScrollBtnView alloc] initOrderListWithFrame:CGRectMake(0, 0, Screen_Width, 45) titleArr:self.viewModel.type == ApprovalLIistTypeApproval ? @[@"未完成",@"已完成"] : @[@"待审批",@"已审批"]];
    }
    return _scrollBtnView;
}

@end
