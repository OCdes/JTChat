//
//  PurchaseApplyTableView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/11.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "PurchaseApplyTableView.h"
#import "GeneralSheetAlertView.h"
#import "GeneralTimeSelectorView.h"
#import "GeneralTimeManager.h"
#import "GeneralWarningAlertView.h"
#import "GeneralScrollCateView.h"
#import "PCHeader.h"
#import <TZImagePickerController/TZImagePickerController.h>
@interface PurchaseApplyTableView () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *titleMArray, *requreMArray, *accessTypeArray, *placeHolderMArray, *contentMArray, *goodsMArr, *keyboardTypeMArr;

@property (nonatomic, strong) NSArray *detailTitleArray, *detailRequireArray, *detailAccessTypeArray, *detailPlaceHolderArray, *detailContentArray, *detailKeyboardTypeArr;

@end

@implementation PurchaseApplyTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = 0;
        self.goodsMArr = [NSMutableArray array];
        self.detailTitleArray = @[@"名称",@"规格",@"数量",@"单位",@"价格",@"备注"];
        self.detailRequireArray = @[@(1),@(1),@(1),@(1),@(1),@(0)];
        self.detailAccessTypeArray = @[@(UITableViewCellAccessoryNone),@(UITableViewCellAccessoryNone),@(UITableViewCellAccessoryNone),@(UITableViewCellAccessoryNone),@(UITableViewCellAccessoryNone),@(UITableViewCellAccessoryNone)];
        self.detailPlaceHolderArray = @[@"请输入",@"请输入",@"请输入",@"请输入",@"请输入",@"请输入"];
        self.detailKeyboardTypeArr = @[@(UIKeyboardTypeDefault),@(UIKeyboardTypeDefault),@(UIKeyboardTypeDefault),@(UIKeyboardTypeDefault),@(UIKeyboardTypeDefault),@(UIKeyboardTypeDefault)];
        self.titleMArray = [NSMutableArray arrayWithArray:@[@[@"申请事由"],@[@"采购类型"],@[@"期望交付日期"],self.detailTitleArray,@[@"增加"],@[@"审批流程"],@[@"抄送人"]]];
        self.requreMArray = [NSMutableArray arrayWithArray:@[@[@(1)],@[@(1)],@[@(1)],self.detailRequireArray,@[@(0)],@[@(1)],@[@(0)]]];
        self.keyboardTypeMArr = [NSMutableArray arrayWithArray:@[@[@(UIKeyboardTypeDefault)],@[@(UIKeyboardTypeDefault)],@[@(UIKeyboardTypeDefault)],self.detailKeyboardTypeArr,@[@(UIKeyboardTypeDefault)],@[@(UIKeyboardTypeDefault)],@[@(UIKeyboardTypeDefault)]]];
        self.accessTypeArray = [NSMutableArray arrayWithArray:@[@[@(UITableViewCellAccessoryNone)],@[@(UITableViewCellAccessoryDisclosureIndicator)],@[@(UITableViewCellAccessoryDisclosureIndicator)],self.detailAccessTypeArray,@[@(0)],@[@(UITableViewCellAccessoryNone)],@[@(UITableViewCellAccessoryNone)]]];
        self.placeHolderMArray = [NSMutableArray arrayWithArray:@[@[@"请输入"],@[@"请选择"],@[@"请选择"],self. detailPlaceHolderArray,@[@""],@[@""],@[@""]]];
        self.contentMArray = [NSMutableArray arrayWithArray:@[@[@""],@[@""],@[@""],[NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@""]],@[@""],@[@""],@[@""]]];
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 160)];\
        footerView.backgroundColor = [UIColor clearColor];
        UIButton *subBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 44, Screen_Width-30, 44)];
        [subBtn setTitle:@"提交" forState:UIControlStateNormal];
        subBtn.titleColor = HEX_FFF;
        subBtn.backgroundColor = HexColor(@"#2E96F7");
        subBtn.titleLabel.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",subBtn.titleLabel.font.fontName) size:19];
        subBtn.layer.cornerRadius = 5;
        subBtn.layer.masksToBounds = YES;
        [subBtn addTarget:self action:@selector(subBtnClicked:)];
        [footerView addSubview:subBtn];
        self.tableFooterView = footerView;
        if (@available(iOS 13.0, *)) {
            self.automaticallyAdjustsScrollIndicatorInsets = NO;
        } else {
            // Fallback on earlier versions
            if (@available(iOS 11.0, *)) {
                self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }
        }
    }
    return self;
}

