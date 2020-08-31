//
//  ApplyDetailTableView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/18.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "ApplyDetailTableView.h"
#import "PCHeader.h"
@interface ApplyDetailTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *titleArr, *contentArr;

@property (nonatomic, strong) NSString *totalMoney, *ccStr;

@end

@implementation ApplyDetailTableView

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
    NSArray *detailTitle = @[@"名称：",@"规格：",@"数量：",@"单位：",@"价格：",@"备注："];
    self.titleArr = [NSMutableArray arrayWithArray:@[@[@"审批编号：",@"审批类型：",@"所在部门：",@"申请事由：",@"期望交付："],@[@"审批流程"]]];
    self.contentArr = [NSMutableArray arrayWithArray:@[@[NSStringFormate(@"%@",viewModel.ApproveInfo[@"eventNo"]),@"采购",@"所在部门",viewModel.ApproveInfo[@"remark"]?viewModel.ApproveInfo[@"remark"]:@"",arr.count?arr[0][@"RequiredDate"]:@""],@[@""]]];
    CGFloat money = 0;
    for (int i = 0; i < arr.count; i ++) {
        [self.titleArr insertObject:detailTitle atIndex:(1+i)];
        NSDictionary *dict = arr[i];
        NSArray *detailContent = @[dict[@"GoodsName"],dict[@"GoodsModel"], dict[@"Quantity"],dict[@"Unit"],dict[@"Price"],dict[@"Remark"]?dict[@"Remark"]:@""];
        [self.contentArr insertObject:detailContent atIndex:(1+i)];
        money += [dict[@"Price"] floatValue]*[dict[@"Quantity"] floatValue];
    }
    NSMutableArray *ccmArr = [NSMutableArray array];
    for (NSDictionary *dict in self.viewModel.ccList) {
        [ccmArr addObject:dict[@"approvePerson"]];
    }
    self.ccStr = [ccmArr componentsJoinedByString:@","];
    self.totalMoney = money>0?NSStringFormate(@"%.2f",money):@"";
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
    if ([titleStr isEqualToString:@"附件"]) {
        static NSString *identifier = @"ApplyDetailPicCell";
        ApplyDetailPicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ApplyDetailPicCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        return cell;
    } else if ([titleStr isEqualToString:@"审批流程"]) {
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
    if ([titleStr isEqualToString:@"附件"]) {
        return 220;
    } else if ([titleStr isEqualToString:@"审批流程"]) {
        return 80;
    } else {
        return 30;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSArray *arr = self.titleArr[section];
    NSArray *arr2 = [self.viewModel.ApproveInfo[@"eventContent"] mj_JSONObject];
    if (arr.count>1 && section != 0) {
        return 45;
    }  else if (arr2.count == section-1) {
        return 44;
    } else if (section == 0) {
        return 70;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSArray *arr2 = [self.viewModel.ApproveInfo[@"eventContent"] mj_JSONObject];
    if (arr2.count == section) {
        return 70;
    }
    if (self.titleArr.count == section+1) {
        return 44;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *arr = self.titleArr[section];
    NSArray *arr2 = [self.viewModel.ApproveInfo[@"eventContent"] mj_JSONObject];
    if (arr.count>1 && section != 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
        headView.backgroundColor = HEX_FFF;
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, Screen_Width-30, 39)];
        la.font = SYS_FONT(12);
        la.text = NSStringFormate(@"  采购明细(%li)",section);
        la.textColor = HEX_666;
        la.backgroundColor = HexColor(@"#F5F6F8");
        [headView addSubview:la];
        return headView;
    } else if (arr2.count == section-1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
        headView.backgroundColor = HEX_FFF;
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, Screen_Width, 44)];
        la.text = @"审批流程";
        la.textColor = HEX_999;
        la.font = SYS_FONT(14);
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
    NSArray *arr = [self.viewModel.ApproveInfo[@"eventContent"] mj_JSONObject];
    if (arr.count == section) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 70)];
        footerView.backgroundColor = HEX_FFF;
        UILabel *totalLa = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, Screen_Width-30, 40)];
        totalLa.backgroundColor = HexColor(@"#F5F6F8");
        totalLa.text = NSStringFormate(@"  总价格：%@元",self.totalMoney);
        totalLa.font = SYS_FONT(14);
        [footerView addSubview:totalLa];
        LineView *line = [[LineView alloc] init];
        line.frame = CGRectMake(0, 60, Screen_Width, 10);
        line.backgroundColor = HexColor(@"#F5F6F8");
        [footerView addSubview:line];
        return footerView;
    }
    if (self.titleArr.count == section+1) {
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

@interface ApplyDetailTextCell ()

@end

@implementation ApplyDetailTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.titleLa = [UILabel new];
        self.titleLa.textColor = HEX_999;
        self.titleLa.font = SYS_FONT(14);
        [self.contentView addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.bottom.equalTo(self.contentView);
        }];
        
        self.contentLa = [UILabel new];
        self.contentLa.textColor = HEX_333;
        self.contentLa.font = SYS_FONT(14);
        [self.contentView addSubview:self.contentLa];
        [self.contentLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa.mas_right).offset(5);
            make.top.bottom.equalTo(self.titleLa);
            make.width.mas_equalTo(Screen_Width-100);
        }];
    }
    return self;
}

