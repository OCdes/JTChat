//
//  MyApplyTableView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/18.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "MyApplyTableView.h"
#import "PCHeader.h"
@interface MyApplyTableView () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation MyApplyTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = 0;
        self.tapRowSubject = [RACSubject subject];
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self reloadData];
}

#pragma mark - UITableViewDelegate&Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _dataArr[indexPath.row];
    if ([dict[@"eventClassify"] isEqualToNumber:@(2)]) {
        static NSString *identifier = @"ExpenseApplyCell";
        ExpenseApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ExpenseApplyCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        cell.dict = dict;
        return cell;
    } else if ([dict[@"eventClassify"] isEqualToNumber:@(4)]) {
        static NSString *identifier = @"FreeTicketCell";
        FreeTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[FreeTicketCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        cell.dict = dict;
        return cell;
    } else if ([dict[@"eventClassify"] isEqualToNumber:@(3)]) {
        static NSString *identifier = @"AdvanceCell";
        AdvanceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AdvanceCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        cell.dict = dict;
        return cell;
    } else if ([dict[@"eventClassify"] isEqualToNumber:@(5)]) {
        static NSString *identifier = @"RefundTicketCell";
        RefundTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[RefundTicketCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        cell.dict = _dataArr[indexPath.row];
        return cell;
    } else if ([dict[@"eventClassify"] isEqualToNumber:@(6)]) {
        static NSString *identifier = @"DiscoutDetailCell";
        DiscoutDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[DiscoutDetailCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        cell.dict = _dataArr[indexPath.row];
        return cell;
    } else if ([dict[@"eventClassify"] isEqualToNumber:@(7)]) {
        static NSString *identifier = @"AskOffApplyDetailCell";
        AskOffApplyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AskOffApplyDetailCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        cell.dict = _dataArr[indexPath.row];
        return cell;
    } else {
        static NSString *identifier = @"ApplyTableViewCell";
        ApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ApplyTableViewCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        cell.dict = _dataArr[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _dataArr[indexPath.row];
    if ([dict[@"eventClassify"] isEqualToNumber:@(1)]) {
        return 103;
    } else {
        return 120;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tapRowSubject sendNext:_dataArr[indexPath.row]];
}

@end

@interface ApplyTableViewCell ()

@property (nonatomic, strong) UILabel *titleLa, *stateLa, *dateLa, *descriptLa, *timeLa;

@end

@implementation ApplyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.titleLa = [UILabel new];
        self.titleLa.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",self.titleLa.font.fontName) size:14];
        self.titleLa.textColor = HEX_333;
        [self.contentView addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(20);
            make.width.mas_lessThanOrEqualTo(Screen_Width/2-15);
            make.height.mas_equalTo(15);
        }];
        
        self.stateLa = [UILabel new];
        self.stateLa.font = SYS_FONT(10);
        self.stateLa.layer.borderWidth = 1;
        self.stateLa.layer.cornerRadius = 3;
        self.stateLa.layer.masksToBounds = YES;
        [self.contentView addSubview:self.stateLa];
        [self.stateLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa.mas_right).offset(5);
            make.centerY.equalTo(self.titleLa);
            make.height.mas_equalTo(14);
        }];
        
        self.timeLa = [UILabel new];
        self.timeLa.textColor = HEX_999;
        self.timeLa.font = SYS_FONT(11);
        self.timeLa.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLa];
        [self.timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.stateLa);
        }];
        
        self.dateLa = [UILabel new];
        self.dateLa.textColor = HEX_666;
        self.dateLa.font = SYS_FONT(12);
        [self.contentView addSubview:self.dateLa];
        [self.dateLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa);
            make.top.equalTo(self.titleLa.mas_bottom).offset(10);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(14);
        }];
        
        self.descriptLa = [UILabel new];
        self.descriptLa.font = SYS_FONT(12);
        self.descriptLa.textColor = HEX_999;
        [self.contentView addSubview:self.descriptLa];
        [self.descriptLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.dateLa);
            make.top.equalTo(self.dateLa.mas_bottom).offset(10);
            make.height.mas_equalTo(14);
        }];
        
        LineView *line = [[LineView alloc] init];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    NSArray *arr = [dict[@"eventContent"] mj_JSONObject];
    NSDictionary *ddict = arr[0];
    long interval = [dict[@"createTime"] longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    formmater.dateFormat = @"yyyy-MM-dd";
    self.titleLa.text = dict[@"eventTitle"];
    self.dateLa.text = NSStringFormate(@"期望交付:%@",ddict[@"RequiredDate"]);
    self.timeLa.text = [formmater stringFromDate:date];
    self.descriptLa.text = NSStringFormate(@"申请事由:%@",dict[@"remark"]);
    if ([dict[@"state"] isEqualToNumber:@(0)]) {
        self.stateLa.layer.borderColor = HexColor(@"#2E96F7").CGColor;
        self.stateLa.text = @"  等待审批  ";
        self.stateLa.textColor = HexColor(@"#2E96F7");
    } else if ([dict[@"state"] isEqualToNumber:@(1)]) {
        self.stateLa.layer.borderColor = HexColor(@"#FDC472").CGColor;
        self.stateLa.text = @"  审批中  ";
        self.stateLa.textColor = HexColor(@"#FDC472");
    } else if ([dict[@"state"] isEqualToNumber:@(2)]) {
        self.stateLa.layer.borderColor = HexColor(@"#5ABF98").CGColor;
        self.stateLa.text = @"  已完成  ";
        self.stateLa.textColor = HexColor(@"#5ABF98");
    } else if ([dict[@"state"] isEqualToNumber:@(3)]) {
        self.stateLa.layer.borderColor = HexColor(@"#FE7764").CGColor;
        self.stateLa.text = @"  已驳回  ";
        self.stateLa.textColor = HexColor(@"#FE7764");
    } else if ([dict[@"state"] isEqualToNumber:@(4)]) {
        self.stateLa.layer.borderColor = HexColor(@"#BFBFBF").CGColor;
        self.stateLa.text = @"  已撤回  ";
        self.stateLa.textColor = HexColor(@"#BFBFBF");
    }
}