- (void)subBtnClicked:(UIButton *)btn {
    [self.viewModel.submitApprove execute:nil];
    
}

- (void)setViewModel:(PurchaseApplyViewModel *)viewModel {
    _viewModel = viewModel;
    self.contentMArray = [NSMutableArray arrayWithArray:@[@[viewModel.applyReason?viewModel.applyReason:@""],@[viewModel.applyType?viewModel.applyType:@""],@[viewModel.applyDate?viewModel.applyDate:@""],[NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@""]],@[@""],@[@""],@[@""],@[@""]]];
    [self reloadData];
}

#pragma mark - TextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSIndexPath *indexPath = textField.indexPath;
    NSString *str = textField.text;
    NSString *titleStr = self.titleMArray[indexPath.section][indexPath.row];
    if ([titleStr isEqualToString:@"申请事由"]) {
        self.viewModel.applyReason = str;
        self.contentMArray[indexPath.section] = @[str];
    } else {
        self.contentMArray[indexPath.section][indexPath.row] = str;
        ApprovalGoodsModel *model = self.viewModel.goodsMArr[indexPath.section-3];
        if (indexPath.row == 0) {
            model.GoodsName = str;
        } else if (indexPath.row == 1) {
            model.GoodsModel = str;
        } else if (indexPath.row == 2) {
            model.Quantity = str;
        } else if (indexPath.row == 3) {
            model.Unit = str;
        } else if (indexPath.row == 4) {
            model.Price = str;
        } else {
            model.Remark = str;
        }
    }
}

#pragma mark - TextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    ApprovalGoodsModel *model = self.viewModel.goodsMArr[textView.indexPath.section-3];
    model.Remark = textView.text;
    self.contentMArray[textView.indexPath.section][textView.indexPath.row] = textView.text;
    [self reloadData];
}

