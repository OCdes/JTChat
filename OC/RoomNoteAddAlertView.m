//
//  RoomNoteAddAlertView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/3/12.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "RoomNoteAddAlertView.h"
#import "PCHeader.h"
@interface RoomNoteAddAlertView () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *maskV;

@property (nonatomic, strong) UILabel *titleLa, *noteLa;

@property (nonatomic, strong) UIButton *sureBtn, *cancleBtn;

@property (nonatomic, strong) NSArray *rowTitleArr, *placeHolderArr, *arrowImageArr, *keyBoradTypeArr;

@property (nonatomic, strong) NSMutableArray *contentArr;

@property (nonatomic, assign) AlertType type;



@end

@implementation RoomNoteAddAlertView

- (instancetype)initWithAlertType:(AlertType)type {
    if (self = [super init]) {
        self.type = type;
        self.sureSubject = [RACSubject subject];
        self.maskV = [[UIView alloc] initWithFrame:APPWINDOW.bounds];
        self.maskV.userInteractionEnabled = YES;
        self.maskV.backgroundColor = [HEX_333 colorWithAlphaComponent:0.5];
        self.maskV.alpha = 0.01;
        self.dict = [NSMutableDictionary dictionary];
        self.frame = CGRectMake(0, 0, Screen_Width-12, type == WaiterAlert  ? 392 : (type == CreatRoleAlert ? 254 :273) );
        if (self.type == SingleAddAlert) {
            self.frame = CGRectMake(0, 0, Screen_Width-12, 191);
        }
        self.center = self.maskV.center;
        self.backgroundColor = HEX_FFF;
        self.userInteractionEnabled = YES;
        self.titleLa = [UILabel new];
        self.titleLa.font = SYS_FONT(16);
        self.titleLa.textColor = HEX_333;
        self.titleLa.textAlignment = NSTextAlignmentCenter;
        self.titleLa.text = (type == WineAlert ? @"酒名/量" :(type == CashierAlert ? @"买单员" : (type == SijiuAlert?@"司酒员":@"上班人员")));
        [self addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(42);
        }];
        
        LineView *line1 = [[LineView alloc] init];
        [self.titleLa addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.titleLa);
            make.height.mas_equalTo(0.5);
        }];
        
        self.cancleBtn = [UIButton new];
        self.cancleBtn.title = @"取消";
        [self.cancleBtn addTarget:self action:@selector(cancleBtnClicked:)];
        self.cancleBtn.titleLabel.font = SYS_FONT(16);
        self.cancleBtn.titleColor = HexColor(@"#2E96F7");
        self.cancleBtn.backgroundColor = HEX_FFF;
        [self addSubview:self.cancleBtn];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self);
            make.size.mas_equalTo(CGSizeMake((Screen_Width-12)/2., 44));
        }];
        
        self.sureBtn = [UIButton new];
        self.sureBtn.title = @"确定";
        [self.sureBtn addTarget:self action:@selector(sureBtnClicked:)];
        self.sureBtn.titleLabel.font = SYS_FONT(16);
        self.sureBtn.titleColor = HEX_FFF;
        self.sureBtn.backgroundColor = HexColor(@"#2E96F7");
        [self addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancleBtn.mas_right);
            make.size.top.equalTo(self.cancleBtn);
        }];
        
        self.noteLa = [UILabel new];
        self.noteLa.textColor = HEX_999;
        self.noteLa.font = SYS_FONT(12);
        self.noteLa.adjustsFontSizeToFitWidth = YES;
        self.noteLa.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.noteLa];
        [self.noteLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.sureBtn.mas_top);
            if (type == CreatRoleAlert) {
                make.height.mas_equalTo(62);
            } else {
                make.height.mas_equalTo(0.01);
            }
            
        }];
        
        LineView *line2 = [[LineView alloc] init];
        [self.cancleBtn addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.cancleBtn);
            make.height.mas_equalTo(0.5);
        }];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 42, Screen_Width-12, type == WineAlert ? 186 :(type == CashierAlert ? 186 : 245)) style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = HEX_FFF;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = 0;
        self.tableView.scrollEnabled = NO;
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLa.mas_bottom);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.noteLa.mas_top);
        }];
        
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
        
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLa.text = titleStr;
}

- (void)setCancleStr:(NSString *)cancleStr  {
    _cancleStr = cancleStr;
    self.cancleBtn.title = cancleStr;
}

