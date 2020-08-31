//
//  AskoffApprovalDetailVC.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/27.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "AskoffApprovalDetailVC.h"
#import "AskoffApprovalDetailTableView.h"
#import "GeneralWarningAlertView.h"
#import "PCHeader.h"
@interface AskoffApprovalDetailVC ()



@property (nonatomic, strong) AskoffApprovalDetailTableView *detailTableView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation AskoffApprovalDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    [self bindViewModel];
}

- (void)initView {
    
    [self.view addSubview:self.detailTableView];
    NSArray *titleArr;
    if (self.viewModel.type == ApprovalLIistTypeApply) {
        titleArr = @[@"催办",@"撤销",@"重提"];
    } else if (self.viewModel.type == ApprovalLIistTypeApproval) {
        titleArr = @[@"同意",@"驳回",@"转审"];
    } else if (self.viewModel.type == ApprovalLIistTypeCC) {
        titleArr = @[];
    }
    CGFloat width = Screen_Width/3.;
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.detailTableView.frame), Screen_Width, 50)];
    for (int i = 0; i < titleArr.count; i ++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*width, 0, width, 50)];
        btn.titleLabel.font = SYS_FONT(16);
        btn.titleColor = HEX_333;
        btn.title = NSStringFormate(@"  %@",titleArr[i]);
        btn.image = titleArr[i];
        [btn addTarget:self action:@selector(btnClicked:)];
        LineView *line = [[LineView alloc] init];
        line.frame = CGRectMake(0, 0, width, 1);
        [btn addSubview:line];
        [self.bottomView addSubview:btn];
    }
    self.bottomView.hidden = YES;
    [self.view addSubview:self.bottomView];
}

- (void)btnClicked:(UIButton *)btn {
    if ([btn.title isEqualToString:@"  撤销"]) {
        GeneralWarningAlertView *alertView = [[GeneralWarningAlertView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width-60, 191)];
        alertView.titleStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
        alertView.contentStr = [[NSMutableAttributedString alloc] initWithString:@"是否要撤销当前申请"];
        [alertView animation];
        [alertView.sureSubject subscribeNext:^(id  _Nullable x) {
            [self.viewModel.withdrawCommand execute:nil];
        }];
    } else if ([btn.title isEqualToString:@"  催办"]) {
        
    } else if ([btn.title isEqualToString:@"  重提"]) {
        GeneralWarningAlertView *alertView = [[GeneralWarningAlertView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width-60, 191)];
        alertView.titleStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
        alertView.contentStr = [[NSMutableAttributedString alloc] initWithString:@"是否要重新提交当前申请"];
        [alertView animation];
        [alertView.sureSubject subscribeNext:^(id  _Nullable x) {
            [self.viewModel.resubmitCommand execute:nil];
        }];
    } else if ([btn.title isEqualToString:@"  同意"]) {
        GeneralWarningAlertView *alertView = [[GeneralWarningAlertView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width-60, 191)];
        alertView.titleStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
        alertView.contentStr = [[NSMutableAttributedString alloc] initWithString:@"是否要同意当前申请"];
        [alertView animation];
        [alertView.sureSubject subscribeNext:^(id  _Nullable x) {
            [self.viewModel.setStateCommand execute:@(1)];
        }];
    } else if ([btn.title isEqualToString:@"  驳回"]) {
        GeneralWarningAlertView *alertView = [[GeneralWarningAlertView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width-60, 191)];
        alertView.titleStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
        alertView.contentStr = [[NSMutableAttributedString alloc] initWithString:@"驳回后，审批流程将终止"];
        [alertView animation];
        [alertView.sureSubject subscribeNext:^(id  _Nullable x) {
            [self.viewModel.setStateCommand execute:@(2)];
        }];
    } else if ([btn.title isEqualToString:@"  转审"]) {
        GeneralWarningAlertView *alertView = [[GeneralWarningAlertView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width-60, 191)];
        alertView.titleStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
        alertView.contentStr = [[NSMutableAttributedString alloc] initWithString:@"是否要转审当前申请"];
        [alertView animation];
        [alertView.sureSubject subscribeNext:^(id  _Nullable x) {
            //            [self.viewModel.setStateCommand execute:@(3)];
        }];
    }
    
}

- (void)bindViewModel {
    
    RAC(self,dataArr) = RACObserve(self.viewModel, dataArr);
    @weakify(self);
    [self.detailTableView jt_addRefreshHeaderWithHandler:^{
        @strongify(self);
        [self.viewModel.refreshCommand execute:self.detailTableView];
    }];
    [self.detailTableView jt_startRefresh];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    self.detailTableView.frame = CGRectMake(0, 0, Screen_Width, (self.viewModel.type == ApprovalLIistTypeCC || [self.viewModel.state isEqualToString:@"0"]) ? (self.view.frame.size.height-99) : (self.view.frame.size.height));
    self.detailTableView.viewModel = self.viewModel;
    if (self.viewModel.type == ApprovalLIistTypeApply) {
        if ([self.viewModel.ApproveInfo[@"state"] integerValue] >= 2) {
            self.detailTableView.frame = CGRectMake(0, 0, Screen_Width, (self.view.frame.size.height));
            self.bottomView.hidden = YES;
        } else {
            self.detailTableView.frame = CGRectMake(0, 0, Screen_Width, (self.view.frame.size.height-99));
            self.bottomView.hidden = NO;
            self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.detailTableView.frame), Screen_Width, 50);
        }
    } else if (self.viewModel.type == ApprovalLIistTypeCC) {
        self.detailTableView.frame = CGRectMake(0, 0, Screen_Width, (self.view.frame.size.height));
        self.bottomView.hidden = YES;
    } else {
        if ([self.viewModel.Lock isEqualToString:@"1"]) {
            self.detailTableView.frame = CGRectMake(0, 0, Screen_Width, (self.view.frame.size.height));
            self.bottomView.hidden = YES;
        } else {
            self.detailTableView.frame = CGRectMake(0, 0, Screen_Width, (self.view.frame.size.height-99));
            self.bottomView.hidden = NO;
            self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.detailTableView.frame), Screen_Width, 50);
        }
    }
    
}

#pragma mark - Lazyload

- (AskoffApprovalDetailTableView *)detailTableView {
    if (!_detailTableView) {
        _detailTableView = [[AskoffApprovalDetailTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    return _detailTableView;
}

@end