#pragma mark - UITableViewDelegate&Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleMArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.titleMArray[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = self.titleMArray[indexPath.section][indexPath.row];
    BOOL require = [self.requreMArray[indexPath.section][indexPath.row] integerValue] == 1;
    NSInteger accessType = [self.accessTypeArray[indexPath.section][indexPath.row] integerValue];
    NSString *placeStr = self.placeHolderMArray[indexPath.section][indexPath.row];
    NSString *contentStr = self.contentMArray[indexPath.section][indexPath.row];
    UIKeyboardType keybType = [self.keyboardTypeMArr[indexPath.section][indexPath.row] integerValue];
    if ([titleStr isEqualToString:@"备注"]) {
        static NSString *identifier = @"PurchaseApplyNoteCell";
        PurchaseApplyNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PurchaseApplyNoteCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        cell.titleLa.text = titleStr;
        cell.requireLa.hidden = !require;
        cell.tv.indexPath = indexPath;
        cell.tv.delegate = self;
        cell.tv.text = contentStr;
        cell.tv.keyboardType = keybType;
        return cell;
    } else if ([titleStr isEqualToString:@"附件"]) {
        static NSString *identifier = @"PurchaseApplyPicCell";
        PurchaseApplyPicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PurchaseApplyPicCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        cell.titleLa.text = titleStr;
        cell.requireLa.hidden = !require;
        cell.collectionView.indexPath = indexPath;
        cell.collectionView.dataSource = self;
        cell.collectionView.delegate = self;
        [cell.collectionView reloadData];
        return cell;
    } else if ([titleStr isEqualToString:@"审批流程"]) {
        static NSString *identifier = @"PurchaseApplyApproveCell";
        PurchaseApplyApproveCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PurchaseApplyApproveCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        cell.titleLa.text = titleStr;
        cell.requireLa.hidden = !require;
        cell.collectionView.indexPath = indexPath;
        cell.collectionView.dataSource = self;
        cell.collectionView.delegate = self;
        [cell.collectionView reloadData];
        return cell;
    } else if ([titleStr isEqualToString:@"抄送人"]) {
        static NSString *identifier = @"ApplyCCListCell";
        ApplyCCListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ApplyCCListCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        cell.titleLa.text = titleStr;
        cell.requireLa.hidden = !require;
        cell.collectionView.indexPath = indexPath;
        cell.collectionView.dataSource = self;
        cell.collectionView.delegate = self;
        [cell.collectionView reloadData];
        return cell;
    } else if ([titleStr isEqualToString:@"增加"]) {
        static NSString *identifier = @"PurchaseGoodsAddCell";
        PurchaseGoodsAddCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PurchaseGoodsAddCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        return cell;
    } else {
        static NSString *identifier = @"PurchaseApplyCell";
        PurchaseApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PurchaseApplyCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        cell.titleLa.text = titleStr;
        cell.requireLa.hidden = [titleStr isEqualToString:@"申请事由"] ? YES : !require;
        cell.titleLa.hidden = [titleStr isEqualToString:@"申请事由"] ? YES : NO;
        cell.tf.hidden = [titleStr isEqualToString:@"申请事由"] ? YES : NO;
        cell.line.hidden = [self.titleMArray[indexPath.section] count] == 1;
        cell.tf.placeholder = placeStr;
        cell.tf.indexPath = indexPath;
        cell.tf.delegate = self;
        cell.tf.text = contentStr;
        cell.tf.userInteractionEnabled = !accessType;
        cell.accessoryType = accessType;
        cell.tf.keyboardType = keybType;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = self.titleMArray[indexPath.section][indexPath.row];
    if ([titleStr isEqualToString:@"备注"]) {
        return 120;
    } else if ([titleStr isEqualToString:@"附件"]) {
        NSInteger num = (Screen_Width-70)/58;
        CGFloat height = 52 + ((self.viewModel.noteMArr.count%num)?(self.viewModel.noteMArr.count/num+1):1)*58;
        return height;
    } else if ([titleStr isEqualToString:@"审批流程"]) {
           NSInteger num = (Screen_Width-95)/50;
           num = (num%2)?(num+1)/2:(num/2);
           return 55 + ((self.viewModel.approvalList.count%num)?(self.viewModel.approvalList.count/num+1):self.viewModel.approvalList.count/num)*67;
       } else if ([titleStr isEqualToString:@"抄送人"]) {
           NSInteger num = (Screen_Width-95)/50;
           return 55 + ((self.viewModel.ccList.count%num)?(self.viewModel.ccList.count/num+1):self.viewModel.ccList.count/num)*67;
       } else if ([titleStr isEqualToString:@"申请事由"]) {
           return 0.01;
       } else {
        return 44;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSArray *arr = self.titleMArray[section];
    if (arr.count>1) {
        return 39;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSArray *arr = self.titleMArray[section];
    if ([arr[0] isEqualToString:@"期望交付日期"]) {
        return 0.01;
    } else {
       return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *arr = self.titleMArray[section];
    if (arr.count>1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 39)];
        headView.backgroundColor = [UIColor clearColor];
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, (Screen_Width-60)/2., 39)];
        la.font = SYS_FONT(12);
        la.text = NSStringFormate(@"采购明细(%li)",section - 2);
        [headView addSubview:la];
        UIButton *deletBtn = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width-46, 0, 46, 39)];
        deletBtn.title = @"删除";
        deletBtn.titleLabel.font = SYS_FONT(12);
        deletBtn.titleColor = HexColor(@"#43A0E5");
        deletBtn.tag = section;
        deletBtn.hidden = self.viewModel.goodsMArr.count < 2;
        [deletBtn addTarget:self action:@selector(deletBtnClicked:)];
        [headView addSubview:deletBtn];
        return headView;
    }
    return nil;
}