@end

@interface ExpenseApplyCell ()

@property (nonatomic, strong) UILabel *titleLa, *stateLa, *typeLa, *descriptLa, *moneyLa, *timeLa;

@end

@implementation ExpenseApplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.titleLa = [UILabel new];
        self.titleLa.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",self.titleLa.font.fontName) size:14];
        self.titleLa.textColor = HEX_333;
        [self.contentView addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(20);
            make.width.mas_lessThanOrEqualTo(Screen_Width/2-15);
            make.height.mas_equalTo(15);
        }];
        
        self.stateLa = [UILabel new];
        self.stateLa.font = SYS_FONT(10);
        self.stateLa.layer.borderWidth = 1;
        self.stateLa.layer.cornerRadius = 3;
        self.stateLa.layer.masksToBounds = YES;
        [self.contentView addSubview:self.stateLa];
        [self.stateLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa.mas_right).offset(5);
            make.centerY.equalTo(self.titleLa);
            make.height.mas_equalTo(14);
        }];
        
        self.timeLa = [UILabel new];
        self.timeLa.textColor = HEX_999;
        self.timeLa.font = SYS_FONT(11);
        self.timeLa.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLa];
        [self.timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.stateLa);
        }];
        
        self.moneyLa = [UILabel new];
        self.moneyLa.textColor = HEX_666;
        self.moneyLa.font = SYS_FONT(12);
        [self.contentView addSubview:self.moneyLa];
        [self.moneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa);
            make.top.equalTo(self.titleLa.mas_bottom).offset(10);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(14);
        }];
        
        self.typeLa = [UILabel new];
        self.typeLa.textColor = HEX_666;
        self.typeLa.font = SYS_FONT(12);
        [self.contentView addSubview:self.typeLa];
        [self.typeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.left.right.equalTo(self.moneyLa);
            make.top.equalTo(self.moneyLa.mas_bottom).offset(10);
        }];
        
        self.descriptLa = [UILabel new];
        self.descriptLa.font = SYS_FONT(12);
        self.descriptLa.textColor = HEX_999;
        [self.contentView addSubview:self.descriptLa];
        [self.descriptLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.left.right.equalTo(self.typeLa);
            make.top.equalTo(self.typeLa.mas_bottom).offset(10);
        }];
        
        LineView *line = [[LineView alloc] init];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    NSArray *arr = [dict[@"eventContent"] mj_JSONObject];
    CGFloat money = 0;
    for (NSDictionary *dict in arr) {
        money += [dict[@"CostAmount"] floatValue];
    }
    long interval = [dict[@"createTime"] longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    formmater.dateFormat = @"yyyy-MM-dd";
    self.titleLa.text = dict[@"eventTitle"];
    self.moneyLa.text = NSStringFormate(@"报销金额:%.2f",money);
    self.timeLa.text = [formmater stringFromDate:date];
    self.typeLa.text = NSStringFormate(@"报销类型：%@",dict[@"applyType"]);
    self.descriptLa.text = NSStringFormate(@"申请事由:%@",dict[@"remark"]);
    if ([dict[@"state"] isEqualToNumber:@(0)]) {
        self.stateLa.layer.borderColor = HexColor(@"#2E96F7").CGColor;
        self.stateLa.text = @"  等待审批  ";
        self.stateLa.textColor = HexColor(@"#2E96F7");
    } else if ([dict[@"state"] isEqualToNumber:@(1)]) {
        self.stateLa.layer.borderColor = HexColor(@"#FDC472").CGColor;
        self.stateLa.text = @"  审批中  ";
        self.stateLa.textColor = HexColor(@"#FDC472");
    } else if ([dict[@"state"] isEqualToNumber:@(2)]) {
        self.stateLa.layer.borderColor = HexColor(@"#5ABF98").CGColor;
        self.stateLa.text = @"  已完成  ";
        self.stateLa.textColor = HexColor(@"#5ABF98");
    } else if ([dict[@"state"] isEqualToNumber:@(3)]) {
        self.stateLa.layer.borderColor = HexColor(@"#FE7764").CGColor;
        self.stateLa.text = @"  已驳回  ";
        self.stateLa.textColor = HexColor(@"#FE7764");
    } else if ([dict[@"state"] isEqualToNumber:@(4)]) {
        self.stateLa.layer.borderColor = HexColor(@"#BFBFBF").CGColor;
        self.stateLa.text = @"  已撤回  ";
        self.stateLa.textColor = HexColor(@"#BFBFBF");
    }
}

