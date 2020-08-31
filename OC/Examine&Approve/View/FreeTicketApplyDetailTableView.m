//
//  FreeTicketApplyDetailTableView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/23.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "FreeTicketApplyDetailTableView.h"
#import "ApplyDetailTableView.h"
#import "PCHeader.h"
@interface FreeTicketApplyDetailTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *titleArr, *contentArr;

@property (nonatomic, strong) NSString *totalMoney, *ccStr;

@end

@implementation FreeTicketApplyDetailTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = 0;
    }
    return self;
}

- (void)setViewModel:(ApplyDetailViewModel *)viewModel {
    _viewModel = viewModel;
    NSArray *arr = [viewModel.ApproveInfo[@"eventContent"] mj_JSONObject];
    self.titleArr = [NSMutableArray arrayWithArray:@[@[@"审批编号：",@"审批类型：",@"所在部门：",@"申请事由：",@"限免次数：",@"期望交付：",@"备注："],@[@"审批流程"]]];
    self.contentArr = [NSMutableArray arrayWithArray:@[@[NSStringFormate(@"%@",viewModel.ApproveInfo[@"eventNo"]),arr.count?arr[0][@"FreeType"]:@"",@"所在部门",viewModel.ApproveInfo[@"remark"]?viewModel.ApproveInfo[@"remark"]:@"",arr.count?((![arr[0][@"FreeType"] isEqualToString:@"当天全免"])?arr[0][@"Quantity"]:@"不限次数"):@"",arr.count?arr[0][@"RequiredDate"]:@"",arr.count?arr[0][@"Remark"]:@""],@[@""]]];
    NSMutableArray *ccmArr = [NSMutableArray array];
    for (NSDictionary *dict in self.viewModel.ccList) {
        [ccmArr addObject:dict[@"approvePerson"]];
    }
    self.ccStr = [ccmArr componentsJoinedByString:@","];
    [self reloadData];
}

#pragma mark - UITableViewDelegate&Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.titleArr[section];
    if (arr.count == 1) {
        if ([arr[0] isEqualToString:@"审批流程"]) {
            return self.viewModel.approvalList.count;
        } else {
            return 1;
        }
    } else {
        return arr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr;
    NSString *contentStr;
    NSArray *arr = self.titleArr[indexPath.section];
    if (arr.count == 1) {
        titleStr = self.titleArr[indexPath.section][0];
        contentStr = self.contentArr[indexPath.section][0];
    } else {
        titleStr = self.titleArr[indexPath.section][indexPath.row];
        contentStr = self.contentArr[indexPath.section][indexPath.row];
    }
    if ([titleStr isEqualToString:@"审批流程"]) {
        static NSString *identifier = @"ApplyDetailApprovalCell";
        ApplyDetailApprovalCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ApplyDetailApprovalCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        cell.dict = self.viewModel.approvalList[indexPath.row];
        cell.topLine.hidden = !indexPath.row;
        cell.bottomLine.hidden = self.viewModel.approvalList.count == (indexPath.row+1);
        return cell;
    } else {
        static NSString *identifier = @"ApplyDetailTextCell";
        ApplyDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ApplyDetailTextCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        cell.titleLa.text = titleStr;
        cell.contentLa.text = NSStringFormate(@"%@",contentStr);
        return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr;
    NSArray *arr = self.titleArr[indexPath.section];
    if (arr.count == 1) {
        titleStr = self.titleArr[indexPath.section][0];
    } else {
        titleStr = self.titleArr[indexPath.section][indexPath.row];
    }
    if ([titleStr isEqualToString:@"审批流程"]) {
        return 80;
    } else {
        return 30;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 70;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 70;
    } else {
        return 10;
    }
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
        headView.backgroundColor = HEX_FFF;
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, Screen_Width, 44)];
        la.text = @"审批流程";
        la.textColor = HEX_999;
        la.font = [UIFont systemFontOfSize:14];
        [headView addSubview:la];
        return headView;
    } else if (section == 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 70)];
        headView.backgroundColor = HEX_FFF;
        UIImageView *userPortrait = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
        userPortrait.image = [UIImage imageNamed:@"approvalPortrait"];
        userPortrait.layer.cornerRadius = 20;
        userPortrait.layer.masksToBounds = YES;
        [headView addSubview:userPortrait];
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, Screen_Width-65-120, 15)];
        la.center = CGPointMake(la.center.x, userPortrait.center.y);
        la.text = NSStringFormate(@"%@",self.viewModel.ApproveInfo[@"eventTitle"]);
        la.textColor = HEX_333;
        la.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",la.font.fontName) size:14];
        [headView addSubview:la];
        UILabel *la2 = [UILabel new];
        NSString *state = NSStringFormate(@"%@",self.viewModel.ApproveInfo[@"state"]);
        la2.text = [state isEqualToString:@"0"]?@"  等待审批  ":([state isEqualToString:@"1"]?@"  审批中  ":([state isEqualToString:@"2"]?@"  审批完成  ":([state isEqualToString:@"3"]?@"  已驳回  ":@"  已撤销  ")));
        la2.font = SYS_FONT(12);
        la2.textColor = [state isEqualToString:@"0"]?HEX_999:([state isEqualToString:@"1"]?HexColor(@"#FDC472"):([state isEqualToString:@"2"]?HexColor(@"#2E96F7"):([state isEqualToString:@"3"]?HexColor(@"#FE7764"):HexColor(@"#BFBFBF"))));
        la2.layer.borderColor = ([state isEqualToString:@"0"]?HEX_999:([state isEqualToString:@"1"]?HexColor(@"#FDC472"):([state isEqualToString:@"2"]?HexColor(@"#2E96F7"):([state isEqualToString:@"3"]?HexColor(@"#FE7764"):HexColor(@"#BFBFBF"))))).CGColor;
        la2.layer.borderWidth = 1;
        la2.layer.cornerRadius = 3;
        la2.layer.masksToBounds = YES;
        [headView addSubview:la2];
        [la2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(la.mas_right).offset(5);
            make.centerY.equalTo(la);
            make.height.mas_equalTo(15);
        }];
        return headView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
        footerView.backgroundColor = HEX_FFF;
        UILabel *totalLa = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, Screen_Width-30, 44)];
        totalLa.text = NSStringFormate(@"  抄送：%@",self.ccStr);
        totalLa.font = SYS_FONT(14);
        totalLa.textColor = HEX_999;
        [footerView addSubview:totalLa];
        return footerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
