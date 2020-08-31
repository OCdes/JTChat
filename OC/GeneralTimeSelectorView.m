//
//  GeneralTimeSelectorView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/7/22.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "GeneralTimeSelectorView.h"
#import "GeneralTimeManager.h"
#import "GeneralPickerView.h"
#import "PCHeader.h"
#import "ETFTool.h"
@interface GeneralTimeSelectorView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) GeneralPickerView *pickerView;

@property (nonatomic, strong) UIButton *cancleBtn, *sureBtn, *startBtn, *endBtn;

@property (nonatomic, strong) UILabel *startTimeLa, *endTimeLa, *titleLa1, *titleLa2;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) NSInteger type;//0 周选择器， 1 月选择器， 2 日选择器, 3 自定义日期选择器

@property (nonatomic, strong) NSArray *years, *secondArr, *thirdArr;

@property (nonatomic, strong) NSString *day, *month, *year, *week;

@end

@implementation GeneralTimeSelectorView

- (instancetype)initWeeksPickWithFrame:(CGRect)frame {
//    frame.origin.y = Screen_Height;
    if (self = [super initWithFrame:frame]) {
        self.sureSubject = [RACSubject subject];
        self.type = 0;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *contentView = [UIView new];
        contentView.backgroundColor = UIColor.whiteColor;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        layer.bounds = contentView.bounds;
        contentView.layer.mask = layer;
        
        UILabel *titleLa = [UILabel new];
        titleLa.textColor = UIColor.blackColor;
        titleLa.font = [UIFont systemFontOfSize:13];
        titleLa.text = @"选择日期为";
        [self addSubview:titleLa];
        [titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self).offset(25);
            make.size.mas_equalTo(CGSizeMake(150, 13));
        }];
        
        [self addSubview:self.startTimeLa];
        [self.startTimeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLa.mas_left);
            make.top.equalTo(titleLa.mas_bottom).offset(13);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(13);
        }];
        
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self.startTimeLa.mas_bottom).offset(33);
            make.bottom.equalTo(self).offset(-116);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = HEX_LIGHTBLUE;
        line.layer.cornerRadius = 2;
        line.layer.masksToBounds = YES;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self.pickerView);
            make.size.mas_equalTo(CGSizeMake(4, 20));
        }];
        
        CGFloat width = (self.frame.size.width-93)/2.;
        [self addSubview:self.cancleBtn];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self.pickerView.mas_bottom).offset(40);
            make.size.mas_equalTo(CGSizeMake(width, 44));
        }];
        
        [self addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancleBtn.mas_right).offset(53);
            make.size.top.equalTo(self.cancleBtn);
        }];
        
    }
    return self;
}

- (instancetype)initMonthsPickWithFrame:(CGRect)frame {
    frame.origin.y = Screen_Height;
    if (self = [super initWithFrame:frame]) {
        self.sureSubject = [RACSubject subject];
        self.type = 1;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *contentView = [UIView new];
        contentView.backgroundColor = UIColor.whiteColor;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        layer.bounds = contentView.bounds;
        contentView.layer.mask = layer;
        
        UILabel *titleLa = [UILabel new];
        titleLa.textColor = UIColor.blackColor;
        titleLa.font = [UIFont systemFontOfSize:13];
        titleLa.text = @"选择日期为";
        [self addSubview:titleLa];
        [titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self).offset(25);
            make.size.mas_equalTo(CGSizeMake(150, 13));
        }];
        
        [self addSubview:self.startTimeLa];
        [self.startTimeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLa.mas_left);
            make.top.equalTo(titleLa.mas_bottom).offset(13);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(13);
        }];
        
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self.startTimeLa.mas_bottom).offset(33);
            make.bottom.equalTo(self).offset(-116);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = HEX_LIGHTBLUE;
        line.layer.cornerRadius = 2;
        line.layer.masksToBounds = YES;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self.pickerView);
            make.size.mas_equalTo(CGSizeMake(4, 20));
        }];
        
        CGFloat width = (self.frame.size.width-93)/2.;
        [self addSubview:self.cancleBtn];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self.pickerView.mas_bottom).offset(40);
            make.size.mas_equalTo(CGSizeMake(width, 44));
        }];
        
        [self addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancleBtn.mas_right).offset(53);
            make.size.top.equalTo(self.cancleBtn);
        }];
    }
    return self;
}