- (void)setSureStr:(NSString *)sureStr {
    _sureStr = sureStr;
    self.sureBtn.title = sureStr;
}

- (void)setNoteStr:(NSString *)noteStr {
    _noteStr = noteStr;
    if (!noteStr.length) {
        [self.noteLa mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.01);
        }];
    } else {
        [self.noteLa mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(62);
        }];
    }
    self.noteLa.text = noteStr;
}

- (void)sureBtnClicked:(UIButton *)btn {
    if (self.type == WineAlert) {
        if ([[self.dict objectForKey:@"酒名"] length] && [[self.dict objectForKey:@"单位"] length]) {
            if (![[self.dict objectForKey:@"数量"] length]) {
                [self.dict setObject:@"0" forKey:@"数量"];
            }
            [self.sureSubject sendNext:self.dict];
            [self hidden];
        } else {
            if (![[self.dict objectForKey:@"酒名"] length]) {
                SHOW_ERROE(@"请填写酒名");
            } else if (![[self.dict objectForKey:@"数量"] length]) {
                SHOW_ERROE(@"请填写数量");
            } else {
                SHOW_ERROE(@"请填写单位");
            }
            DISMISS_HUD(1.2);
        }
        
    } else if (self.type == CashierAlert || self.type == SijiuAlert) {
        [self.sureSubject sendNext:self.dict];
        [self hidden];
    } else if (self.type == WaiterAlert) {
        [self.sureSubject sendNext:self.dict];
        [self hidden];
    } else if (self.type == CreatRoleAlert) {
        if (![[self.dict objectForKey:@"角色"] length]) {
            SHOW_ERROE(@"请填写角色");
        } else if (![[self.dict objectForKey:@"天数"] length]) {
            SHOW_ERROE(@"请填写最大查询天数");
        } else {
            [self.sureSubject sendNext:self.dict];
        }
    } else if (self.type == SingleAddAlert) {
        if ([self.dict[@"手机"] length]) {
            [self.sureSubject sendNext:self.dict[@"手机"]];
        } else {
            SHOW_ERROE(@"请选择要解绑的员工");
        }
        
    }
    
}

- (void)cancleBtnClicked:(UIButton *)btn {
    [self hidden];
}

- (void)showInView:(UIView *)view {
    [view addSubview:self.maskV];
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.maskV.alpha = 1.;
        self.transform = CGAffineTransformMakeScale(1., 1.);
    }];
}



- (void)hidden {
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.maskV.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.maskV removeFromSuperview];
    }];
}

#pragma mark - UITableViewDelegate&Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rowTitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *imgStr = self.arrowImageArr[indexPath.row];
    static NSString *identifier = @"RoomNoteAlertCell";
    RoomNoteAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RoomNoteAlertCell alloc] initWithStyle:0 reuseIdentifier:identifier];
    }
    cell.tf.indexPath = indexPath;
    cell.tf.delegate = self;
    cell.titleLa.text = self.rowTitleArr[indexPath.row];
    cell.tf.placeholder = self.placeHolderArr[indexPath.row];
    cell.tf.rightViewMode = imgStr.length?UITextFieldViewModeAlways:UITextFieldViewModeNever;
    cell.tf.secureTextEntry = [self.rowTitleArr[indexPath.row] isEqualToString:@"电话"];
    cell.dropBtn.image = imgStr;
    [cell.dropBtn addTarget:self action:@selector(dropBtnClicked:)];
    cell.tf.text = self.contentArr[indexPath.row];
    cell.tf.keyboardType = [self.keyBoradTypeArr[indexPath.row] integerValue];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
    
}

