//
//  ApplyApprovalVC.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/18.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "ApplyApprovalVC.h"
#import "TopBottomBtn.h"
#import "MyApplyListVC.h"
#import "PurchaseApplyVC.h"
#import "FreeTicketApplyVC.h"
#import "AdvanceApplyVC.h"
#import "ExpenseApplyVC.h"
#import "RefundTicketVC.h"
#import "DiscountApplyVC.h"
#import "AskoffApprovalVC.h"
#import "ApplyApprovalViewModel.h"
#import "ApplyDetailVC.h"
#import "ExpenseApplyDetailVC.h"
#import "AdvanceApplyDetailVC.h"
#import "FreeTicketApplyDetailVC.h"
#import "RefundDetailVC.h"
#import "DiscountApplyDetailVC.h"
#import "AskoffApprovalDetailVC.h"
#import "PCHeader.h"
@interface ApplyApprovalVC ()

@property (nonatomic, strong) TopBottomBtn *myApplyBtn, *myApprovalBtn, *myCCBtn;

@property (nonatomic, strong) ApplyApprovalViewModel *viewModel;

@end

@implementation ApplyApprovalVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.refreshCommand execute:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [[ApplyApprovalViewModel alloc] init];
    self.title = @"审批";
    [self initView];
    [self bindViewModel];
}

- (void)initView {
    [self.view addSubview:self.myApplyBtn];
    [self.view addSubview:self.myApprovalBtn];
    [self.view addSubview:self.myCCBtn];
    
    LineView *line = [[LineView alloc] init];
    line.frame = CGRectMake(0, CGRectGetMaxY(self.myApplyBtn.frame), Screen_Width, 10);
    [self.view addSubview:line];
    
    LineView *line2 = [[LineView alloc] init];
    line2.backgroundColor = HexColor(@"#0367F1");
    line2.frame = CGRectMake(15, CGRectGetMaxY(line.frame) + 16, 4, 14);
    [self.view addSubview:line2];
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line2.frame)+10, 0, 120, 44)];
    la.center = CGPointMake(la.center.x, line2.center.y);
    la.text = @"审批类型";
    la.textColor = HEX_333;
    la.font = SYS_FONT(16);
    [self.view addSubview:la];
    LineView *line3 = [[LineView alloc] init];
    line3.frame = CGRectMake(15, CGRectGetMaxY(la.frame), Screen_Width-30, 1);
    [self.view addSubview:line3];
    
    NSInteger rowNum = 4;
    NSArray *arr = @[@"采购",@"报销",@"用款",@"退票",@"免票",@"打折",@"请假"];
    NSArray *imgarr = @[@"caigou",@"baoxiao",@"yongkuan",@"tuifei",@"mianpiao",@"dazhe",@"qingjia"];
    CGFloat width = Screen_Width/rowNum;
    CGFloat height = Screen_Width/rowNum* 1.2;
    for (int i = 0 ; i < arr.count; i ++) {
        TopBottomBtn *btn = [[TopBottomBtn alloc] initWithFrame:CGRectMake(i%rowNum*width, CGRectGetMaxY( line3.frame) + i/rowNum*height, width, height)];
        //        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.title = arr[i];
        [btn setImage:[UIImage imageNamed:imgarr[i]] forState:UIControlStateNormal];
        btn.titleLabel.font = SYS_FONT(12);
        btn.titleColor = HEX_333;
        [btn addTarget:self action:@selector(itemBtnClicked:)];
        [self.view addSubview:btn];
    }
}

- (void)bindViewModel {
    RAC(self.myApprovalBtn, num) = RACObserve(self.viewModel, num);
}

