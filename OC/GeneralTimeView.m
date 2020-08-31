//
//  GeneralTimeView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/7/23.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "GeneralTimeView.h"
#import "GeneralTimeSelectorView.h"
#import "GeneralTimeManager.h"
#import "DropdownMenu.h"
#import "GeneralDropHorizalView.h"
#import "NavDropButton.h"
#import "PCHeader.h"
@interface GeneralTimeView ()

@property (nonatomic, strong) UIButton *cateBtn, *upBtn, *downBtn, *timeBtn;

@property (nonatomic, strong) DropdownMenu *sortMenu;

@property (nonatomic, strong) GeneralDropHorizalView *dropView;

@property (nonatomic, strong) GeneralTimeSelectorView *dayTimeView, *daysTimeView, *weekTimeView, *monthTimeView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, strong) GeneralTimeModel *monthDate, *weekDate, *dayDate, *daysDate;

@end

@implementation GeneralTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat leftRightMargin = frame.size.width*0.11/5.;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        self.monthDate = [[GeneralTimeManager manager] getCurrentMonth];
        self.weekDate = [[GeneralTimeManager manager] getCurrentWeek];
        self.dayDate = [GeneralTimeModel new];
        NSString *businessdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"];
        self.dayDate.startDate = [dateFormatter dateFromString:businessdate];
        self.dayDate.endDate = [dateFormatter dateFromString:businessdate];
        self.daysDate = [GeneralTimeModel new];
        self.daysDate.startDate = [dateFormatter dateFromString:businessdate];
        self.daysDate.endDate = [dateFormatter dateFromString:businessdate];
        self.userInteractionEnabled = YES;
        self.bgView  = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTimeSelector)]];
        self.sortMenu = [[DropdownMenu alloc] initWithFrame:CGRectMake(leftRightMargin, frame.origin.y+frame.size.height, 0.24*frame.size.width, 176)];
        self.sortMenu.textColor = UIColor.blackColor;
        self.sortMenu.selectColor = UIColor.blackColor;
        self.sortMenu.dataArr = @[@"  按日  ",@"  按周  ",@"  按月  ",@"自定义"];
        self.sortMenu.seleKey = @"  按日  ";
        
        self.dropView = [[GeneralDropHorizalView alloc] initWithFrame:CGRectMake(0, frame.origin.y+frame.size.height+5, frame.size.width, 176)];
        self.dropView.dataArr = @[@"  按日  ",@"  按周  ",@"  按月  ",@"自定义"];
        self.dropView.seleKey = @"  按日  ";
        
        self.cateBtn = [[BorderBtn alloc] init];
        [self.cateBtn setTitle:@"  按日  " forState:UIControlStateNormal];
        [self.cateBtn setImage:[UIImage imageNamed:@"gray_down_small"] forState:UIControlStateNormal];
        [self.cateBtn sizeToFit];
        self.cateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.cateBtn.imageView.frame.size.width-self.cateBtn.frame.size.width+self.cateBtn.titleLabel.frame.size.width, 0, 0);
        self.cateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -self.cateBtn.titleLabel.frame.size.width-self.cateBtn.frame.size.width+self.cateBtn.imageView.frame.size.width);
        [self.cateBtn addTarget:self action:@selector(cateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cateBtn];
        [self.cateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(2*leftRightMargin);
            make.top.bottom.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(0.24*frame.size.width, frame.size.height));
        }];
        
        self.upBtn = [[BorderBtn alloc] init];
        [self.upBtn setTitle:@"上一天" forState:UIControlStateNormal];
        [self.upBtn setImage:[UIImage imageNamed:@"arrowUp"] forState:UIControlStateNormal];
//        self.upBtn.hidden = YES;
        [self.upBtn addTarget:self action:@selector(upBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.upBtn];
        [self.upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cateBtn.mas_right).offset(leftRightMargin);
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(self.frame.size.width*0.186);
        }];
        
        self.downBtn = [[BorderBtn alloc] init];