- (void)deletBtnClicked:(UIButton *)btn {
    GeneralWarningAlertView *alertView = [[GeneralWarningAlertView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width-60, 191)];
    alertView.titleStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
    alertView.contentStr = [[NSMutableAttributedString alloc] initWithString:NSStringFormate(@"是否删除采购明细（%li）",btn.tag-2)];
    [alertView animation];
    [alertView.sureSubject subscribeNext:^(id  _Nullable x) {
        if (self.viewModel.goodsMArr.count>1) {
            [self.titleMArray removeObjectAtIndex:btn.tag];
            [self.requreMArray removeObjectAtIndex:btn.tag];
            [self.placeHolderMArray removeObjectAtIndex:btn.tag];
            [self.accessTypeArray removeObjectAtIndex:btn.tag];
            [self.contentMArray removeObjectAtIndex:btn.tag];
            [self.viewModel.goodsMArr removeObjectAtIndex:btn.tag-3];
            [self reloadData];
        } else {
            SHOW_ERROE(@"您至少需要保留一条采购详情");
        }
        
    }];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = self.titleMArray[indexPath.section][indexPath.row];
    if ([titleStr isEqualToString:@"采购类型"]) {
        if (self.viewModel.approvalTypeList.count) {
            GeneralScrollCateView *alertView = [[GeneralScrollCateView alloc] initWithFrame:CGRectMake(0, Screen_Height-451, Screen_Width, 451)];
            NSArray *arr = self.viewModel.approvalTypeList;
            alertView.dataArr = arr;
            [alertView show];
            @weakify(self);
            [alertView.sureSubject subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                self.viewModel.applyType = x;
                self.contentMArray[indexPath.section] = @[self.viewModel.applyType];
                [self reloadData];
            }];
        }
        
    } else if ([titleStr isEqualToString:@"期望交付日期"]) {
        GeneralTimeSelectorView *timeView = [[GeneralTimeSelectorView alloc] initInfinitDayPickWithFrame:CGRectMake(0, Screen_Height-451, Screen_Width, 451)];
        [timeView show];
        @weakify(self);
        [timeView.sureSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            GeneralTimeModel *model = (GeneralTimeModel *)x;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            formatter.dateFormat = @"yyyy.MM.dd";
            self.contentMArray[indexPath.section] = @[[formatter stringFromDate:model.startDate]];
            formatter.dateFormat = @"yyyy-MM-dd";
            self.viewModel.applyDate = [formatter stringFromDate:model.startDate];
            
            [self reloadData];
        }];
    } else if ([titleStr isEqualToString:@"增加"]) {
        [self.titleMArray insertObject:self.detailTitleArray atIndex:indexPath.section];
        [self.requreMArray insertObject:self.detailRequireArray atIndex:indexPath.section];
        [self.placeHolderMArray insertObject:self.detailPlaceHolderArray atIndex:indexPath.section];
        [self.accessTypeArray insertObject:self.detailAccessTypeArray atIndex:indexPath.section];
        [self.contentMArray insertObject:[NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@""]] atIndex:indexPath.section];
        [self.keyboardTypeMArr insertObject:self.detailKeyboardTypeArr atIndex:indexPath.section];
        [self.viewModel.goodsMArr addObject:[ApprovalGoodsModel new]];
        [self reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self endEditing:YES];
}