@end

@interface FreeTicketCell ()

@property (nonatomic, strong) UILabel *titleLa, *stateLa, *typeLa, *descriptLa, *moneyLa, *timeLa;

@end

@implementation FreeTicketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.titleLa = [UILabel new];
        self.titleLa.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",self.titleLa.font.fontName) size:14];
        self.titleLa.textColor = HEX_333;
        [self.contentView addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(20);
            make.width.mas_lessThanOrEqualTo(Screen_Width/2-15);
            make.height.mas_equalTo(15);
        }];
        
        self.stateLa = [UILabel new];
        self.stateLa.font = SYS_FONT(10);
        self.stateLa.layer.borderWidth = 1;
        self.stateLa.layer.cornerRadius = 3;
        self.stateLa.layer.masksToBounds = YES;
        [self.contentView addSubview:self.stateLa];
        [self.stateLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa.mas_right).offset(5);
            make.centerY.equalTo(self.titleLa);
            make.height.mas_equalTo(14);
        }];
        
        self.timeLa = [UILabel new];
        self.timeLa.textColor = HEX_999;
        self.timeLa.font = SYS_FONT(11);
        self.timeLa.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLa];
        [self.timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.stateLa);
        }];
        
        self.moneyLa = [UILabel new];
        self.moneyLa.textColor = HEX_666;
        self.moneyLa.font = SYS_FONT(12);
        [self.contentView addSubview:self.moneyLa];
        [self.moneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa);
            make.top.equalTo(self.titleLa.mas_bottom).offset(10);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(14);
        }];
        
        self.typeLa = [UILabel new];
        self.typeLa.textColor = HEX_666;
        self.typeLa.font = SYS_FONT(12);
        [self.contentView addSubview:self.typeLa];
        [self.typeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.left.right.equalTo(self.moneyLa);
            make.top.equalTo(self.moneyLa.mas_bottom).offset(10);
        }];
        
        self.descriptLa = [UILabel new];
        self.descriptLa.font = SYS_FONT(12);
        self.descriptLa.textColor = HEX_999;
        [self.contentView addSubview:self.descriptLa];
        [self.descriptLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.left.right.equalTo(self.typeLa);
            make.top.equalTo(self.typeLa.mas_bottom).offset(10);
        }];
        
        LineView *line = [[LineView alloc] init];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    NSArray *arr = [dict[@"eventContent"] mj_JSONObject];
    NSDictionary *ddict = arr[0];
    long interval = [dict[@"createTime"] longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    formmater.dateFormat = @"yyyy-MM-dd";
    self.titleLa.text = dict[@"eventTitle"];
    self.timeLa.text = [formmater stringFromDate:date];
    self.moneyLa.text = NSStringFormate(@"免票类型:%@",ddict[@"FreeType"]);
    self.typeLa.text = NSStringFormate(@"申请事由：%@",dict[@"remark"]);
     self.descriptLa.text = NSStringFormate(@"发生日期：%@",ddict[@"RequiredDate"]);
    if ([dict[@"state"] isEqualToNumber:@(0)]) {
        self.stateLa.layer.borderColor = HexColor(@"#2E96F7").CGColor;
        self.stateLa.text = @"  等待审批  ";
        self.stateLa.textColor = HexColor(@"#2E96F7");
    } else if ([dict[@"state"] isEqualToNumber:@(1)]) {
        self.stateLa.layer.borderColor = HexColor(@"#FDC472").CGColor;
        self.stateLa.text = @"  审批中  ";
        self.stateLa.textColor = HexColor(@"#FDC472");
    } else if ([dict[@"state"] isEqualToNumber:@(2)]) {
        self.stateLa.layer.borderColor = HexColor(@"#5ABF98").CGColor;
        self.stateLa.text = @"  已完成  ";
        self.stateLa.textColor = HexColor(@"#5ABF98");
    } else if ([dict[@"state"] isEqualToNumber:@(3)]) {
        self.stateLa.layer.borderColor = HexColor(@"#FE7764").CGColor;
        self.stateLa.text = @"  已驳回  ";
        self.stateLa.textColor = HexColor(@"#FE7764");
    } else if ([dict[@"state"] isEqualToNumber:@(4)]) {
        self.stateLa.layer.borderColor = HexColor(@"#BFBFBF").CGColor;
        self.stateLa.text = @"  已撤回  ";
        self.stateLa.textColor = HexColor(@"#BFBFBF");
    }
}