- (instancetype)initDaysPickWithFrame:(CGRect)frame {
    frame.origin.y = Screen_Height;
    if (self = [super initWithFrame:frame]) {
        self.sureSubject = [RACSubject subject];
        self.type = 2;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *contentView = [UIView new];
        contentView.backgroundColor = UIColor.whiteColor;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        layer.bounds = contentView.bounds;
        contentView.layer.mask = layer;
        
        self.titleLa1 = [UILabel new];
        self.titleLa1.textColor = HEX_LIGHTBLUE;
        self.titleLa1.font = [UIFont systemFontOfSize:13];
        self.titleLa1.text = @"开始日期";
        [self addSubview:self.titleLa1];
        [self.titleLa1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self).offset(25);
            make.size.mas_equalTo(CGSizeMake(60, 13));
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = HexColor(@"#f5f5f5");
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(10);
            make.size.mas_equalTo(CGSizeMake(2, 65));
        }];
        
        self.titleLa2 = [UILabel new];
        self.titleLa2.textColor = HEX_999;
        self.titleLa2.font = [UIFont systemFontOfSize:13];
        self.titleLa2.text = @"结束日期";
        [self addSubview:self.titleLa2];
        [self.titleLa2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line).offset(50);
            make.top.equalTo(self.titleLa1);
            make.size.mas_equalTo(CGSizeMake(60, 13));
        }];
        
        [self addSubview:self.startTimeLa];
        [self.startTimeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa1.mas_left);
            make.top.equalTo(self.titleLa1.mas_bottom).offset(13);
            make.right.equalTo(line.mas_left).offset(-20);
            make.height.mas_equalTo(13);
        }];
        
        [self addSubview:self.endTimeLa];
        [self.endTimeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa2.mas_left);
            make.top.equalTo(self.titleLa2.mas_bottom).offset(13);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(13);
        }];
        
        [self addSubview:self.startBtn];
        [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.titleLa1);
            make.size.mas_equalTo(CGSizeMake(40, 84));
        }];
        
        [self addSubview:self.endBtn];
        [self.endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.titleLa2);
            make.size.mas_equalTo(CGSizeMake(40, 84));
        }];
        
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self.startTimeLa.mas_bottom).offset(33);
            make.bottom.equalTo(self).offset(-116);
        }];
        
        UIView *line2 = [[UIView alloc] init];
        line2.backgroundColor = HEX_LIGHTBLUE;
        line2.layer.cornerRadius = 2;
        line2.layer.masksToBounds = YES;
        [self addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self.pickerView);
            make.size.mas_equalTo(CGSizeMake(4, 20));
        }];
        
        CGFloat width = (self.frame.size.width-93)/2.;
        [self addSubview:self.cancleBtn];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self.pickerView.mas_bottom).offset(40);
            make.size.mas_equalTo(CGSizeMake(width, 44));
        }];
        
        [self addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancleBtn.mas_right).offset(53);
            make.size.top.equalTo(self.cancleBtn);
        }];
    }
    return self;
}

- (instancetype)initDayPickWithFrame:(CGRect)frame {
    frame.origin.y = Screen_Height;
    if (self = [super initWithFrame:frame]) {
        self.sureSubject = [RACSubject subject];
        self.type =  3;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *contentView = [UIView new];
        contentView.backgroundColor = UIColor.whiteColor;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        layer.bounds = contentView.bounds;
        contentView.layer.mask = layer;
        
        self.titleLa1 = [UILabel new];
        self.titleLa1.textColor = UIColor.blackColor;
        self.titleLa1.font = [UIFont systemFontOfSize:13];
        self.titleLa1.text = @"当前选择日期";
        [self addSubview:self.titleLa1];
        [self.titleLa1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self).offset(25);
            make.size.mas_equalTo(CGSizeMake(150, 13));
        }];
        
        [self addSubview:self.startTimeLa];
        [self.startTimeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa1.mas_left);
            make.top.equalTo(self.titleLa1.mas_bottom).offset(13);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(13);
        }];
        
        [self addSubview:self.startBtn];
        [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.titleLa1);
            make.size.mas_equalTo(CGSizeMake(40, 84));
        }];
        
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self.startTimeLa.mas_bottom).offset(33);
            make.bottom.equalTo(self).offset(-116);
        }];
        
        UIView *line2 = [[UIView alloc] init];
        line2.backgroundColor = HEX_LIGHTBLUE;
        line2.layer.cornerRadius = 2;
        line2.layer.masksToBounds = YES;
        [self addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self.pickerView);
            make.size.mas_equalTo(CGSizeMake(4, 20));
        }];
        
        CGFloat width = (self.frame.size.width-93)/2.;
        [self addSubview:self.cancleBtn];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self.pickerView.mas_bottom).offset(40);
            make.size.mas_equalTo(CGSizeMake(width, 44));
        }];
        
        [self addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancleBtn.mas_right).offset(53);
            make.size.top.equalTo(self.cancleBtn);
        }];
    }
    return self;
}