//        self.downBtn.hidden = YES;
        [self.downBtn setTitle:@"下一天" forState:UIControlStateNormal];
        [self.downBtn setImage:[UIImage imageNamed:@"arrowNext"] forState:UIControlStateNormal];
        [self.downBtn sizeToFit];
        self.downBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.downBtn.imageView.frame.size.width-self.downBtn.frame.size.width+self.downBtn.titleLabel.frame.size.width, 0, 0);
        self.downBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -self.downBtn.titleLabel.frame.size.width-self.downBtn.frame.size.width+self.downBtn.imageView.frame.size.width);
        [self.downBtn addTarget:self action:@selector(downBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.downBtn];
        [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-leftRightMargin*2);
            make.top.bottom.equalTo(self);
            make.width.equalTo(self.upBtn);
        }];
        
        self.timeBtn = [[BorderBtn alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy.MM.dd";
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [self.timeBtn setTitle:[formatter stringFromDate:self.dayDate.startDate] forState:UIControlStateNormal];
        [self.timeBtn addTarget:self action:@selector(timeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.timeBtn];
        [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.upBtn.mas_right).offset(leftRightMargin);
            make.right.equalTo(self.downBtn.mas_left).offset(-leftRightMargin);
            make.top.bottom.equalTo(self);
        }];
        
        RAC(self, titleStr) = RACObserve(self.timeBtn, currentTitle);
        @weakify(self);
        self.dayTimeView = [[GeneralTimeSelectorView alloc] initDaysPickWithFrame:CGRectMake(0, Screen_Height-451, Screen_Width, 451)];
        [self.dayTimeView.sureSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            GeneralTimeModel *model = (GeneralTimeModel *)x;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            formatter.dateFormat = @"yyyy.MM.dd";
            self.daysDate = model;
            NSString *str = [NSString stringWithFormat:@"%@-%@",[formatter stringFromDate:model.startDate], [formatter stringFromDate:model.endDate]];
            [self.timeBtn setTitle:str forState:UIControlStateNormal];
            if (self.timeChangeBlock) {
                self.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:model.startDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:model.endDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
            }
        }];
        
        self.daysTimeView = [[GeneralTimeSelectorView alloc] initDayPickWithFrame:CGRectMake(0, Screen_Height-451, Screen_Width, 451)];
        [self.daysTimeView.sureSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            GeneralTimeModel *model = (GeneralTimeModel *)x;
            self.dayDate = model;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            formatter.dateFormat = @"yyyy.MM.dd";
            [self.timeBtn setTitle:[formatter stringFromDate:model.startDate] forState:UIControlStateNormal];
            if (self.timeChangeBlock) {
                self.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:model.startDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:model.endDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
            }
        }];
        
        self.weekTimeView = [[GeneralTimeSelectorView alloc] initWeeksPickWithFrame:CGRectMake(0, Screen_Height-451, Screen_Width, 451)];
        [self.weekTimeView.sureSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            GeneralTimeModel *model = (GeneralTimeModel *)x;
            self.weekDate = model;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            formatter.dateFormat = @"yyyy.MM.dd";
            [self.timeBtn setTitle:[NSString stringWithFormat:@"%@.%@",model.year, model.num] forState:UIControlStateNormal];
            NSString *stStr = [[formatter stringFromDate:model.startDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"];
            NSString *endStr = [[formatter stringFromDate:model.endDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"];
            if (self.timeChangeBlock) {
                self.timeChangeBlock([NSString stringWithFormat:@"%@ %@",stStr, endStr]);
            }
        }];
        
        self.monthTimeView = [[GeneralTimeSelectorView alloc] initMonthsPickWithFrame:CGRectMake(0, Screen_Height-451, Screen_Width, 451)];
        [self.monthTimeView.sureSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            GeneralTimeModel *model = (GeneralTimeModel *)x;
            self.monthDate = model;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            formatter.dateFormat = @"yyyy.MM.dd";
            [self.timeBtn setTitle:[NSString stringWithFormat:@"%@.%@",model.year, model.num] forState:UIControlStateNormal];
            if (self.timeChangeBlock) {
                self.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:model.startDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:model.endDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
            }
        }];
    }
    return self;
}

- (void)timeBtnClicked:(UIButton *)btn {
    if ([self.cateBtn.currentTitle isEqualToString:@"自定义"]) {
        self.dayTimeView.dateStr = self.timeBtn.currentTitle;
        [self.dayTimeView show];
    } else if ([self.cateBtn.currentTitle isEqualToString:@"  按日  "]) {
        self.daysTimeView.dateStr = self.timeBtn.currentTitle;
        [self.daysTimeView show];
    } else if ([self.cateBtn.currentTitle isEqualToString:@"  按周  "]) {
        self.weekTimeView.dateStr = self.timeBtn.currentTitle;
        [self.weekTimeView show];
    } else if ([self.cateBtn.currentTitle isEqualToString:@"  按月  "]) {
        self.monthTimeView.dateStr = self.timeBtn.currentTitle;
        [self.monthTimeView show];
    }
}