#pragma mark - UICollectionViewDelegate&UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSString *titleStr = self.titleMArray[collectionView.indexPath.section][collectionView.indexPath.row];
    if ([titleStr isEqualToString:@"附件"]) {
        return self.viewModel.noteMArr.count == 9 ? 9 : self.viewModel.noteMArr.count+1;
    } else if ([titleStr isEqualToString:@"审批流程"]) {
        return self.viewModel.approvalList.count*2-1;
    } else {
        return self.viewModel.ccList.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = self.titleMArray[collectionView.indexPath.section][collectionView.indexPath.row];
    if ([titleStr isEqualToString:@"附件"]) {
        if (self.viewModel.noteMArr.count == indexPath.item) {
            ApplyPicAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplyPicAddCell" forIndexPath:indexPath];
            return cell;
        } else {
            ApplyPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplyPicCell" forIndexPath:indexPath];
            cell.imgv.image = self.viewModel.noteMArr[indexPath.item];
            cell.deletBtn.tag = indexPath.item;
            [cell.deletBtn addTarget:self action:@selector(deletPicClicked:)];
            return cell;
        }
    } else if ([titleStr isEqualToString:@"审批流程"]) {
        
        if (indexPath.item%2) {
            ApplyApprovArrowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplyApprovArrowCell" forIndexPath:indexPath];
            return cell;
        } else {
            NSDictionary *dict = self.viewModel.approvalList[indexPath.item/2];
            ApplyApproveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplyApproveCell" forIndexPath:indexPath];
            cell.nameLa.text = dict[@"name"];
            return cell;
        }
        
    } else {
        NSDictionary *dict = self.viewModel.ccList[indexPath.item];
        CCListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCListCell" forIndexPath:indexPath];
        cell.nameLa.text = dict[@"name"];
        return cell;
    }
    
}

- (void)deletPicClicked:(UIButton *)btn {
    [self.viewModel.noteMArr removeObjectAtIndex:btn.tag];
    [self reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = self.titleMArray[collectionView.indexPath.section][collectionView.indexPath.row];
    if ([titleStr isEqualToString:@"附件"]) {
         if (self.viewModel.noteMArr.count == indexPath.item) {
            TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:9-self.viewModel.noteMArr.count delegate:self];
            picker.allowTakeVideo = NO;
            picker.allowPickingVideo = NO;
            picker.allowPickingOriginalPhoto = NO;
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:true completion:nil];
         }
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self.viewModel.noteMArr addObjectsFromArray:photos];
    [self reloadData];
}

@end

@implementation PurchaseApplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.requireLa = [UILabel new];
        self.requireLa.textColor = HexColor(@"#FE7079");
        self.requireLa.font = SYS_FONT(14);
        self.requireLa.text = @"*";
        self.requireLa.hidden = YES;
        [self.contentView addSubview:self.requireLa];
        [self.requireLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.top.equalTo(self.contentView).offset(19);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        self.titleLa = [UILabel new];
        self.titleLa.font = SYS_FONT(16);
        self.titleLa.textColor = HEX_333;
        self.titleLa.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.requireLa.mas_right);
            make.width.mas_equalTo(90);
            make.centerY.top.bottom.equalTo(self.contentView);
        }];
        
        self.tf = [UITextField new];
        self.tf.textColor = HEX_333;
        self.tf.font = SYS_FONT(16);
        self.tf.textAlignment = NSTextAlignmentRight;
        self.tf.adjustsFontSizeToFitWidth = YES;
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        self.tf.rightView = rightView;
        self.tf.rightViewMode = UITextFieldViewModeAlways;
        [self.contentView addSubview:self.tf];
        [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa.mas_right);
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
        
        self.line = [[LineView alloc] init];
        self.line.backgroundColor = HexColor(@"#F5F5F5");
        self.line.hidden = YES;
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.requireLa);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

@end

@implementation PurchaseGoodsAddCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        UIButton *addBtn = [UIButton new];
        addBtn.title = @"+    增加明细";
        addBtn.titleColor = HexColor(@"#2E96F7");
        addBtn.titleLabel.font = SYS_FONT(16);
        addBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

@end

