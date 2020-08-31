//
//  ScrollBtnView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/3/20.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "ScrollBtnView.h"
#import "PCHeader.h"
@interface ScrollBtnView ()

{
    UIButton *_previousBtn;
}
@property (nonatomic, strong) LineView *scrollLine;

@property (nonatomic, assign) CGFloat width;

@end

@implementation ScrollBtnView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr {
    if (self = [super initWithFrame:frame]) {
        self.tapSubject = [RACSubject subject];
        self.width = frame.size.width/titleArr.count;
        self.backgroundColor = HexColor(@"#ECECEC");
        for (int i = 0; i < titleArr.count; i ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*self.width, 0, self.width, frame.size.height-1)];
            btn.tag = i;
            btn.backgroundColor = HEX_FFF;
            btn.titleColor = HEX_333;
            btn.selectedTitleColor = HexColor(@"#2E96F7");
            btn.titleLabel.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",btn.titleLabel.font.fontName) size:16];
            btn.title = titleArr[i];
            [btn addTarget:self action:@selector(btnClicked:)];
            LineView *line = [[LineView alloc] init];
            line.frame = CGRectMake(self.frame.size.width-1, 8, 1, frame.size.height-17);
            [btn addSubview:line];
            [self addSubview:btn];
            if (i == 0) {
                btn.selected = YES;
                _previousBtn = btn;
            }
        }
        
        self.scrollLine = [[LineView alloc] init];
        self.scrollLine.frame = CGRectMake(0, frame.size.height-1, self.width, 1);
        self.scrollLine.backgroundColor = HexColor(@"#2E96F7");
        [self addSubview:self.scrollLine];
    }
    return self;
}

- (instancetype)initOrderListWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr {
    if (self = [super initWithFrame:frame]) {
        self.tapSubject = [RACSubject subject];
        self.width = frame.size.width/titleArr.count;
        self.backgroundColor = HEX_FFF;
        for (int i = 0; i < titleArr.count; i ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*self.width, 0, self.width, frame.size.height-1)];
            btn.tag = i;
            btn.backgroundColor = HEX_FFF;
            btn.titleColor = HEX_333;
            btn.selectedTitleColor = HexColor(@"#2E96F7");
            btn.titleLabel.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",btn.titleLabel.font.fontName) size:16];
            btn.title = titleArr[i];
            [btn addTarget:self action:@selector(btnClicked:)];
            LineView *line = [[LineView alloc] init];
            line.backgroundColor = HexColor(@"#F8F5F9");
            line.frame = CGRectMake(self.frame.size.width-1, 8, 1, frame.size.height-17);
            [btn addSubview:line];
            [self addSubview:btn];
            if (i == 0) {
                btn.selected = YES;
                _previousBtn = btn;
            }
        }
        
        LineView *l = [[LineView alloc] init];
        l.frame = CGRectMake(0, frame.size.height-1, frame.size.width, 1);
        l.backgroundColor = HexColor(@"#ECECEC");
        [self addSubview:l];
        
        self.scrollLine = [[LineView alloc] init];
        self.scrollLine.frame = CGRectMake(0, frame.size.height-1, self.width, 1);
        self.scrollLine.backgroundColor = HexColor(@"#2E96F7");
        [self addSubview:self.scrollLine];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)relodaData:(NSArray *)titleArr {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            btn.title = titleArr[btn.tag];
        }
    }
}

- (void)btnClicked:(UIButton *)btn {
    _previousBtn.selected = !_previousBtn.selected;
    btn.selected = !btn.selected;
    _previousBtn = btn;
    CGRect frame = self.scrollLine.frame;
    frame.origin.x = btn.tag * self.width;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollLine.frame = frame;
    }];
    [self.tapSubject sendNext:@(btn.tag)];
}

@end