- (instancetype)initInfinitDayPickWithFrame:(CGRect)frame {
    frame.origin.y = Screen_Height;
    if (self = [super initWithFrame:frame]) {
        self.sureSubject = [RACSubject subject];
        self.type =  4;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *contentView = [UIView new];
        contentView.backgroundColor = UIColor.whiteColor;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        layer.bounds = contentView.bounds;
        contentView.layer.mask = layer;
        
        self.titleLa1 = [UILabel new];
        self.titleLa1.textColor = UIColor.blackColor;
        self.titleLa1.font = [UIFont systemFontOfSize:13];
        self.titleLa1.text = @"当前选择日期";
        [self addSubview:self.titleLa1];
        [self.titleLa1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self).offset(25);
            make.size.mas_equalTo(CGSizeMake( 160, 13));
        }];
        
        [self addSubview:self.startTimeLa];
        [self.startTimeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa1.mas_left);
            make.top.equalTo(self.titleLa1.mas_bottom).offset(13);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(13);
        }];
        
        [self addSubview:self.startBtn];
        [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.titleLa1);
            make.size.mas_equalTo(CGSizeMake(40, 84));
        }];
        
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self.startTimeLa.mas_bottom).offset(33);
            make.bottom.equalTo(self).offset(-116);
        }];
        
        UIView *line2 = [[UIView alloc] init];
        line2.backgroundColor = HEX_LIGHTBLUE;
        line2.layer.cornerRadius = 2;
        line2.layer.masksToBounds = YES;
        [self addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self.pickerView);
            make.size.mas_equalTo(CGSizeMake(4, 20));
        }];
        
        CGFloat width = (self.frame.size.width-93)/2.;
        [self addSubview:self.cancleBtn];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self.pickerView.mas_bottom).offset(40);
            make.size.mas_equalTo(CGSizeMake(width, 44));
        }];
        
        [self addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancleBtn.mas_right).offset(53);
            make.size.top.equalTo(self.cancleBtn);
        }];
    }
    return self;
}

- (instancetype)init3yearsWithFrame:(CGRect)frame {
    frame.origin.y = Screen_Height;
    if (self = [super initWithFrame:frame]) {
        self.sureSubject = [RACSubject subject];
        self.type =  5;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *contentView = [UIView new];
        contentView.backgroundColor = UIColor.whiteColor;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        layer.bounds = contentView.bounds;
        contentView.layer.mask = layer;
        
        self.titleLa1 = [UILabel new];
        self.titleLa1.textColor = UIColor.blackColor;
        self.titleLa1.font = [UIFont systemFontOfSize:13];
        self.titleLa1.text = @"当前选择日期";
        [self addSubview:self.titleLa1];
        [self.titleLa1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self).offset(25);
            make.size.mas_equalTo(CGSizeMake(160, 13));
        }];
        
        [self addSubview:self.startTimeLa];
        [self.startTimeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa1.mas_left);
            make.top.equalTo(self.titleLa1.mas_bottom).offset(13);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(13);
        }];
        
        [self addSubview:self.startBtn];
        [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.titleLa1);
            make.size.mas_equalTo(CGSizeMake(40, 84));
        }];
        
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self.startTimeLa.mas_bottom).offset(33);
            make.bottom.equalTo(self).offset(-116);
        }];
        
        CGFloat width = (self.frame.size.width-93)/2.;
        [self addSubview:self.cancleBtn];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self.pickerView.mas_bottom).offset(40);
            make.size.mas_equalTo(CGSizeMake(width, 44));
        }];
        
        [self addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancleBtn.mas_right).offset(53);
            make.size.top.equalTo(self.cancleBtn);
        }];
    }
    return self;
}

- (void)setStartTitleStr:(NSString *)startTitleStr {
    _startTitleStr = startTitleStr;
    self.titleLa1.text = startTitleStr;
}