@end

@interface ApplyDetailPicCell ()

@end

@implementation ApplyDetailPicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        
        UILabel *la = [UILabel new];
        la.textColor = HexColor(@"#2E96F7");
        la.text = @"查看附件";
        la.font = SYS_FONT(13);
        [self.contentView addSubview:la];
        [la mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(44);
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((Screen_Width- 70)/5., (Screen_Width-70)/5.);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(44, 0, 44, 0));
        }];
        
        self.stateLa = [UILabel new];
        self.stateLa.textColor = HexColor(@"#2E96F7");
        self.stateLa.font = SYS_FONT(13);
        [self.contentView addSubview:self.stateLa];
        [self.stateLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(44);
        }];
    }
    return self;
}

@end

@interface ApplyDetailApprovalCell ()

@end

@implementation ApplyDetailApprovalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.imgv = [UIImageView new];
        [self.contentView addSubview:self.imgv];
        [self.imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        self.topLine = [UILabel new];
        self.topLine.backgroundColor = HexColor(@"#E9F4FF");
        [self.contentView addSubview:self.topLine];
        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.centerX.equalTo(self.imgv);
            make.bottom.equalTo(self.imgv.mas_top);
            make.width.mas_equalTo(2);
        }];
        
        self.bottomLine = [UILabel new];
        self.bottomLine.backgroundColor = HexColor(@"#E9F4FF");
        [self.contentView addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgv.mas_bottom);
            make.centerX.equalTo(self.imgv);
            make.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(2);
        }];
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = HexColor(@"#F6FAFE");
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgv.mas_right).offset(20);
            make.top.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.contentView).offset(-15);
            make.right.equalTo(self.contentView).offset(-22);
        }];
        
        UIImageView *userPortrait = [UIImageView new];
        userPortrait.image = [UIImage imageNamed:@"approvalPortrait"];
        userPortrait.layer.cornerRadius = 15;
        userPortrait.layer.masksToBounds = YES;
        [bgView addSubview:userPortrait];
        [userPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(11);
            make.centerY.equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        self.nameLa = [UILabel new];
        self.nameLa.textColor = HEX_333;
        self.nameLa.font = SYS_FONT(14);
        [self.contentView addSubview:self.nameLa];
        [self.nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userPortrait.mas_right).offset(7);
            make.centerY.equalTo(bgView).offset(-12);
            make.right.equalTo(bgView).offset(-15);
        }];
        
        self.stateLa = [UILabel new];
        self.stateLa.textColor = HEX_999;
        self.stateLa.font = SYS_FONT(14);
        [self.contentView addSubview:self.stateLa];
        [self.stateLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.nameLa);
            make.centerY.equalTo(bgView).offset(12);
        }];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.nameLa.text = NSStringFormate(@"%@ %@",dict[@"approvePerson"],dict[@"department"]);
    NSString *state = NSStringFormate(@"%@",dict[@"approveState"]);
    self.stateLa.text = [state isEqualToString:@"-1"]?@"审批中":([state isEqualToString:@"0"]?@"":([state isEqualToString:@"1"]?@"同意":([state isEqualToString:@"2"]?@"驳回":@"转审")));
    self.stateLa.textColor = [state isEqualToString:@"-1"]?HEX_999:([state isEqualToString:@"0"]?HEX_999:([state isEqualToString:@"1"]?HexColor(@"#2E96F7"):([state isEqualToString:@"2"]?HEX_999:HEX_999)));
    self.imgv.image = [UIImage imageNamed:[state isEqualToString:@"-1"]?@"waitFor":([state isEqualToString:@"0"]?@"processingMark":([state isEqualToString:@"1"]?@"finfishMark": ([state isEqualToString:@"2"]?@"bohuiMark":@"applyWithdraw")))];
}

@end