@end

@interface AdvanceCell ()

@property (nonatomic, strong) UILabel *titleLa, *stateLa, *typeLa, *descriptLa, *moneyLa, *timeLa;

@end

@implementation AdvanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.titleLa = [UILabel new];
        self.titleLa.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",self.titleLa.font.fontName) size:14];
        self.titleLa.textColor = HEX_333;
        [self.contentView addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(20);
            make.width.mas_lessThanOrEqualTo(Screen_Width/2-15);
            make.height.mas_equalTo(15);
        }];
        
        self.stateLa = [UILabel new];
        self.stateLa.font = SYS_FONT(10);
        self.stateLa.layer.borderWidth = 1;
        self.stateLa.layer.cornerRadius = 3;
        self.stateLa.layer.masksToBounds = YES;
        [self.contentView addSubview:self.stateLa];
        [self.stateLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa.mas_right).offset(5);
            make.centerY.equalTo(self.titleLa);
            make.height.mas_equalTo(14);
        }];
        
        self.timeLa = [UILabel new];
        self.timeLa.textColor = HEX_999;
        self.timeLa.font = SYS_FONT(11);
        self.timeLa.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLa];
        [self.timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.stateLa);
        }];
        
        self.moneyLa = [UILabel new];
        self.moneyLa.textColor = HEX_666;
        self.moneyLa.font = SYS_FONT(12);
        [self.contentView addSubview:self.moneyLa];
        [self.moneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa);
            make.top.equalTo(self.titleLa.mas_bottom).offset(10);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(14);
        }];
        
        self.typeLa = [UILabel new];
        self.typeLa.textColor = HEX_666;
        self.typeLa.font = SYS_FONT(12);
        [self.contentView addSubview:self.typeLa];
        [self.typeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.left.right.equalTo(self.moneyLa);
            make.top.equalTo(self.moneyLa.mas_bottom).offset(10);
        }];
        
        self.descriptLa = [UILabel new];
        self.descriptLa.font = SYS_FONT(12);
        self.descriptLa.textColor = HEX_999;
        [self.contentView addSubview:self.descriptLa];
        [self.descriptLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.left.right.equalTo(self.typeLa);
            make.top.equalTo(self.typeLa.mas_bottom).offset(10);
        }];
        
        LineView *line = [[LineView alloc] init];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    NSArray *arr = [dict[@"eventContent"] mj_JSONObject];
    NSDictionary *ddict = arr[0];
    long interval = [dict[@"createTime"] longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    formmater.dateFormat = @"yyyy-MM-dd";
    self.titleLa.text = dict[@"eventTitle"];
    self.timeLa.text = [formmater stringFromDate:date];
    self.moneyLa.text = NSStringFormate(@"费用类型:%@",dict[@"applyType"]);
    self.typeLa.text = NSStringFormate(@"申请事由：%@",dict[@"remark"]);
     self.descriptLa.text = NSStringFormate(@"费用金额：%@",ddict[@"TotalFees"]);
    if ([dict[@"state"] isEqualToNumber:@(0)]) {
        self.stateLa.layer.borderColor = HexColor(@"#2E96F7").CGColor;
        self.stateLa.text = @"  等待审批  ";
        self.stateLa.textColor = HexColor(@"#2E96F7");
    } else if ([dict[@"state"] isEqualToNumber:@(1)]) {
        self.stateLa.layer.borderColor = HexColor(@"#FDC472").CGColor;
        self.stateLa.text = @"  审批中  ";
        self.stateLa.textColor = HexColor(@"#FDC472");
    } else if ([dict[@"state"] isEqualToNumber:@(2)]) {
        self.stateLa.layer.borderColor = HexColor(@"#5ABF98").CGColor;
        self.stateLa.text = @"  已完成  ";
        self.stateLa.textColor = HexColor(@"#5ABF98");
    } else if ([dict[@"state"] isEqualToNumber:@(3)]) {
        self.stateLa.layer.borderColor = HexColor(@"#FE7764").CGColor;
        self.stateLa.text = @"  已驳回  ";
        self.stateLa.textColor = HexColor(@"#FE7764");
    } else if ([dict[@"state"] isEqualToNumber:@(4)]) {
        self.stateLa.layer.borderColor = HexColor(@"#BFBFBF").CGColor;
        self.stateLa.text = @"  已撤回  ";
        self.stateLa.textColor = HexColor(@"#BFBFBF");
    }
}