- (void)downBtnClicked:(UIButton *)btn {
    if ([self.timeBtn.currentTitle isEqualToString:@"请选择"]) {
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy.MM.dd";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    if ([self.cateBtn.currentTitle isEqualToString:@"  按日  "]) {
        NSString *dateStr = self.timeBtn.currentTitle;
        NSDate *nextDate = [[formatter dateFromString:dateStr] dateByAddingTimeInterval:60*60*24];
        if ([nextDate compare:[formatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]]] == NSOrderedDescending) {
            
        } else {
            [self.timeBtn setTitle:[formatter stringFromDate:nextDate] forState:UIControlStateNormal];
            if (self.timeChangeBlock) {
                self.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:nextDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:nextDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
            }
        }
        
    } else if ([self.cateBtn.currentTitle isEqualToString:@"  按周  "]) {
        NSString *weekStr = [[self.timeBtn.currentTitle componentsSeparatedByString:@"."] lastObject];
        NSString *yearStr = [[[self.timeBtn.currentTitle componentsSeparatedByString:@"."] firstObject] stringByReplacingOccurrencesOfString:@"年" withString:@""];
        NSString *date = [NSString stringWithFormat:@"%@.01.01",yearStr];
        NSArray *weeks = [[GeneralTimeManager manager] getWeeksOfYear:[formatter dateFromString:date]];
        int weekNo = [[[weekStr stringByReplacingOccurrencesOfString:@"第" withString:@""] stringByReplacingOccurrencesOfString:@"周" withString:@""] intValue]+1;
        if (weekNo > weeks.count) {
            if (weeks.count < 53) {
                
            } else {
                NSString *nextDate = [NSString stringWithFormat:@"%i.01.01",[yearStr intValue]+1];
                NSArray *nextWeeks = [[GeneralTimeManager manager] getWeeksOfYear:[formatter dateFromString:nextDate]];
                GeneralTimeModel *model = nextWeeks[0];
                [self.timeBtn setTitle:[NSString stringWithFormat:@"%@.%@",model.year, model.num] forState:UIControlStateNormal];
                if (self.timeChangeBlock) {
                    self.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:model.startDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:model.endDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
                }
            }
            
        } else {
            GeneralTimeModel *model = weeks[weekNo-1];
            [self.timeBtn setTitle:[NSString stringWithFormat:@"%@.%@",model.year, model.num] forState:UIControlStateNormal];
            if (self.timeChangeBlock) {
                self.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:model.startDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:model.endDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
            }
        }
    } else if ([self.cateBtn.currentTitle isEqualToString:@"  按月  "]) {
        NSString *yearStr = [[[self.timeBtn.currentTitle componentsSeparatedByString:@"."] firstObject] stringByReplacingOccurrencesOfString:@"年" withString:@""];
        NSString *date = [NSString stringWithFormat:@"%@.01.01",yearStr];
        NSArray *months = [[GeneralTimeManager manager] getMonthsOfYear:[formatter dateFromString:date]];
        NSString *monthStr = [[self.timeBtn.currentTitle componentsSeparatedByString:@"."] lastObject];
        int monthNo = [[monthStr stringByReplacingOccurrencesOfString:@"月" withString:@""] intValue]+1;
        if (monthNo > months.count) {
            if (months.count < 12) {
                
            } else {
                NSString *nextDate = [NSString stringWithFormat:@"%i.01.01",[yearStr intValue]+1];
                NSArray *nextMonth = [[GeneralTimeManager manager] getMonthsOfYear:[formatter dateFromString:nextDate]];
                GeneralTimeModel *model = nextMonth[0];
                [self.timeBtn setTitle:[NSString stringWithFormat:@"%@.%@",model.year, model.num] forState:UIControlStateNormal];
                if (self.timeChangeBlock) {
                    self.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:model.startDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:model.endDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
                }
            }
            
        } else {
             GeneralTimeModel *model = months[monthNo-1];
            [self.timeBtn setTitle:[NSString stringWithFormat:@"%@.%@",model.year, model.num] forState:UIControlStateNormal];
            if (self.timeChangeBlock) {
                self.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:model.startDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:model.endDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
            }
        }
    }
}