@implementation PurchaseApplyNoteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.requireLa = [UILabel new];
        self.requireLa.textColor = HexColor(@"#FE7079");
        self.requireLa.font = SYS_FONT(14);
        self.requireLa.text = @"*";
        self.requireLa.hidden = YES;
        [self.contentView addSubview:self.requireLa];
        [self.requireLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.top.equalTo(self.contentView).offset(19);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        self.titleLa = [UILabel new];
        self.titleLa.font = SYS_FONT(16);
        self.titleLa.textColor = HEX_333;
        [self.contentView addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.requireLa.mas_right);
            make.width.mas_equalTo(90);
            make.centerY.top.bottom.equalTo(self.requireLa);
        }];
        
        self.tv = [UITextView new];
        self.tv.textColor = HEX_333;
        self.tv.font = SYS_FONT(16);
        [self.contentView addSubview:self.tv];
        [self.tv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa.mas_left).offset(-3);
            make.top.equalTo(self.titleLa.mas_bottom).offset(12);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView).offset(-12);
        }];
    }
    return self;
}

@end


@implementation PurchaseApplyPicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.requireLa = [UILabel new];
        self.requireLa.textColor = HexColor(@"#FE7079");
        self.requireLa.font = SYS_FONT(14);
        self.requireLa.text = @"*";
        self.requireLa.hidden = YES;
        [self.contentView addSubview:self.requireLa];
        [self.requireLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.top.equalTo(self.contentView).offset(19);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        self.titleLa = [UILabel new];
        self.titleLa.font = SYS_FONT(16);
        self.titleLa.textColor = HEX_333;
        [self.contentView addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.requireLa.mas_right);
            make.width.mas_equalTo(90);
            make.centerY.top.bottom.equalTo(self.requireLa);
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(48, 48);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) collectionViewLayout:layout];
        self.collectionView.backgroundColor = HEX_FFF;
        [self.collectionView registerClass:[ApplyPicCell class] forCellWithReuseIdentifier:@"ApplyPicCell"];
        [self.collectionView registerClass:[ApplyPicAddCell class] forCellWithReuseIdentifier:@"ApplyPicAddCell"];
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-30);
            make.left.right.equalTo(self.titleLa).offset(-5);
            make.top.equalTo(self.titleLa.mas_bottom);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

@end


@implementation ApplyPicCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imgv = [UIImageView new];
        [self.contentView addSubview:self.imgv];
        [self.imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
        
        self.deletBtn = [UIButton new];
        self.deletBtn.image = @"roundDelet";
        [self.contentView addSubview:self.deletBtn];
        [self.deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imgv.mas_right).offset(-4);
            make.centerY.equalTo(self.imgv.mas_top).offset(4);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
    }
    return self;
}

@end

@implementation ApplyPicAddCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imgv = [UIImageView new];
        imgv.image = [UIImage imageNamed:@"rectangleAdd"];
        [self.contentView addSubview:imgv];
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
    }
    return self;
}

@end

@implementation PurchaseApplyApproveCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.requireLa = [UILabel new];
        self.requireLa.textColor = HexColor(@"#FE7079");
        self.requireLa.font = SYS_FONT(14);
        self.requireLa.text = @"*";
        self.requireLa.hidden = YES;
        [self.contentView addSubview:self.requireLa];
        [self.requireLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.top.equalTo(self.contentView).offset(19);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        self.titleLa = [UILabel new];
        self.titleLa.font = SYS_FONT(16);
        self.titleLa.textColor = HEX_333;
        [self.contentView addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.requireLa.mas_right);
            make.width.mas_equalTo(90);
            make.centerY.top.bottom.equalTo(self.requireLa);
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(50, 67);
        layout.minimumLineSpacing = 0.01;
        layout.minimumInteritemSpacing = 0.01;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) collectionViewLayout:layout];
        self.collectionView.backgroundColor = HEX_FFF;
        [self.collectionView registerClass:[ApplyApproveCell class] forCellWithReuseIdentifier:@"ApplyApproveCell"];
        [self.collectionView registerClass:[ApplyApprovArrowCell class] forCellWithReuseIdentifier:@"ApplyApprovArrowCell"];
        [self.collectionView registerClass:[ApplyApproveAddCell class] forCellWithReuseIdentifier:@"ApplyApproveAddCell"];
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-30);
            make.left.right.equalTo(self.titleLa).offset(-15);
            make.top.equalTo(self.titleLa.mas_bottom);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}