@end

@interface RefundTicketCell ()


@property (nonatomic, strong) UILabel *titleLa, *stateLa, *typeLa, *descriptLa, *moneyLa, *timeLa;

@end

@implementation RefundTicketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.titleLa = [UILabel new];
        self.titleLa.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",self.titleLa.font.fontName) size:14];
        self.titleLa.textColor = HEX_333;
        [self.contentView addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(20);
            make.width.mas_lessThanOrEqualTo(Screen_Width/2-15);
            make.height.mas_equalTo(15);
        }];
        
        self.stateLa = [UILabel new];
        self.stateLa.font = SYS_FONT(10);
        self.stateLa.layer.borderWidth = 1;
        self.stateLa.layer.cornerRadius = 3;
        self.stateLa.layer.masksToBounds = YES;
        [self.contentView addSubview:self.stateLa];
        [self.stateLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa.mas_right).offset(5);
            make.centerY.equalTo(self.titleLa);
            make.height.mas_equalTo(14);
        }];
        
        self.timeLa = [UILabel new];
        self.timeLa.textColor = HEX_999;
        self.timeLa.font = SYS_FONT(11);
        self.timeLa.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLa];
        [self.timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.stateLa);
        }];
        
        self.moneyLa = [UILabel new];
        self.moneyLa.textColor = HEX_666;
        self.moneyLa.font = SYS_FONT(12);
        [self.contentView addSubview:self.moneyLa];
        [self.moneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa);
            make.top.equalTo(self.titleLa.mas_bottom).offset(10);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(14);
        }];
        
        self.typeLa = [UILabel new];
        self.typeLa.textColor = HEX_666;
        self.typeLa.font = SYS_FONT(12);
        [self.contentView addSubview:self.typeLa];
        [self.typeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.left.right.equalTo(self.moneyLa);
            make.top.equalTo(self.moneyLa.mas_bottom).offset(10);
        }];
        
        self.descriptLa = [UILabel new];
        self.descriptLa.font = SYS_FONT(12);
        self.descriptLa.textColor = HEX_999;
        [self.contentView addSubview:self.descriptLa];
        [self.descriptLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.left.right.equalTo(self.typeLa);
            make.top.equalTo(self.typeLa.mas_bottom).offset(10);
        }];
        
        LineView *line = [[LineView alloc] init];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    NSArray *arr = [dict[@"eventContent"] mj_JSONObject];
    NSDictionary *ddict = arr[0];
    long interval = [dict[@"createTime"] longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    formmater.dateFormat = @"yyyy-MM-dd";
    self.titleLa.text = dict[@"eventTitle"];
    self.timeLa.text = [formmater stringFromDate:date];
    self.moneyLa.text = NSStringFormate(@"退票房间:%@",ddict[@"RoomName"]);
    self.typeLa.text = NSStringFormate(@"申请事由：%@",dict[@"remark"]);
     self.descriptLa.text = NSStringFormate(@"发生日期：%@",ddict[@"RefundDate"]);
    if ([dict[@"state"] isEqualToNumber:@(0)]) {
        self.stateLa.layer.borderColor = HexColor(@"#2E96F7").CGColor;
        self.stateLa.text = @"  等待审批  ";
        self.stateLa.textColor = HexColor(@"#2E96F7");
    } else if ([dict[@"state"] isEqualToNumber:@(1)]) {
        self.stateLa.layer.borderColor = HexColor(@"#FDC472").CGColor;
        self.stateLa.text = @"  审批中  ";
        self.stateLa.textColor = HexColor(@"#FDC472");
    } else if ([dict[@"state"] isEqualToNumber:@(2)]) {
        self.stateLa.layer.borderColor = HexColor(@"#5ABF98").CGColor;
        self.stateLa.text = @"  已完成  ";
        self.stateLa.textColor = HexColor(@"#5ABF98");
    } else if ([dict[@"state"] isEqualToNumber:@(3)]) {
        self.stateLa.layer.borderColor = HexColor(@"#FE7764").CGColor;
        self.stateLa.text = @"  已驳回  ";
        self.stateLa.textColor = HexColor(@"#FE7764");
    } else if ([dict[@"state"] isEqualToNumber:@(4)]) {
        self.stateLa.layer.borderColor = HexColor(@"#BFBFBF").CGColor;
        self.stateLa.text = @"  已撤回  ";
        self.stateLa.textColor = HexColor(@"#BFBFBF");
    }
}