- (void)dropBtnClicked:(UIButton *)btn {
    RootTabBarController *tabController = (RootTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    NSArray *subControllers = tabController.viewControllers;
    UINavigationController *nav = subControllers[tabController.selectedIndex];
    
    if (self.type == WineAlert) {
        
    } else if (self.type == CashierAlert || self.type == SijiuAlert) {
        EmployeeSigleSelectVC *dataVc = [[EmployeeSigleSelectVC alloc] init];
        @weakify(self);
        dataVc.selectBlock = ^(NSDictionary<NSString *,id> * emp) {
            @strongify(self);
            [self.contentArr replaceObjectAtIndex:0 withObject:emp[@"emp_code"]];
            [self.contentArr replaceObjectAtIndex:1 withObject:emp[@"emp_name"]];
            [self.contentArr replaceObjectAtIndex:2 withObject:emp[@"emp_phone"]];
            [self.dict setObject:emp[@"emp_code"] forKey:@"员工代码"];
            [self.dict setObject:emp[@"emp_name"] forKey:@"姓名"];
            [self.dict setObject:emp[@"emp_phone"] forKey:@"手机"];
            [self.tableView reloadData];
        };
        [nav pushViewController:dataVc animated:YES];
    } else if (self.type == SingleAddAlert) {
        EmployeeSigleSelectVC *dataVc = [[EmployeeSigleSelectVC alloc] init];
        @weakify(self);
        dataVc.selectBlock = ^(NSDictionary<NSString *,id> * emp) {
            @strongify(self);
            [self.contentArr replaceObjectAtIndex:0 withObject:emp[@"emp_phone"]];
            [self.dict setObject:emp[@"emp_code"] forKey:@"员工代码"];
            [self.dict setObject:emp[@"emp_name"] forKey:@"姓名"];
            [self.dict setObject:emp[@"emp_phone"] forKey:@"手机"];
            [self.tableView reloadData];
        };
        [nav pushViewController:dataVc animated:YES];
    } else {
        EmployeeSigleSelectVC *dataVc = [[EmployeeSigleSelectVC alloc] init];
        @weakify(self);
        dataVc.selectBlock = ^(NSDictionary<NSString *,id> * emp) {
            @strongify(self);
            NSString *depart = emp[@"emp_departmentName"]?emp[@"emp_departmentName"]:@"";
            NSString *empId = emp[@"emp_code"]?emp[@"emp_code"]:@"";
            NSString *name = emp[@"emp_name"]?emp[@"emp_name"]:@"";
            NSString *phone = emp[@"emp_phone"] ? emp[@"emp_phone"] : @"" ;
            NSString *fee = emp[@"emp_serviceFee"]?emp[@"emp_serviceFee"]:@"";
            [self.contentArr replaceObjectAtIndex:0 withObject:depart];
            [self.contentArr replaceObjectAtIndex:1 withObject:empId];
            [self.contentArr replaceObjectAtIndex:2 withObject:name];
            [self.contentArr replaceObjectAtIndex:3 withObject:phone];
             [self.contentArr replaceObjectAtIndex:4 withObject: fee];
            [self.dict setObject:empId forKey:@"员工代码"];
            [self.dict setObject:name forKey:@"姓名"];
            [self.dict setObject:phone forKey:@"手机"];
            [self.dict setObject:depart forKey:@"部门名称"];
            [self.dict setObject:fee forKey:@"小费"];
            [self.tableView reloadData];
        };
        [nav pushViewController:dataVc animated:YES];
    }
}

#pragma mark - Lazyload

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSIndexPath *indexPath = textField.indexPath;
    NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (!newStr.length) {
        newStr = @"";
    }
    NSInteger keyboardType = [self.keyBoradTypeArr[indexPath.row] integerValue];
    if (keyboardType == UIKeyboardTypeNumberPad) {
        if (![newStr isNum] && newStr.length) {
            return NO;
        }
    }
    if (self.type == WineAlert) {
        if (indexPath.row == 0) {
            [self.dict setObject:newStr forKey:@"酒名"];
        } else if (indexPath.row == 1) {
            [self.dict setObject:newStr forKey:@"数量"];
        } else {
            [self.dict setObject:newStr forKey:@"单位"];
        }
    } else if (self.type == CashierAlert || self.type == SijiuAlert) {
        if (indexPath.row == 0) {
            [self.dict setObject:newStr forKey:@"员工代码"];
        } else if (indexPath.row == 1) {
            [self.dict setObject:newStr forKey:@"姓名"];
        } else {
            [self.dict setObject:newStr forKey:@"手机"];
        }
    } else if (self.type == WaiterAlert) {
        if (indexPath.row == 0) {
            [self.dict setObject:newStr forKey:@"部门名称"];
        } else if (indexPath.row == 1) {
            [self.dict setObject:newStr forKey:@"员工代码"];
        } else if (indexPath.row == 2) {
            [self.dict setObject:newStr forKey:@"姓名"];
        } else if (indexPath.row == 3) {
            [self.dict setObject:newStr forKey:@"手机"];
        } else {
            [self.dict setObject:newStr forKey:@"小费"];
        }
    } else if (self.type == CreatRoleAlert) {
        if (indexPath.row == 0) {
            [self.dict setObject:newStr forKey:@"角色"];
        } else if (indexPath.row == 1) {
            [self.dict setObject:newStr forKey:@"天数"];
        }
    } else if (self.type == SingleAddAlert) {
        if (indexPath.row == 0) {
            [self.dict setObject:newStr forKey:@"手机"];
        }
    }
    return YES;
}