- (void)upBtnClicked:(UIButton *)btn {
    if ([self.timeBtn.currentTitle isEqualToString:@"请选择"]) {
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy.MM.dd";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    if ([self.cateBtn.currentTitle isEqualToString:@"  按日  "]) {
        NSString *dateStr = self.timeBtn.currentTitle;
        NSDate *nextDate = [[formatter dateFromString:dateStr] dateByAddingTimeInterval:-60*60*24];
        [self.timeBtn setTitle:[formatter stringFromDate:nextDate] forState:UIControlStateNormal];
        if (self.timeChangeBlock) {
            self.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:nextDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:nextDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
        }
    } else if ([self.cateBtn.currentTitle isEqualToString:@"  按周  "]) {
        NSString *yearStr = [[[self.timeBtn.currentTitle componentsSeparatedByString:@"."] firstObject] stringByReplacingOccurrencesOfString:@"年" withString:@""];
        NSString *date = [NSString stringWithFormat:@"%@.01.01",yearStr];
        NSArray *weeks = [[GeneralTimeManager manager] getWeeksOfYear:[formatter dateFromString:date]];
        NSString *weekStr = [[self.timeBtn.currentTitle componentsSeparatedByString:@"."] lastObject];
        int weekNo = [[[weekStr stringByReplacingOccurrencesOfString:@"第" withString:@""] stringByReplacingOccurrencesOfString:@"周" withString:@""] intValue]-1;
        if (weekNo < 1) {
            NSString *nextDate = [NSString stringWithFormat:@"%i.01.01",[yearStr intValue]-1];
            NSArray *nextWeeks = [[GeneralTimeManager manager] getWeeksOfYear:[formatter dateFromString:nextDate]];
            GeneralTimeModel *model = [nextWeeks lastObject];
            [self.timeBtn setTitle:[NSString stringWithFormat:@"%@.%@",model.year, model.num] forState:UIControlStateNormal];
            if (self.timeChangeBlock) {
                self.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:model.startDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:model.endDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
            }
        } else {
            GeneralTimeModel *model = weeks[weekNo-1];
            [self.timeBtn setTitle:[NSString stringWithFormat:@"%@.%@",model.year, model.num] forState:UIControlStateNormal];
            if (self.timeChangeBlock) {
                self.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:model.startDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:model.endDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
            }
        }
    } else if ([self.cateBtn.currentTitle isEqualToString:@"  按月  "]) {
        NSString *yearStr = [[[self.timeBtn.currentTitle componentsSeparatedByString:@"."] firstObject] stringByReplacingOccurrencesOfString:@"年" withString:@""];
        NSString *date = [NSString stringWithFormat:@"%@.01.01",yearStr];
        NSArray *months = [[GeneralTimeManager manager] getMonthsOfYear:[formatter dateFromString:date]];
        NSString *monthStr = [[self.timeBtn.currentTitle componentsSeparatedByString:@"."] lastObject];
        int monthNo = [[monthStr stringByReplacingOccurrencesOfString:@"月" withString:@""] intValue]-1;
        if (monthNo < 1) {
            NSString *nextDate = [NSString stringWithFormat:@"%i.01.01",[yearStr intValue]-1];
            NSArray *nextMonth = [[GeneralTimeManager manager] getMonthsOfYear:[formatter dateFromString:nextDate]];
            GeneralTimeModel *model = [nextMonth lastObject];
            [self.timeBtn setTitle:[NSString stringWithFormat:@"%@.%@",model.year, model.num] forState:UIControlStateNormal];
            if (self.timeChangeBlock) {
                self.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:model.startDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:model.endDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
            }
        } else {
            GeneralTimeModel *model = months[monthNo-1];
            [self.timeBtn setTitle:[NSString stringWithFormat:@"%@.%@",model.year, model.num] forState:UIControlStateNormal];
            if (self.timeChangeBlock) {
                self.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:model.startDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:model.endDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
            }
        }
    }
}