#pragma mark - UIPickerViewDelegate&DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return (self.type == 2 || self.type == 3 || self.type == 4 ) ? 3 : 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.years.count;
    } else if (component == 1) {
        return _secondArr.count;
    } else if (component == 2) {
        return _thirdArr.count;
    } else {
        return 0;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return (self.type == 2 || self.type == 3 || self.type == 4) ? (self.frame.size.width-40)/3. : (self.frame.size.width-40)/2.;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 52;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *reView = (UILabel *)view;
    if (!reView) {
        reView = [[UILabel alloc] init];
        reView.font = SYS_FONT(15);
        reView.adjustsFontSizeToFitWidth = YES;
        reView.textAlignment = NSTextAlignmentCenter;
    }
    if (component == 0) {
        NSString *y = self.type == 5 ? NSStringFormate(@"%@",self.years[row]) : NSStringFormate(@"%@年",self.years[row]);
        NSMutableAttributedString *mAstr = [[NSMutableAttributedString alloc] initWithString:y attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
        NSRange range = [y rangeOfString:NSStringFormate(@"%@",self.years[row])];
        [mAstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]} range:range];
        reView.attributedText = mAstr;
    } else if (component == 1) {
        if (self.type == 5) {
            reView.text = self.secondArr[row];
        } else {
            GeneralTimeModel *model = self.secondArr[row];
            reView.attributedText = model.asContent;
        }
    } else if (component == 2) {
        reView.attributedText = self.thirdArr[row];
    }
    return reView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy.MM.dd";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    formatter2.dateFormat = @"yyyy.MM.dd";
    formatter2.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    if (component == 0) {
        if (self.type == 0) {
            NSString *dateStr = self.years[row];
            dateStr = [dateStr stringByAppendingString:@"-01-01"];
            NSDate *date = [formatter dateFromString:dateStr];
            self.secondArr = [[GeneralTimeManager manager] getWeeksOfYear:date];
            GeneralTimeModel *model = self.secondArr[0];
            self.startTimeLa.text = NSStringFormate(@"%@-%@",[formatter2 stringFromDate: model.startDate],[formatter2 stringFromDate: model.endDate]);
            self.week = model.num;
            self.year = model.year;
        } else if (self.type == 1) {
            NSString *dateStr = self.years[row];
            dateStr = [dateStr stringByAppendingString:@"-01-01"];
            NSDate *date = [formatter dateFromString:dateStr];
            self.secondArr = [[GeneralTimeManager manager] getMonthsOfYear:date];
            GeneralTimeModel *model = self.secondArr[0];
            self.startTimeLa.text = NSStringFormate(@"%@-%@",[formatter2 stringFromDate: model.startDate],[formatter2 stringFromDate: model.endDate]);
            self.month = model.num;
            self.year = model.year;
        } else if (self.type == 2) {
            NSString *dateStr = self.years[row];
            dateStr = [dateStr stringByAppendingString:@"-01-01"];
            NSDate *date = [formatter dateFromString:dateStr];
            self.secondArr = [[GeneralTimeManager manager] getDaysOfYear:date];
            GeneralTimeModel *model = self.secondArr[0];
            self.thirdArr = model.days;
            if (self.startBtn.selected) {
                self.startTimeLa.text = NSStringFormate(@"%@",[formatter2 stringFromDate: model.startDate]);
            } else {
                if ([[ETFTool new] numberOfDaysWithFromDate:[formatter dateFromString:self.startTimeLa.text] toDate:model.startDate] <= [[[NSUserDefaults standardUserDefaults] objectForKey:@"MaxHistoryDays"] intValue]) {
                    self.endTimeLa.text = NSStringFormate(@"%@",[formatter2 stringFromDate: model.startDate]);
                } else {
                    
                }   
            }
        } else if (self.type == 3 ) {
            NSString *dateStr = self.years[row];
            dateStr = [dateStr stringByAppendingString:@"-01-01"];
            NSDate *date = [formatter dateFromString:dateStr];
            self.secondArr = [[GeneralTimeManager manager] getDaysOfYear:date];
            GeneralTimeModel *model = self.secondArr[0];
            self.thirdArr = model.days;
            self.startTimeLa.text = NSStringFormate(@"%@",[formatter2 stringFromDate: model.startDate]);
        } else if (self.type == 4 ) {
            NSString *dateStr = self.years[row];
            dateStr = [dateStr stringByAppendingString:@"-01-01"];
            NSDate *date = [formatter dateFromString:dateStr];
            self.secondArr = [[GeneralTimeManager manager] getFutureDaysOfYear:date];
            GeneralTimeModel *model = self.secondArr[0];
            self.thirdArr = model.days;
            self.startTimeLa.text = NSStringFormate(@"%@",[formatter2 stringFromDate: model.startDate]);
        } else if (self.type == 5 ) {
            NSString *dateStr = self.years[row];
            self.year = dateStr;
           self.startTimeLa.text = NSStringFormate(@"%@  %@",dateStr,self.month);
       }
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        if (self.type == 2 || self.type == 3 || self.type == 4 ) {
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
        
    } else if (component == 1) {
        if (self.secondArr.count > row) {
            
            if (self.type == 2 ) {
                GeneralTimeModel *model = self.secondArr[row];
                self.year = model.year;
                NSString *dStr = [formatter2 stringFromDate:model.startDate];
                self.month = model.num;
                if (self.startBtn.selected) {
                    self.startTimeLa.text = dStr;
                } else {
                    if ([[ETFTool new] numberOfDaysWithFromDate:[formatter dateFromString:self.startTimeLa.text] toDate:model.startDate] <= [[[NSUserDefaults standardUserDefaults] objectForKey:@"MaxHistoryDays"] intValue]) {
                        self.endTimeLa.text = dStr;
                    } else {
//                        SHOW_ERROE(NSStringFormate(@"日期间隔不得超过%ld天", (long)USER_INFO.MaxHistoryDays));
                    }
                }
                self.thirdArr = model.days;
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:YES];
            } else if ( self.type == 3) {
                GeneralTimeModel *model = self.secondArr[row];
                self.year = model.year;
                self.month = model.num;
                self.startTimeLa.text = [formatter2 stringFromDate: model.startDate];
                self.thirdArr = model.days;
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:YES];
            } else if ( self.type == 4) {
                GeneralTimeModel *model = self.secondArr[row];
                self.year = model.year;
                self.month = model.num;
                self.startTimeLa.text = [formatter2 stringFromDate: model.startDate];
                self.thirdArr = model.days;
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:YES];
            } else if ( self.type == 5) {
               NSString *dateStr = self.secondArr[row];
                self.month = dateStr;
               self.startTimeLa.text = NSStringFormate(@"%@  %@",self.year,self.month);
           } else {
               GeneralTimeModel *model = self.secondArr[row];
               self.year = model.year;
                if (self.type == 0) {
                    self.week = model.num;
                } else {
                    self.month = model.num;
                }
                self.startTimeLa.text = NSStringFormate(@"%@-%@",[formatter2 stringFromDate: model.startDate], [formatter2 stringFromDate: model.endDate]);
            }
        }
    } else if (component == 2) {
        GeneralTimeModel *model = self.secondArr[[pickerView selectedRowInComponent:1]];
        self.year = model.year;
        self.month = model.month;
        if (model.days.count > row) {
            NSString *dStr = [formatter2 stringFromDate:model.startDate];
            NSString *rowStr = [model.days[row] string];
            rowStr = [rowStr stringByReplacingOccurrencesOfString:@"日" withString:@""];
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:[dStr componentsSeparatedByString:@"."]];
            [mArr replaceObjectAtIndex:2 withObject:rowStr];
            
            if (self.startBtn.selected) {
                self.startTimeLa.text = [mArr componentsJoinedByString:@"."];
            } else {
                if ([[ETFTool new] numberOfDaysWithFromDate:[formatter dateFromString:self.startTimeLa.text] toDate:[formatter dateFromString:[mArr componentsJoinedByString:@"."]]] <= [[[NSUserDefaults standardUserDefaults] objectForKey:@"MaxHistoryDays"] intValue]) {
                    self.endTimeLa.text = [mArr componentsJoinedByString:@"."];
                } else {
//                    SHOW_ERROE(NSStringFormate(@"日期间隔不得超过%ld天", (long)USER_INFO.MaxHistoryDays));
                }
            }
        }
    }
}