- (void)setDict:(NSMutableDictionary *)dict {
    _dict = [NSMutableDictionary dictionaryWithDictionary:dict];
}

#pragma mark - Lazyload

- (NSArray *)rowTitleArr {
    if (self.type == WineAlert) {
        _rowTitleArr = @[@"酒名",@"数量",@"单位"];
    } else if (self.type == CashierAlert || self.type == SijiuAlert) {
        _rowTitleArr = @[@"编号",@"名字",@"电话"];
    } else if(self.type == WaiterAlert) {
        _rowTitleArr = @[@"组别",@"编号",@"名字",@"电话",@"服务费"];
    } else if (self.type == CreatRoleAlert) {
        _rowTitleArr = @[@"角色名称",@"查询天数"];
    } else if (self.type == SingleAddAlert) {
        _rowTitleArr = @[@"员工解绑"];
    } else {
        _rowTitleArr = @[];
    }
    return _rowTitleArr;
}

- (NSArray *)placeHolderArr {
    if (self.type == WineAlert) {
        _placeHolderArr = @[@"请输入或选择",@"请输入或选择",@"请输入或选择"];
    } else if (self.type == CashierAlert || self.type == SijiuAlert) {
        _placeHolderArr = @[@"请输入或选择",@"请输入",@"请输入"];
    } else if (self.type == WaiterAlert) {
        _placeHolderArr = @[@"请输入或选择",@"请输入或选择",@"请输入或选择",@"请输入", @"请输入"];
    } else if (self.type == CreatRoleAlert) {
        _placeHolderArr = @[@"请输入角色名称",@"请输入最大可查询天数"];
    } else if (self.type == SingleAddAlert) {
        _placeHolderArr = @[@"请选择解绑员工"];
    } else {
        _placeHolderArr = @[];
    }
    return _placeHolderArr;
}

- (NSArray *)arrowImageArr {
    if (self.type == WineAlert) {
        _arrowImageArr = @[@"oDropDownBlack",@"",@""];
    } else if (self.type == CashierAlert || self.type == SijiuAlert) {
        _arrowImageArr = @[@"thinArrow",@"thinArrow",@"thinArrow"];
    } else if (self.type == WaiterAlert) {
        _arrowImageArr = @[@"thinArrow",@"thinArrow",@"thinArrow",@"thinArrow",@"thinArrow",@"thinArrow"];
    } else if (self.type == CreatRoleAlert) {
        _arrowImageArr = @[@"",@"",@"",@""];
    } else if (self.type == SingleAddAlert) {
        _arrowImageArr = @[@"thinArrow"];
    } else {
        _arrowImageArr = @[];
    }
    return _arrowImageArr;
}

- (NSArray *)keyBoradTypeArr {
    if (self.type == WineAlert) {
        _keyBoradTypeArr = @[@(UIKeyboardTypeDefault),@(UIKeyboardTypeDefault),@(UIKeyboardTypeDefault)];
    } else if (self.type == CashierAlert || self.type == SijiuAlert) {
        _keyBoradTypeArr = @[@(UIKeyboardTypeDefault),@(UIKeyboardTypeDefault),@(UIKeyboardTypePhonePad)];
    } else if (self.type == WaiterAlert) {
        _keyBoradTypeArr = @[@(UIKeyboardTypeDefault),@(UIKeyboardTypeDefault),@(UIKeyboardTypeDefault),@(UIKeyboardTypePhonePad),@(UIKeyboardTypePhonePad)];
    } else if (self.type == CreatRoleAlert) {
        _keyBoradTypeArr = @[@(UIKeyboardTypeDefault),@(UIKeyboardTypeNumberPad)];
    } else if (self.type == SingleAddAlert) {
        _keyBoradTypeArr = @[@(UIKeyboardTypeNumberPad)];
    } else {
        _keyBoradTypeArr = @[];
    }
    return _keyBoradTypeArr;
}