- (void)cateBtnClicked:(UIButton *)btn {
    [self.dropView animationInView:self.superview];
    __weak typeof(self) weakSelf = self;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy.MM.dd";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    self.dropView.didSelectCallback = ^(NSInteger index, NSString *content) {
        [weakSelf.dropView hide];
        CGFloat leftRightMargin = weakSelf.frame.size.width*0.11/5.;
        if ([content isEqualToString:@"自定义"]) {
            [weakSelf.timeBtn setTitle:[NSString stringWithFormat:@"%@-%@",[formatter stringFromDate:weakSelf.daysDate.startDate], [formatter stringFromDate:weakSelf.daysDate.endDate]] forState:UIControlStateNormal];
            if (weakSelf.timeChangeBlock) {
                weakSelf.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[formatter stringFromDate:weakSelf.daysDate.startDate], [formatter stringFromDate:weakSelf.daysDate.endDate]]);
            }
            weakSelf.upBtn.hidden = YES;
            weakSelf.downBtn.hidden = YES;
            [weakSelf.timeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.upBtn);
                make.right.equalTo(weakSelf.downBtn);
                make.top.bottom.equalTo(weakSelf);
            }];
        } else {
            weakSelf.upBtn.hidden = NO;
            weakSelf.downBtn.hidden = NO;
            [weakSelf.timeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.upBtn.mas_right).offset(leftRightMargin);
                make.right.equalTo(weakSelf.downBtn.mas_left).offset(-leftRightMargin);
                make.top.bottom.equalTo(weakSelf);
            }];
            if ([content isEqualToString:@"  按日  "]) {
                [weakSelf.timeBtn setTitle:[formatter stringFromDate:weakSelf.dayDate.startDate] forState:UIControlStateNormal];
                if (weakSelf.timeChangeBlock) {
                    weakSelf.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:weakSelf.dayDate.startDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:weakSelf.dayDate.endDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
                }
                [weakSelf.upBtn setTitle:@"上一天" forState:UIControlStateNormal];
                [weakSelf.downBtn setTitle:@"下一天" forState:UIControlStateNormal];
            } else if ([content isEqualToString:@"  按周  "]) {
                [weakSelf.timeBtn setTitle:[NSString stringWithFormat:@"%@.%@",weakSelf.weekDate.year, weakSelf.weekDate.num] forState:UIControlStateNormal];
                if (weakSelf.timeChangeBlock) {
                    weakSelf.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:weakSelf.weekDate.startDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:weakSelf.weekDate.endDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
                }
                [weakSelf.upBtn setTitle:@"上一周" forState:UIControlStateNormal];
                [weakSelf.downBtn setTitle:@"下一周" forState:UIControlStateNormal];
            } else if ([content isEqualToString:@"  按月  "]) {
                [weakSelf.timeBtn setTitle:[NSString stringWithFormat:@"%@.%@",weakSelf.monthDate.year, weakSelf.monthDate.num] forState:UIControlStateNormal];
                if (weakSelf.timeChangeBlock) {
                    weakSelf.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:weakSelf.monthDate.startDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:weakSelf.monthDate.endDate] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
                }
                [weakSelf.upBtn setTitle:@"上一月" forState:UIControlStateNormal];
                [weakSelf.downBtn setTitle:@"下一月" forState:UIControlStateNormal];
            }
        }
        weakSelf.sortMenu.seleKey = content;
        [weakSelf.cateBtn setTitle:content forState:UIControlStateNormal];
        [weakSelf.sortMenu removeFromSuperview];
        [weakSelf.bgView removeFromSuperview];
    };
}

- (void)dismissTimeSelector {
    [self.sortMenu removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self.dropView hide];
}

- (void)setDate:(NSDate *)date {
    _date = date;
    if ([self.cateBtn.currentTitle isEqualToString:@"  按日  "]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy.MM.dd";
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        self.dayDate.startDate = date;
        self.dayDate.endDate = date;
        [self.timeBtn setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
        if (self.timeChangeBlock) {
            self.timeChangeBlock([NSString stringWithFormat:@"%@ %@",[[formatter stringFromDate:date] stringByReplacingOccurrencesOfString:@"." withString:@"-"], [[formatter stringFromDate:date] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]);
        }
    } else {
        
    }
}

@end


static BorderBtn *_btn;
@implementation BorderBtn

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = HexColor(@"#F8F5F9");
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = HexColor(@"#f6f6f6").CGColor;
        self.layer.borderWidth = 1.;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
    }
    return self;
}
@end
