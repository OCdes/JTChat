//
//  GeneralSheetAlertView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/3/27.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "GeneralSheetAlertView.h"
#import "DropdownMenu.h"
#import "PCHeader.h"
@interface GeneralSheetAlertView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *bgV;

@end

@implementation GeneralSheetAlertView

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, Screen_Height, Screen_Width, 44);
        self.userInteractionEnabled = YES;
        self.backgroundColor = HEX_FFF;
        self.bgV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.bgV.backgroundColor = [HEX_333 colorWithAlphaComponent:0.3];
        self.bgV.alpha = 0.01;
        self.bgV.userInteractionEnabled = YES;
        [self.bgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
       
        self.tapItemSubject = [RACSubject subject];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(Screen_Width, 44);
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.minimumLineSpacing = 1;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, 95) collectionViewLayout:flowLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = HEX_FFF;
        [self.collectionView registerClass:[SheetCell class] forCellWithReuseIdentifier:@"SheetCell"];
        self.collectionView.scrollEnabled = NO;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 30, 0));
        }];
        
    }
    return self;
}

- (void)setTitleArr:(NSArray *)titleArr {
    _titleArr = titleArr;
    CGRect frame = self.frame;
    frame.size.height = titleArr.count*44 + 30;
    self.frame = frame;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate&UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SheetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SheetCell" forIndexPath:indexPath];
    if (indexPath.item != _titleArr.count-1) {
        ZiModel *model = _titleArr[indexPath.item];
        cell.contentStr = model.BlockName;
    } else {
        cell.contentStr = @"取消";
    }
    cell.btn.tag = indexPath.item;
    [cell.btn addTarget:self action:@selector(clicked:)];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)clicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.tag != _titleArr.count-1) {
        ZiModel *model = _titleArr[btn.tag];
        [self.tapItemSubject sendNext:model.BlockKey];
    }
    [self hide];
}

- (void)animation {
    [APPWINDOW addSubview:self.bgV];
    [APPWINDOW addSubview:self];
    CGRect frame = self.frame;
    frame.origin.y = Screen_Height - self.titleArr.count*44-31;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
        self.bgV.alpha = 1.0;
    }];
}

- (void)hide {
    CGRect frame = self.frame;
    frame.origin.y = Screen_Height;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
        self.bgV.alpha = 0.01;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.bgV removeFromSuperview];
    }];
}

@end

@interface SheetCell ()



@end

@implementation SheetCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.btn = [UIButton new];
        self.btn.selectedTitleColor = HEX_FFF;
        self.btn.titleColor = HEX_333;
        if (@available(iOS 9.0, *)) {
            [self.btn setBackgroundImage:[self imageWithColor:HexColor(@"#2E96F7")] forState:UIControlStateFocused];
        } else {
            // Fallback on earlier versions
            [self.btn setBackgroundImage:[self imageWithColor:HexColor(@"#2E96F7")] forState:UIControlStateSelected];
        }
        
        self.btn.titleLabel.font = SYS_FONT(17);
        
        [self.contentView addSubview:self.btn];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        LineView *line = [[LineView alloc] init];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setContentStr:(NSString *)contentStr {
    _contentStr = contentStr;
    self.btn.title = contentStr;
}

- (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.f, 1.f);
    // 开始画图的上下文
    UIGraphicsBeginImageContext(rect.size);
    
    // 设置背景颜色
    [color set];
    // 设置填充区域
    UIRectFill(CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // 返回UIImage
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