@end

@interface DiscoutDetailCell ()

@property (nonatomic, strong) UILabel *titleLa, *stateLa, *typeLa, *descriptLa, *moneyLa, *timeLa;

@end

@implementation DiscoutDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.titleLa = [UILabel new];
        self.titleLa.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",self.titleLa.font.fontName) size:14];
        self.titleLa.textColor = HEX_333;
        [self.contentView addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(20);
            make.width.mas_lessThanOrEqualTo(Screen_Width/2-15);
            make.height.mas_equalTo(15);
        }];
        
        self.stateLa = [UILabel new];
        self.stateLa.font = SYS_FONT(10);
        self.stateLa.layer.borderWidth = 1;
        self.stateLa.layer.cornerRadius = 3;
        self.stateLa.layer.masksToBounds = YES;
        [self.contentView addSubview:self.stateLa];
        [self.stateLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa.mas_right).offset(5);
            make.centerY.equalTo(self.titleLa);
            make.height.mas_equalTo(14);
        }];
        
        self.timeLa = [UILabel new];
        self.timeLa.textColor = HEX_999;
        self.timeLa.font = SYS_FONT(11);
        self.timeLa.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLa];
        [self.timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.stateLa);
        }];
        
        self.moneyLa = [UILabel new];
        self.moneyLa.textColor = HEX_666;
        self.moneyLa.font = SYS_FONT(12);
        [self.contentView addSubview:self.moneyLa];
        [self.moneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa);
            make.top.equalTo(self.titleLa.mas_bottom).offset(10);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(14);
        }];
        
        self.typeLa = [UILabel new];
        self.typeLa.textColor = HEX_666;
        self.typeLa.font = SYS_FONT(12);
        [self.contentView addSubview:self.typeLa];
        [self.typeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.left.right.equalTo(self.moneyLa);
            make.top.equalTo(self.moneyLa.mas_bottom).offset(10);
        }];
        
        self.descriptLa = [UILabel new];
        self.descriptLa.font = SYS_FONT(12);
        self.descriptLa.textColor = HEX_999;
        [self.contentView addSubview:self.descriptLa];
        [self.descriptLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.left.right.equalTo(self.typeLa);
            make.top.equalTo(self.typeLa.mas_bottom).offset(10);
        }];
        
        LineView *line = [[LineView alloc] init];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    NSArray *arr = [dict[@"eventContent"] mj_JSONObject];
    NSDictionary *ddict = arr[0];
    long interval = [dict[@"createTime"] longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    formmater.dateFormat = @"yyyy-MM-dd";
    self.titleLa.text = dict[@"eventTitle"];
    self.timeLa.text = [formmater stringFromDate:date];
    self.moneyLa.text = NSStringFormate(@"打折房间:%@",ddict[@"RoomName"]);
    self.typeLa.text = NSStringFormate(@"打折额度：%.1f折",[ddict[@"Discount"] floatValue]/10);
     self.descriptLa.text = NSStringFormate(@"申请事由：%@",dict[@"remark"]);
    if ([dict[@"state"] isEqualToNumber:@(0)]) {
        self.stateLa.layer.borderColor = HexColor(@"#2E96F7").CGColor;
        self.stateLa.text = @"  等待审批  ";
        self.stateLa.textColor = HexColor(@"#2E96F7");
    } else if ([dict[@"state"] isEqualToNumber:@(1)]) {
        self.stateLa.layer.borderColor = HexColor(@"#FDC472").CGColor;
        self.stateLa.text = @"  审批中  ";
        self.stateLa.textColor = HexColor(@"#FDC472");
    } else if ([dict[@"state"] isEqualToNumber:@(2)]) {
        self.stateLa.layer.borderColor = HexColor(@"#5ABF98").CGColor;
        self.stateLa.text = @"  已完成  ";
        self.stateLa.textColor = HexColor(@"#5ABF98");
    } else if ([dict[@"state"] isEqualToNumber:@(3)]) {
        self.stateLa.layer.borderColor = HexColor(@"#FE7764").CGColor;
        self.stateLa.text = @"  已驳回  ";
        self.stateLa.textColor = HexColor(@"#FE7764");
    } else if ([dict[@"state"] isEqualToNumber:@(4)]) {
        self.stateLa.layer.borderColor = HexColor(@"#BFBFBF").CGColor;
        self.stateLa.text = @"  已撤回  ";
        self.stateLa.textColor = HexColor(@"#BFBFBF");
    }
}