- (BOOL)anySubviewScrolling:(UIView *)v {
    if ([v isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)v;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    for (UIView *vi in v.subviews) {
        if ([self anySubviewScrolling:vi]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - ClickingEvents

- (void)sureBtnClicked:(UIButton *)btn {
    if ([self anySubviewScrolling:self.pickerView]) return;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    if (self.type == 2) {
        NSString *startStr = [self.startTimeLa.text stringByReplacingOccurrencesOfString:@"." withString:@"-"];
        NSString *endStr = [self.endTimeLa.text stringByReplacingOccurrencesOfString:@"." withString:@"-"];
        if (startStr.length && endStr.length) {
            if ([[ETFTool new] numberOfDaysWithFromDate:[formatter dateFromString:startStr] toDate:[formatter dateFromString:endStr]] <= [[[NSUserDefaults standardUserDefaults] objectForKey:@"MaxHistoryDays"] intValue] ) {
                GeneralTimeModel *model = [GeneralTimeModel new];
                model.startDate = [formatter dateFromString:startStr];
                model.endDate = [formatter dateFromString:endStr];
                model.year = self.year;
                model.month = self.month;
                [self.sureSubject sendNext:model];
                [self hide];
            } else {
//                SHOW_ERROE(NSStringFormate(@"日期间隔不得超过%ld天", (long)USER_INFO.MaxHistoryDays));
            }
        } else {
//            SHOW_ERROE(@"请补齐开始和结束时间");
        }
    } else if (self.type == 3 || self.type == 4 ) {
        if (self.startTimeLa.text.length) {
            NSString *startStr = [self.startTimeLa.text stringByReplacingOccurrencesOfString:@"." withString:@"-"];
            GeneralTimeModel *model = [GeneralTimeModel new];
            model.startDate = [formatter dateFromString:startStr];
            model.endDate = [formatter dateFromString:startStr];
            model.year = self.year;
            model.month = self.month;
            [self.sureSubject sendNext:model];
            [self hide];
        } else {
//            SHOW_ERROE(@"请选择日期");
        }
    } else if (self.type == 5) {
        GeneralTimeModel *model = [GeneralTimeModel new];
        model.year = self.startTimeLa.text;
        [self.sureSubject sendNext:model];
        [self hide];
    } else {
        if (self.startTimeLa.text.length) {
             NSArray *arr = [self.startTimeLa.text componentsSeparatedByString:@"-"];
            NSString *startStr = [arr[0] stringByReplacingOccurrencesOfString:@"." withString:@"-"];
            NSString *endStr = [arr[1] stringByReplacingOccurrencesOfString:@"." withString:@"-"];
            GeneralTimeModel *model = [GeneralTimeModel new];
            model.startDate = [formatter dateFromString:startStr];
            model.endDate = [formatter dateFromString:endStr];
            model.year = self.year;
            model.month = self.month;
            model.week = self.week;
            model.day = self.day;
            model.num = self.month.length ? self.month : self.week;
            [self.sureSubject sendNext:model];
            [self hide];
        } else {
//            SHOW_ERROE(@"请选择日期");
        }
    }
    
}

- (void)endBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.titleLa2.textColor = HEX_LIGHTBLUE;
    self.endTimeLa.textColor = HEX_333;
    self.startBtn.selected = NO;
    self.titleLa1.textColor = HEX_999;
    self.startTimeLa.textColor = HEX_999;
    if (!self.endTimeLa.text.length) {
        self.endTimeLa.text = self.startTimeLa.text;
    } else {
        self.dateStr = self.endTimeLa.text;
    }
    NSArray *dateArr = [self.endTimeLa.text componentsSeparatedByString:@"."];
   if (dateArr.count == 3) {
       NSInteger firstIndex = [self.years indexOfObject:dateArr[0]];
       NSInteger secontIndex = [dateArr[1] integerValue];
       NSInteger thirdIndex = [dateArr[2] integerValue];
       [self.pickerView selectRow:firstIndex inComponent:0 animated:YES];
       [self.pickerView selectRow:secontIndex-1 inComponent:1 animated:YES];
       [self.pickerView selectRow:thirdIndex-1 inComponent:2 animated:YES];
   }
}

- (void)startBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.titleLa1.textColor = HEX_LIGHTBLUE;
    self.startTimeLa.textColor = HEX_333;
    self.endBtn.selected = NO;
    self.titleLa2.textColor = HEX_999;
    self.endTimeLa.textColor = HEX_999;
    if (!self.startTimeLa.text.length) {
        self.startTimeLa.text = self.endTimeLa.text;
    } else {
        self.dateStr = self.startTimeLa.text;
    }
    NSArray *dateArr = [self.startTimeLa.text componentsSeparatedByString:@"."];
   if (dateArr.count == 3) {
       NSInteger firstIndex = [self.years indexOfObject:dateArr[0]];
       NSInteger secontIndex = [dateArr[1] integerValue];
       NSInteger thirdIndex = [dateArr[2] integerValue];
       [self.pickerView selectRow:firstIndex inComponent:0 animated:YES];
       [self.pickerView selectRow:secontIndex-1 inComponent:1 animated:YES];
       [self.pickerView selectRow:thirdIndex-1 inComponent:2 animated:YES];
   }
}

- (void)show {
    [APPWINDOW addSubview:self.bgView];
    [APPWINDOW addSubview:self];
    CGRect frame = CGRectMake(0, Screen_Height-self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
    }];
}

- (void)hide {
    CGRect frame = CGRectMake(0, Screen_Height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }];
}