- (NSMutableArray *)contentArr {
    if (self.type == WineAlert) {
        if (!self.dict) {
            self.dict = [NSMutableDictionary dictionary];
             _contentArr = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
        } else {
            _contentArr = [NSMutableArray arrayWithArray:@[self.dict[@"酒名"]?self.dict[@"酒名"]:@"",self.dict[@"数量"]?self.dict[@"数量"]:@"",self.dict[@"单位"]?self.dict[@"单位"]:@""]];
        }
       
    } else if (self.type == CashierAlert || self.type == SijiuAlert) {
        if (!self.dict) {
            self.dict = [NSMutableDictionary dictionary];
            _contentArr = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
        } else {
            _contentArr = [NSMutableArray arrayWithArray:@[self.dict[@"员工代码"]?self.dict[@"员工代码"]:@"",self.dict[@"姓名"]?self.dict[@"姓名"]:@"",self.dict[@"手机"]?self.dict[@"手机"]:@""]];
        }
        
    } else if (self.type == WaiterAlert) {
        if (!self.dict) {
            self.dict = [NSMutableDictionary dictionary];
            _contentArr = [NSMutableArray arrayWithArray:@[@"",@"",@"",@""]];
        } else {
            _contentArr = [NSMutableArray arrayWithArray:@[self.dict[@"部门名称"]?self.dict[@"部门名称"]:@"",self.dict[@"员工代码"]?self.dict[@"员工代码"]:@"",self.dict[@"姓名"]?self.dict[@"姓名"]:@"",self.dict[@"手机"]?self.dict[@"手机"]:@"",self.dict[@"小费"]?self.dict[@"小费"]:@""]];
        }
        
    } else if (self.type == CreatRoleAlert) {
        if (!self.dict) {
            self.dict = [NSMutableDictionary dictionary];
            _contentArr = [NSMutableArray arrayWithArray:@[@"",@""]];
        } else {
            _contentArr = [NSMutableArray arrayWithArray:@[self.dict[@"角色"]?self.dict[@"角色"]:@"",self.dict[@"天数"]?self.dict[@"天数"]:@""]];
        }
    } else if (self.type == SingleAddAlert) {
        if (!self.dict) {
            self.dict = [NSMutableDictionary dictionary];
            _contentArr = [NSMutableArray arrayWithArray:@[@""]];
        } else {
            _contentArr = [NSMutableArray arrayWithArray:@[self.dict[@"手机"]?self.dict[@"手机"]:@""]];
        }
    }
    return _contentArr;
}

@end

@interface RoomNoteAlertCell ()

@end

@implementation RoomNoteAlertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowColor = [HexColor(@"#0A0D2F") colorWithAlphaComponent:0.05].CGColor;
        self.layer.shadowOffset = CGSizeMake(8, 8);
        self.layer.shadowOpacity = 0.5;
        
        UIView *contentV = [UIView new];
        contentV.layer.cornerRadius = 4;
        contentV.backgroundColor = HEX_FFF;
        [self.contentView addSubview:contentV];
        [contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 9, 5, 9));
        }];
        
        self.titleLa = [UILabel new];
        self.titleLa.font = SYS_FONT(16);
        self.titleLa.textColor = HEX_333;
        [contentV addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(contentV);
            make.left.equalTo(contentV).offset(34);
            make.width.equalTo(contentV.mas_width).multipliedBy(0.3);
        }];
        
        self.tf = [UITextField new];
        self.tf.textColor = HEX_333;
        self.tf.font = SYS_FONT(16);
        self.tf.adjustsFontSizeToFitWidth = YES;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 60)];
        self.tf.leftView = leftView;
        self.tf.leftViewMode = UITextFieldViewModeAlways;
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 60)];
        self.dropBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
        self.dropBtn.image = @"oDropDownBlack";
        self.dropBtn.center = rightView.center;
        [rightView addSubview:self.dropBtn];
        self.tf.rightView = rightView;
        self.tf.rightViewMode = UITextFieldViewModeNever;
        [contentV addSubview:self.tf];
        [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentV).offset(-10);
            make.top.bottom.equalTo(contentV);
            make.left.equalTo(self.titleLa.mas_right);
        }];
        
        LineView *line = [[LineView alloc] init];
        line.backgroundColor = HexColor(@"#E9E9E9");
        [contentV addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.tf);
            make.width.mas_equalTo(0.5);
        }];
    }
    return self;
}

@end