- (void)myApplyBtnClicked:(UIButton *)btn {
    MyApplyListViewModel *model = [[MyApplyListViewModel alloc] init];
    model.type = ApprovalLIistTypeApply;
    MyApplyListVC *vc = [[MyApplyListVC alloc] init];
    vc.viewModel = model;
    vc.title = @"我发起的";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)myApprovalBtnClicked:(UIButton *)btn {
    MyApplyListViewModel *model = [[MyApplyListViewModel alloc] init];
    model.type = ApprovalLIistTypeApproval;
    MyApplyListVC *vc = [[MyApplyListVC alloc] init];
    vc.viewModel = model;
    vc.title = @"我审批的";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)myCCBtnClicked:(UIButton *)btn {
    MyApplyListViewModel *model = [[MyApplyListViewModel alloc] init];
    model.type = ApprovalLIistTypeCC;
    MyApplyListVC *vc = [[MyApplyListVC alloc] init];
    vc.viewModel = model;
    vc.title = @"抄送我的";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)itemBtnClicked:(UIButton *)btn {
    ApplyDetailViewModel *dmodel = [[ApplyDetailViewModel alloc] init];
    if ([btn.title isEqualToString:@"采购"]) {
        PurchaseApplyViewModel *model = [[PurchaseApplyViewModel alloc] init];
        [model.refreshSubject subscribeNext:^(id  _Nullable x) {
            dmodel.eventNo = x[@"approveEventNo"];
            dmodel.type = 0;
            ApplyDetailVC *vc = [[ApplyDetailVC alloc] init];
            vc.viewModel = dmodel;
            vc.title = @"申请详情";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        PurchaseApplyVC *vc = [[PurchaseApplyVC alloc] init];
        vc.title = btn.title;
        vc.viewModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([btn.title isEqualToString:@"免票"]) {
        PurchaseApplyViewModel *model = [[PurchaseApplyViewModel alloc] init];
        [model.refreshSubject subscribeNext:^(id  _Nullable x) {
            dmodel.eventNo = x[@"approveEventNo"];
            dmodel.type = 0;
            FreeTicketApplyDetailVC *vc = [[FreeTicketApplyDetailVC alloc] init];
            vc.viewModel = dmodel;
            vc.title = @"申请详情";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        FreeTicketApplyVC *vc = [[FreeTicketApplyVC alloc] init];
        vc.viewModel = model;
        vc.title = btn.title;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([btn.title isEqualToString:@"用款"]) {
        PurchaseApplyViewModel *model = [[PurchaseApplyViewModel alloc] init];
        [model.refreshSubject subscribeNext:^(id  _Nullable x) {
            dmodel.eventNo = x[@"approveEventNo"];
            dmodel.type = 0;
            AdvanceApplyDetailVC *vc = [[AdvanceApplyDetailVC alloc] init];
            vc.viewModel = dmodel;
            vc.title = @"申请详情";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        AdvanceApplyVC *vc = [[AdvanceApplyVC alloc] init];
        vc.viewModel = model;
        vc.title = btn.title;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([btn.title isEqualToString:@"报销"]) {
        PurchaseApplyViewModel *model = [[PurchaseApplyViewModel alloc] init];
        [model.refreshSubject subscribeNext:^(id  _Nullable x) {
            dmodel.eventNo = x[@"approveEventNo"];
            dmodel.type = 0;
            ExpenseApplyDetailVC *vc = [[ExpenseApplyDetailVC alloc] init];
            vc.viewModel = dmodel;
            vc.title = @"申请详情";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        ExpenseApplyVC *vc = [[ExpenseApplyVC alloc] init];
        vc.viewModel = model;
        vc.title = btn.title;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([btn.title isEqualToString:@"退票"]) {
        RefundAndDisconutApplyViewModel *model = [[RefundAndDisconutApplyViewModel alloc] init];
        [model.refreshSubject subscribeNext:^(id  _Nullable x) {
            dmodel.eventNo = x[@"approveEventNo"];
            dmodel.type = 0;
            RefundDetailVC *vc = [[RefundDetailVC alloc] init];
            vc.viewModel = dmodel;
            vc.title = @"申请详情";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        RefundTicketVC *vc = [[RefundTicketVC alloc] init];
        vc.viewModel = model;
        vc.title = btn.title;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([btn.title isEqualToString:@"打折"]) {
        RefundAndDisconutApplyViewModel *model = [[RefundAndDisconutApplyViewModel alloc] init];
        [model.refreshSubject subscribeNext:^(id  _Nullable x) {
            dmodel.eventNo = x[@"approveEventNo"];
            dmodel.type = 0;
            DiscountApplyDetailVC *vc = [[DiscountApplyDetailVC alloc] init];
            vc.viewModel = dmodel;
            vc.title = @"申请详情";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        DiscountApplyVC *vc = [[DiscountApplyVC alloc] init];
        vc.viewModel = model;
        vc.title = btn.title;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([btn.title isEqualToString:@"请假"]) {
        PurchaseApplyViewModel *model = [[PurchaseApplyViewModel alloc] init];
        [model.refreshSubject subscribeNext:^(id  _Nullable x) {
            dmodel.eventNo = x[@"approveEventNo"];
            dmodel.type = 0;
            AskoffApprovalDetailVC *vc = [[AskoffApprovalDetailVC alloc] init];
            vc.viewModel = dmodel;
            vc.title = @"申请详情";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        AskoffApprovalVC *vc = [[AskoffApprovalVC alloc] init];
        vc.viewModel = model;
        vc.title = btn.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Lazyload

- (TopBottomBtn *)myApplyBtn {
    if (!_myApplyBtn) {
        _myApplyBtn = [[TopBottomBtn alloc] initWithFrame:CGRectMake(Screen_Width/16., 0, Screen_Width/4., Screen_Width*0.3)];
        [_myApplyBtn setTitle:@"我发起的" forState:UIControlStateNormal];
        [_myApplyBtn setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
        _myApplyBtn.titleLabel.font = SYS_FONT(12);
        _myApplyBtn.titleColor = HEX_333;
        [_myApplyBtn addTarget:self action:@selector(myApplyBtnClicked:)];
    }
    return _myApplyBtn;
}

- (TopBottomBtn *)myApprovalBtn {
    if (!_myApprovalBtn) {
        _myApprovalBtn = [[TopBottomBtn alloc] initWithFrame:CGRectMake(Screen_Width/4.+Screen_Width/8., 0, Screen_Width/4., Screen_Width*0.3)];
        [_myApprovalBtn setTitle:@"我审批的" forState:UIControlStateNormal];
        [_myApprovalBtn setImage:[UIImage imageNamed:@"shenpi"] forState:UIControlStateNormal];
        _myApprovalBtn.titleColor = HEX_333;
        _myApprovalBtn.titleLabel.font = SYS_FONT(12);
        [_myApprovalBtn addTarget:self action:@selector(myApprovalBtnClicked:)];
    }
    return _myApprovalBtn;
}

- (TopBottomBtn *)myCCBtn {
    if (!_myCCBtn) {
        _myCCBtn = [[TopBottomBtn alloc] initWithFrame:CGRectMake(Screen_Width/2.+Screen_Width*3/16., 0, Screen_Width/4., Screen_Width*0.3)];
        [_myCCBtn setTitle:@"抄送我的" forState:UIControlStateNormal];
        [_myCCBtn setImage:[UIImage imageNamed:@"wofaqide"] forState:UIControlStateNormal];
        _myCCBtn.titleColor = HEX_333;
        _myCCBtn.titleLabel.font = SYS_FONT(12);
        [_myCCBtn addTarget:self action:@selector(myCCBtnClicked:)];
    }
    return _myCCBtn;
}

@end