- (void)setDateStr:(NSString *)dateStr {
    _dateStr = dateStr;
    if ((self.type == 3 || self.type == 4 || self.type == 5) && dateStr.length) {
        NSArray *arr = [dateStr componentsSeparatedByString:@"."];
        if (arr.count == 3) {
            NSInteger firstIndex = [self.years indexOfObject:arr[0]];
            NSInteger secontIndex = [arr[1] integerValue];
            NSInteger thirdIndex = [arr[2] integerValue];
            [self.pickerView selectRow:firstIndex inComponent:0 animated:YES];
            [self pickerView:self.pickerView didSelectRow:firstIndex inComponent:0];
            [self.pickerView selectRow:secontIndex-1 inComponent:1 animated:YES];
            [self pickerView:self.pickerView didSelectRow:secontIndex-1 inComponent:1];
            [self.pickerView selectRow:thirdIndex-1 inComponent:2 animated:YES];
            [self pickerView:self.pickerView didSelectRow:thirdIndex-1 inComponent:2];
        }
    } else {
        if (self.type == 2) {
            NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
            if (arr.count == 2) {
                self.startTimeLa.text = arr[0];
                self.endTimeLa.text = arr[1];
                NSArray *dateArr = [self.startBtn.selected ? self.startTimeLa.text : self.endTimeLa.text componentsSeparatedByString:@"."];
                
                if (dateArr.count == 3) {
                    NSInteger firstIndex = [self.years indexOfObject:dateArr[0]];
                    NSInteger secontIndex = [dateArr[1] integerValue];
                    NSInteger thirdIndex = [dateArr[2] integerValue];
                    [self.pickerView selectRow:firstIndex inComponent:0 animated:YES];
                    [self pickerView:self.pickerView didSelectRow:firstIndex inComponent:0];
                    [self.pickerView selectRow:secontIndex-1 inComponent:1 animated:YES];
                    [self pickerView:self.pickerView didSelectRow:secontIndex-1 inComponent:1];
                    [self.pickerView selectRow:thirdIndex-1 inComponent:2 animated:YES];
                    [self pickerView:self.pickerView didSelectRow:thirdIndex-1 inComponent:2];
                }
            }
        } else {
            NSArray *arr = [dateStr componentsSeparatedByString:@"."];
            if (arr.count == 2) {
                NSInteger firstIndex = [self.years indexOfObject:arr[0]];
                NSString *secondStr = arr[1];
                NSInteger secontIndex = 0;
                if (self.type == 0) {//周
                    secontIndex = [[[secondStr stringByReplacingOccurrencesOfString:@"第" withString:@""] stringByReplacingOccurrencesOfString:@"周" withString:@""] integerValue];
                } else {//月
                    secontIndex = [[secondStr stringByReplacingOccurrencesOfString:@"月" withString:@""] integerValue];
                }
                
                [self.pickerView selectRow:firstIndex inComponent:0 animated:YES];
                [self pickerView:self.pickerView didSelectRow:firstIndex inComponent:0];
                [self.pickerView selectRow:secontIndex-1 inComponent:1 animated:YES];
                [self pickerView:self.pickerView didSelectRow:secontIndex-1 inComponent:1];
            }
        }
    }
}

