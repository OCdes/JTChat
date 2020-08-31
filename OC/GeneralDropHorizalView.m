//
//  GeneralDropHorizalView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/3/20.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "GeneralDropHorizalView.h"
#import "PCHeader.h"
@interface GeneralDropHorizalView () <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSMutableArray *selectArr;

@property (nonatomic, assign) BOOL hasShown;

@end

@implementation GeneralDropHorizalView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hasShown = NO;
        self.hideSubject = [RACSubject subject];
        self.selectArr = [NSMutableArray array];
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, Screen_Width, Screen_Height)];
        self.bgView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        self.bgView.userInteractionEnabled = YES;
        self.bgView.alpha = 0.01;
        [self.bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)sender {
    [self hide];
}

- (void)resetFrame:(CGRect)frame {
    self.frame = frame;
    CGRect bFrame = self.bgView.frame;
    bFrame.origin.x = frame.origin.x;
    bFrame.origin.y = frame.origin.y;
    self.bgView.frame = bFrame;
}

- (void)animationInView:(UIView *)v {
    if (self.hasShown) {
        [self hide];
    } else {
        [v addSubview:self.bgView];
        [v addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 1.0;
        }];
        self.hasShown = YES;
    }
}

- (void)hide {
    if (self.hasShown) {
        [UIView animateWithDuration:0.1 animations:^{
            self.bgView.alpha = 0.01;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.bgView removeFromSuperview];
            self.hasShown = NO;
            [self.hideSubject sendNext:nil];
        }];
    }
    
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate&Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GeneralDropCell";
    GeneralDropCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GeneralDropCell alloc] initWithStyle:0 reuseIdentifier:identifier];
    }
    cell.contentStr = _dataArr[indexPath.row];
    if (!self.seleKey.length && indexPath.row == 0) {
        cell.isSelected = YES;
    } else {
        cell.isSelected = [_dataArr[indexPath.row] isEqualToString:self.seleKey];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
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
    self.seleKey = _dataArr[indexPath.row];
    [self.tableView reloadData];
    if (_didSelectCallback) {
        self.didSelectCallback(indexPath.row, self.seleKey);
    }
}


@end

@interface GeneralDropCell ()

@property (nonatomic, strong) UILabel *contentLa;

@property (nonatomic, strong) UIImageView *markImgV;

@end

@implementation GeneralDropCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.contentLa = [UILabel new];
        self.contentLa.font = SYS_FONT(14);
        self.contentLa.textColor = UIColor.lightGrayColor;
        [self.contentView addSubview:self.contentLa];
        [self.contentLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(24);
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-35);
        }];
        
        self.markImgV = [UIImageView new];
        self.markImgV.image = [UIImage imageNamed:@"dropMark"];
        self.markImgV.hidden = YES;
        [self.contentView addSubview:self.markImgV];
        [self.markImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-24);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(11, 8));
        }];
    }
    return self;
}

- (void)setContentStr:(NSString *)contentStr {
    _contentStr = contentStr;
    self.contentLa.text = contentStr;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        self.contentLa.textColor = HEX_LIGHTBLUE;
    } else {
        self.contentLa.textColor = HEX_999;
    }
    self.markImgV.hidden = !isSelected;
}

@end
