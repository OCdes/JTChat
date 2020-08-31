//
//  DropdownMenu.m
//  JingTeYuHui
//
//  Created by LJ on 2018/7/2.
//  Copyright © 2018年 WanCai. All rights reserved.
//

#import "DropdownMenu.h"
#import <Masonry/Masonry.h>
@interface DropdownMenu () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DropdownMenu

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    tableView.layer.cornerRadius = 5;
    tableView.layer.masksToBounds = YES;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = 0;
    tableView.estimatedRowHeight = 42;
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.tableView = tableView;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"menuCell"];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.tableView reloadData];
}

- (void)setSeleKey:(NSString *)seleKey {
    _seleKey = seleKey;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate&DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dropMenuCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"dropMenuCell"];
        cell.textLabel.numberOfLines = 2;
    }
    cell.textLabel.font = _textFont ? _textFont : [UIFont systemFontOfSize:14];
    if ([self.seleKey isEqualToString:_dataArr[indexPath.row]]) {
        cell.textLabel.textColor = _selectColor?_selectColor:UIColor.blackColor;
    } else {
        cell.textLabel.textColor = _textColor ? _textColor : UIColor.blackColor;
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.selectionStyle = NO;
    cell.textLabel.textAlignment = _textAligment?_textAligment: NSTextAlignmentLeft;
    cell.contentView.backgroundColor = self.menuBackgroudColor?self.menuBackgroudColor:[UIColor whiteColor];
    cell.textLabel.backgroundColor = self.menuBackgroudColor?self.menuBackgroudColor:[UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_didSelectCallback) {
        _didSelectCallback(indexPath.row, _dataArr[indexPath.row]);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

@end

@interface StoreDropdownMenu () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation StoreDropdownMenu


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    tableView.layer.cornerRadius = 5;
    tableView.layer.masksToBounds = YES;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = 0;
    tableView.estimatedRowHeight = 42;
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.tableView = tableView;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.tableView reloadData];
}

- (void)setSeleKey:(NSString *)seleKey {
    _seleKey = seleKey;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate&DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dropMenuCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"dropMenuCell"];
        cell.textLabel.numberOfLines = 2;
    }
    cell.textLabel.font = _textFont ? _textFont : [UIFont systemFontOfSize:14];
    if ([self.seleKey isEqualToString:[_dataArr[indexPath.row] objectForKey:@"代码"]]) {
        cell.textLabel.textColor = _selectColor?_selectColor:UIColor.blackColor;
    } else {
        cell.textLabel.textColor = _textColor ? _textColor : UIColor.blackColor;
    }
    cell.textLabel.text = [_dataArr[indexPath.row] objectForKey:@"名称"];
    cell.selectionStyle = NO;
    cell.textLabel.textAlignment = _textAligment?_textAligment: NSTextAlignmentLeft;
    cell.contentView.backgroundColor = self.menuBackgroudColor?self.menuBackgroudColor:[UIColor whiteColor];
    cell.textLabel.backgroundColor = self.menuBackgroudColor?self.menuBackgroudColor:[UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_didSelectCallback) {
        _didSelectCallback(indexPath.row, _dataArr[indexPath.row]);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

@end
