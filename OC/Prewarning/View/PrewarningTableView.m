//
//  PrewarningTableView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/5/31.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "PrewarningTableView.h"
#import "PCHeader.h"
#import "ImageSketcherTool.h"
@interface PrewarningTableView () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation PrewarningTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.readedSubject = [RACSubject subject];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = HEX_FFF;
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
    static NSString *identifier = @"PrewarningCell";
    PrewarningCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PrewarningCell alloc] initWithStyle:0 reuseIdentifier:identifier];
    }
    cell.dict = _dataArr[indexPath.row];
    cell.readedBtn.hidden = !self.hasReaded;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 10)];
    v.backgroundColor = HEX_FFF;
    return v;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *actionDelet = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:PREWARNING_MANAGER.latestPrewarningList];
        [mArr removeObject:self->_dataArr[indexPath.row]];
        
        if (self.hasReaded) {
            NSMutableArray *rArr = [NSMutableArray arrayWithArray:PREWARNING_MANAGER.prewarningList];
            [rArr removeObject:self->_dataArr[indexPath.row]];
            PREWARNING_MANAGER.prewarningList = rArr;
            self.dataArr = rArr;
        } else {
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:PREWARNING_MANAGER.latestPrewarningList];
            [mArr removeObject:self->_dataArr[indexPath.row]];
            PREWARNING_MANAGER.latestPrewarningList = mArr;
            self.dataArr = mArr;
        }
        [self.readedSubject sendNext:nil];
    }];
    
    UITableViewRowAction *actionReaded = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"已读" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:PREWARNING_MANAGER.latestPrewarningList];
        [mArr removeObject:self->_dataArr[indexPath.row]];
        NSMutableArray *rArr = [NSMutableArray arrayWithArray:PREWARNING_MANAGER.prewarningList];
        [rArr addObject:self->_dataArr[indexPath.row]];
        PREWARNING_MANAGER.prewarningList = rArr;
        PREWARNING_MANAGER.latestPrewarningList = mArr;
        self.dataArr = mArr;
        [self.readedSubject sendNext:nil];
    }];
    
    return @[actionReaded, actionDelet];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    
    UIContextualAction *deletAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        if (self.hasReaded) {
            NSMutableArray *rArr = [NSMutableArray arrayWithArray:PREWARNING_MANAGER.prewarningList];
            [rArr removeObject:self->_dataArr[indexPath.row]];
            PREWARNING_MANAGER.prewarningList = rArr;
            self.dataArr = rArr;
        } else {
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:PREWARNING_MANAGER.latestPrewarningList];
            [mArr removeObject:self->_dataArr[indexPath.row]];
            PREWARNING_MANAGER.latestPrewarningList = mArr;
            self.dataArr = mArr;
        }
        [self.readedSubject sendNext:nil];
    }];
    deletAction.backgroundColor = HexColor(@"#F9F9F9");
    deletAction.image = [[ImageSketcherTool shareTool] imageWithText:@"删除" textColor:UIColor.whiteColor font:SYS_FONT(16) backgrouColor:[UIColor colorWithRed:253/255. green:61/255. blue:49/255. alpha:1] size:CGSizeMake(74, 31)];//[UIImage imageNamed:@"prewarning_delet"]
    
    UIContextualAction *readedAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:PREWARNING_MANAGER.latestPrewarningList];
        [mArr removeObject:self->_dataArr[indexPath.row]];
        NSMutableArray *rArr = [NSMutableArray arrayWithArray:PREWARNING_MANAGER.prewarningList];
        [rArr addObject:self->_dataArr[indexPath.row]];
        PREWARNING_MANAGER.prewarningList = rArr;
        PREWARNING_MANAGER.latestPrewarningList = mArr;
        self.dataArr = mArr;
        [self.readedSubject sendNext:nil];
    }];
    readedAction.backgroundColor = HexColor(@"#F9F9F9");
    readedAction.image = [[ImageSketcherTool shareTool] imageWithText:@"已阅" textColor:[UIColor colorWithRed:10/255. green:13/255. blue:47/255. alpha:1] font:SYS_FONT(16) backgrouColor:HEX_FFF size:CGSizeMake(74, 31)];//[UIImage imageNamed:@"prewarning_readed"]
    if (self.hasReaded) {
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deletAction]];
        return config;
    } else {
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deletAction, readedAction]];
        return config;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end


@interface PrewarningCell ()

@property (nonatomic, strong) UILabel *contentLa, *timeLa;

@property (nonatomic, strong) UIButton *typeBtn;

@end

@implementation PrewarningCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.backgroundColor = HexColor(@"#F9F9F9");
        self.typeBtn = [UIButton new];
        self.typeBtn.backgroundColor = HexColor(@"#309BFF");
        self.typeBtn.image = @"prewarning_alarm";
        self.typeBtn.titleColor = HEX_FFF;
        self.typeBtn.titleLabel.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",self.typeBtn.titleLabel.font.fontName) size:15];
        self.typeBtn.layer.cornerRadius = 20;
        self.typeBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:self.typeBtn];
        [self.typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        UIImageView *imgv = [[UIImageView alloc] initWithImage:[[ImageSketcherTool shareTool] leftTrangleSideLength:4]];
        [self.contentView addSubview:imgv];
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.typeBtn.mas_right).offset(6.5);
            make.centerY.equalTo(self.typeBtn);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        UIView *cView = [[UIView alloc] init];
        cView.backgroundColor = HEX_FFF;
        [self.contentView addSubview:cView];
        [cView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgv.mas_right);
            make.top.equalTo(self.contentView).offset(10.5);
            make.bottom.equalTo(self.contentView).offset(-10.5);
            make.right.equalTo(self.contentView).offset(-18.5);
        }];
        
        self.contentLa = [UILabel new];
        self.contentLa.font = SYS_FONT(14);
        self.contentLa.textColor = HEX_333;
        self.contentLa.numberOfLines = 1;
        [cView addSubview:self.contentLa];
        [self.contentLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cView).offset(12.5);
            make.top.equalTo(cView).offset(12);
            make.right.equalTo(cView).offset(-17.5);
        }];
        
        self.readedBtn = [UIButton new];
        self.readedBtn.titleLabel.font = SYS_FONT(12);
        self.readedBtn.title = @"已阅";
        self.readedBtn.titleColor = HEX_999;
        self.readedBtn.layer.cornerRadius = 2;
        self.readedBtn.layer.masksToBounds = YES;
        self.readedBtn.layer.borderColor = HexColor(@"#E1E1E1").CGColor;
        self.readedBtn.layer.borderWidth = 1;
        self.readedBtn.userInteractionEnabled = NO;
        [cView addSubview:self.readedBtn];
        [self.readedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentLa);
            make.top.equalTo(self.contentLa.mas_bottom).offset(7.5);
            make.size.mas_equalTo(CGSizeMake(34, 15));
        }];
        
        self.timeLa = [UILabel new];
        self.timeLa.font = SYS_FONT(11);
        self.timeLa.textColor = HEX_999;
        self.timeLa.textAlignment = NSTextAlignmentRight;
        [cView addSubview:self.timeLa];
        [self.timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentLa.mas_right);
            make.centerY.equalTo(self.readedBtn);
            make.size.mas_equalTo(CGSizeMake(70, 11));
        }];
        
        
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    NSLog(@"%@", dict);
    self.contentLa.text = dict[@"content"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM.dd HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *tempStr = dict[@"times"];
    NSLog(@"%d",[tempStr intValue]);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[tempStr integerValue]];
    NSString *timeStr = [formatter stringFromDate:date];
    self.timeLa.text = timeStr;
}


@end