#pragma mark - LazyLoad

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.userInteractionEnabled = YES;
        _bgView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.7];

    }
    return _bgView;
}

- (UILabel *)startTimeLa {
    if (!_startTimeLa) {
        _startTimeLa = [UILabel new];
        _startTimeLa.font = [UIFont systemFontOfSize:13];
        _startTimeLa.textColor = HEX_333;
        _startTimeLa.numberOfLines = 2;
    }
    return _startTimeLa;
}

- (UILabel *)endTimeLa {
    if (!_endTimeLa) {
        _endTimeLa = [UILabel new];
        _endTimeLa.font = [UIFont systemFontOfSize:13];
        _endTimeLa.textColor = HEX_999;
        _endTimeLa.numberOfLines = 2;
    }
    return _endTimeLa;
}

- (GeneralPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[GeneralPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = HexColor(@"#F9F8F9");
        _pickerView.showsSelectionIndicator = YES;
        if (self.type != 4) {
            [_pickerView selectRow:self.years.count-1 inComponent:0 animated:YES];
            [self pickerView:_pickerView didSelectRow:self.years.count-1 inComponent:0];
        }
        if (self.type == 5) {
            NSDateFormatter *forma = [[NSDateFormatter alloc] init];
            forma.dateFormat = @"yyyy年MM月dd日 EEE";
             forma.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            NSString *curStr = [forma stringFromDate:[NSDate date]];
            self.year = curStr;
            NSInteger firstIndex = [self.years indexOfObject:curStr];
            forma.dateFormat = @"HH  时";
            NSString *curColock = [forma stringFromDate:[NSDate date]];
            self.month = curColock;
            NSInteger secondIndex = [self.secondArr indexOfObject:curColock];
            [_pickerView selectRow:firstIndex inComponent:0 animated:YES];
            [self pickerView:_pickerView didSelectRow:firstIndex inComponent:0];
            [_pickerView selectRow:secondIndex inComponent:1 animated:YES];
            [self pickerView:_pickerView didSelectRow:secondIndex inComponent:1];
        }
        if (self.type == 4) {
            [_pickerView selectRow:0 inComponent:0 animated:YES];
            [self pickerView:_pickerView didSelectRow:0 inComponent:0];
        }
    }
    return _pickerView;
}

- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton new];
        _cancleBtn.titleLabel.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",_cancleBtn.titleLabel.font.fontName) size:18];
        [_cancleBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancleBtn.backgroundColor = HEX_FFF;
        [_cancleBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        _sureBtn.titleLabel.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",_sureBtn.titleLabel.font.fontName) size:18];
        [_sureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.backgroundColor = HEX_LIGHTBLUE;
        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton new];
        [_startBtn addTarget:self action:@selector(startBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _startBtn.selected = YES;
    }
    return _startBtn;
}

- (UIButton *)endBtn {
    if (!_endBtn) {
        _endBtn = [UIButton new];
        [_endBtn addTarget:self action:@selector(endBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endBtn;
}

- (NSArray *)years {
    if (!_years) {
        NSMutableArray *mArr = [NSMutableArray array];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        NSString *dateStr = [formatter stringFromDate:date];
        NSInteger dateNum = [dateStr integerValue];
        NSInteger i = dateNum-20;
        for (; i<= dateNum; i++)
            [mArr addObject:NSStringFormate(@"%li",i)];
        _years = [NSArray arrayWithArray:mArr];
        NSString *dStr = self.years[0];
        dStr = [dStr stringByAppendingString:@"-01-01"];
        NSDateFormatter *forma = [[NSDateFormatter alloc] init];
        forma.dateFormat = @"yyyy-MM-dd";
         forma.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        NSDate *d = [forma dateFromString:dStr];
        self.year = [_years lastObject];
        if (self.type == 0) {
            self.secondArr = [[GeneralTimeManager manager] getWeeksOfYear:d];
            self.week = [self.secondArr[0] num];
        } else if (self.type == 1) {
            self.secondArr = [[GeneralTimeManager manager] getMonthsOfYear:d];
            self.month = [self.secondArr[0] num];
        } else if (self.type == 4) {
            NSMutableArray *yyMarr = [NSMutableArray array];
            NSInteger i = dateNum;
            for (; i < dateNum+2; i ++) {
                [yyMarr addObject:NSStringFormate(@"%li",i)];
            }
            _years = [NSArray arrayWithArray:yyMarr];
            self.year = [_years firstObject];
            self.secondArr = [[GeneralTimeManager manager] getFutureDaysOfYear:date];
            self.month = [self.secondArr[0] num];
            self.thirdArr = [self.secondArr[0] days];
        } else if (self.type == 5) {
            _years = [[GeneralTimeManager manager] getallDays];
            self.secondArr = @[@"01  时",@"02  时",@"03  时",@"04  时",@"05  时",@"06  时",@"07  时",@"08  时",@"09  时",@"10  时",@"11  时",@"12  时",@"13  时",@"14  时",@"15  时",@"16  时",@"17  时",@"18  时",@"19  时",@"20  时",@"21  时",@"22  时",@"23  时",@"24  时"];
        } else {
            self.secondArr = [[GeneralTimeManager manager] getDaysOfYear:d];
            self.month = [self.secondArr[0] num];
            self.thirdArr = [self.secondArr[0] days];
        }
    }
    return _years;
}

@end