@end


@interface AskOffApplyDetailCell ()

@property (nonatomic, strong) UILabel *titleLa, *stateLa, *typeLa, *descriptLa, *moneyLa, *timeLa;

@end

@implementation AskOffApplyDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.titleLa = [UILabel new];
        self.titleLa.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",self.titleLa.font.fontName) size:14];
        self.titleLa.textColor = HEX_333;
        [self.contentView addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(20);
            make.width.mas_lessThanOrEqualTo(Screen_Width/2-15);
            make.height.mas_equalTo(15);
        }];
        
        self.stateLa = [UILabel new];
        self.stateLa.font = SYS_FONT(10);
        self.stateLa.layer.borderWidth = 1;
        [self.contentView addSubview:self.stateLa];
        [self.stateLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa.mas_right).offset(5);
            make.centerY.equalTo(self.titleLa);
            make.height.mas_equalTo(14);
        }];
        
        self.timeLa = [UILabel new];
        self.timeLa.textColor = HEX_999;
        self.timeLa.font = SYS_FONT(11);
        self.timeLa.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLa];
        [self.timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.stateLa);
        }];
        
        self.moneyLa = [UILabel new];
        self.moneyLa.textColor = HEX_666;
        self.moneyLa.font = SYS_FONT(12);
        [self.contentView addSubview:self.moneyLa];
        [self.moneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa);
            make.top.equalTo(self.titleLa.mas_bottom).offset(10);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(14);
        }];
        
        self.typeLa = [UILabel new];
        self.typeLa.textColor = HEX_999;
        self.typeLa.font = SYS_FONT(12);
        [self.contentView addSubview:self.typeLa];
        [self.typeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.left.right.equalTo(self.moneyLa);
            make.top.equalTo(self.moneyLa.mas_bottom).offset(10);
        }];
        
        self.descriptLa = [UILabel new];
        self.descriptLa.font = SYS_FONT(12);
        self.descriptLa.textColor = HEX_999;
        [self.contentView addSubview:self.descriptLa];
        [self.descriptLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.left.right.equalTo(self.typeLa);
            make.top.equalTo(self.typeLa.mas_bottom).offset(10);
        }];
        
        LineView *line = [[LineView alloc] init];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    NSArray *arr = [dict[@"eventContent"] mj_JSONObject];
    NSDictionary *ddict = arr[0];
    long interval = [dict[@"createTime"] longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    formmater.dateFormat = @"yyyy-MM-dd";
    self.titleLa.text = dict[@"eventTitle"];
    self.timeLa.text = [formmater stringFromDate:date];
    self.moneyLa.text = NSStringFormate(@"请假类型:%@",ddict[@"Type"]);
    self.typeLa.text = NSStringFormate(@"开始时间：%@",ddict[@"StartTime"]);
     self.descriptLa.text = NSStringFormate(@"结束时间：%@",ddict[@"EndTime"]);
    if ([dict[@"state"] isEqualToNumber:@(0)]) {
        self.stateLa.layer.borderColor = HexColor(@"#2E96F7").CGColor;
        self.stateLa.text = @"  等待审批  ";
        self.stateLa.textColor = HexColor(@"#2E96F7");
    } else if ([dict[@"state"] isEqualToNumber:@(1)]) {
        self.stateLa.layer.borderColor = HexColor(@"#FDC472").CGColor;
        self.stateLa.text = @"  审批中  ";
        self.stateLa.textColor = HexColor(@"#FDC472");
    } else if ([dict[@"state"] isEqualToNumber:@(2)]) {
        self.stateLa.layer.borderColor = HexColor(@"#5ABF98").CGColor;
        self.stateLa.text = @"  已通过  ";
        self.stateLa.textColor = HexColor(@"#5ABF98");
    } else if ([dict[@"state"] isEqualToNumber:@(3)]) {
        self.stateLa.layer.borderColor = HexColor(@"#FE7764").CGColor;
        self.stateLa.text = @"  已驳回  ";
        self.stateLa.textColor = HexColor(@"#FE7764");
    } else if ([dict[@"state"] isEqualToNumber:@(4)]) {
        self.stateLa.layer.borderColor = HexColor(@"#BFBFBF").CGColor;
        self.stateLa.text = @"  已撤回  ";
        self.stateLa.textColor = HexColor(@"#BFBFBF");
    }
}

@end