@end




@implementation ApplyApproveCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imgv = [UIImageView new];
        self.imgv.layer.cornerRadius = 19;
        self.imgv.layer.masksToBounds = YES;
        self.imgv.image = [UIImage imageNamed:@"approvalPortrait"];
        [self.contentView addSubview:self.imgv];
        [self.imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 24, 5));
        }];
        
//        self.deletBtn = [UIButton new];
//        self.deletBtn.image = @"roundDelet";
//        [self.contentView addSubview:self.deletBtn];
//        [self.deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.imgv.mas_right).offset(-4);
//            make.centerY.equalTo(self.imgv.mas_top).offset(4);
//            make.size.mas_equalTo(CGSizeMake(14, 14));
//        }];
        
        self.nameLa = [UILabel new];
        self.nameLa.textColor = HEX_333;
        self.nameLa.font = SYS_FONT(12);
        self.nameLa.textAlignment = NSTextAlignmentCenter;
        self.nameLa.numberOfLines = 2;
        self.nameLa.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.nameLa];
        [self.nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.imgv);
            make.top.equalTo(self.imgv.mas_bottom);
            make.height.mas_equalTo(24);
        }];
        
        
    }
    return self;
}

@end

@implementation ApplyApprovArrowCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.arrowImgv = [UIImageView new];
        self.arrowImgv.image = [UIImage imageNamed:@"approveAdd"];
        [self.contentView addSubview:self.arrowImgv];
        [self.arrowImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(34, 25));
        }];
    }
    return self;
}

@end

@implementation ApplyApproveAddCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
       self.imgv = [UIImageView new];
//        self.imgv.image = [UIImage imageNamed:@"clear_circle_add"];
        [self.contentView addSubview:self.imgv];
        [self.imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
    }
    return  self;
}

@end


@implementation ApplyCCListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        self.requireLa = [UILabel new];
        self.requireLa.textColor = HexColor(@"#FE7079");
        self.requireLa.font = SYS_FONT(14);
        self.requireLa.text = @"*";
        self.requireLa.hidden = YES;
        [self.contentView addSubview:self.requireLa];
        [self.requireLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.top.equalTo(self.contentView).offset(19);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        self.titleLa = [UILabel new];
        self.titleLa.font = SYS_FONT(16);
        self.titleLa.textColor = HEX_333;
        [self.contentView addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.requireLa.mas_right);
            make.width.mas_equalTo(90);
            make.centerY.top.bottom.equalTo(self.requireLa);
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(50, 67);
        layout.minimumLineSpacing = 0.01;
        layout.minimumInteritemSpacing = 0.01;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) collectionViewLayout:layout];
        self.collectionView.backgroundColor = HEX_FFF;
        [self.collectionView registerClass:[CCListCell class] forCellWithReuseIdentifier:@"CCListCell"];
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-30);
            make.left.right.equalTo(self.titleLa).offset(-15);
            make.top.equalTo(self.titleLa.mas_bottom);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

@end


@implementation CCListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imgv = [UIImageView new];
        self.imgv.layer.cornerRadius = 19;
        self.imgv.layer.masksToBounds = YES;
        self.imgv.image = [UIImage imageNamed:@"approvalPortrait"];
        [self.contentView addSubview:self.imgv];
        [self.imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 24, 5));
        }];
        
//        self.deletBtn = [UIButton new];
//        self.deletBtn.image = @"roundDelet";
//        [self.contentView addSubview:self.deletBtn];
//        [self.deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.imgv.mas_right).offset(-4);
//            make.centerY.equalTo(self.imgv.mas_top).offset(4);
//            make.size.mas_equalTo(CGSizeMake(14, 14));
//        }];
        
        self.nameLa = [UILabel new];
        self.nameLa.textColor = HEX_333;
        self.nameLa.font = SYS_FONT(12);
        self.nameLa.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLa];
        [self.nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.imgv.mas_bottom);
            make.height.mas_equalTo(24);
        }];
        
    }
    return self;
}

@end
