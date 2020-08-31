//
//  ExpenseApplyTableView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/24.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "ExpenseApplyTableView.h"
#import "PurchaseApplyTableView.h"
#import "GeneralSheetAlertView.h"

#import "GeneralTimeSelectorView.h"
#import "GeneralTimeManager.h"
#import "GeneralWarningAlertView.h"
#import "GeneralScrollCateView.h"
#import "PCHeader.h"
#import <TZImagePickerController/TZImagePickerController.h>
@interface ExpenseApplyTableView () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *titleMArray, *requreMArray, *accessTypeArray, *placeHolderMArray, *contentMArray, *goodsMArr, *keyboardTypeMArr;

@property (nonatomic, strong) NSArray *detailTitleArray, *detailRequireArray, *detailAccessTypeArray, *detailPlaceHolderArray, *detailContentArray, *detailKeyboardTypeArr;
@end

@implementation ExpenseApplyTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = 0;
        self.goodsMArr = [NSMutableArray array];
        self.detailTitleArray = @[@"费用类型",@"发生时间",@"费用金额",@"费用明细"];
        self.detailRequireArray = @[@(1),@(1),@(1),@(0)];
        self.detailAccessTypeArray = @[@(UITableViewCellAccessoryDisclosureIndicator),@(UITableViewCellAccessoryDisclosureIndicator),@(UITableViewCellAccessoryNone),@(UITableViewCellAccessoryNone)];
        self.detailPlaceHolderArray = @[@"请选择",@"请选择",@"请输入",@"请输入"];
        self.detailKeyboardTypeArr = @[@(UIKeyboardTypeDefault),@(UIKeyboardTypeDefault),@(UIKeyboardTypePhonePad),@(UIKeyboardTypeDefault)];
        self.titleMArray = [NSMutableArray arrayWithArray:@[@[@"报销类型"],@[@"报销事由"],self.detailTitleArray,@[@"增加"],@[@"审批流程"],@[@"抄送人"]]];
        self.keyboardTypeMArr = [NSMutableArray arrayWithArray:@[@[@(UIKeyboardTypeDefault)],@[@(UIKeyboardTypeDefault)],self.detailKeyboardTypeArr,@[@(UIKeyboardTypeDefault)],@[@(UIKeyboardTypeDefault)],@[@(UIKeyboardTypeDefault)]]];
        self.requreMArray = [NSMutableArray arrayWithArray:@[@[@(1)],@[@(1)],self.detailRequireArray,@[@(0)],@[@(1)],@[@(0)]]];
        self.accessTypeArray = [NSMutableArray arrayWithArray:@[@[@(UITableViewCellAccessoryDisclosureIndicator)],@[@(UITableViewCellAccessoryNone)],self.detailAccessTypeArray,@[@(0)],@[@(UITableViewCellAccessoryNone)],@[@(UITableViewCellAccessoryNone)]]];
        self.placeHolderMArray = [NSMutableArray arrayWithArray:@[@[@"请选择"],@[@"请输入"],self. detailPlaceHolderArray,@[@""],@[@""],@[@""]]];
        self.contentMArray = [NSMutableArray arrayWithArray:@[@[@""],@[@""],[NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@""]],@[@""],@[@""],@[@""]]];
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 160)];
        footerView.backgroundColor = [UIColor clearColor];
        UIButton *subBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 44, Screen_Width-30, 44)];
        subBtn.title = @"提交";
        subBtn.titleColor = HEX_FFF;
        subBtn.backgroundColor = HexColor(@"#2E96F7");
        subBtn.titleLabel.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",subBtn.titleLabel.font.fontName) size:19];
        subBtn.layer.cornerRadius = 5;
        subBtn.layer.masksToBounds = YES;
        [subBtn addTarget:self action:@selector(subBtnClicked:)];
        [footerView addSubview:subBtn];
        self.tableFooterView = footerView;
    }
    return self;
}

- (void)subBtnClicked:(UIButton *)btn {
    [self.viewModel.submitExpenseCommand execute:nil];
    
}

- (void)setViewModel:(PurchaseApplyViewModel *)viewModel {
    _viewModel = viewModel;
    self.contentMArray = [NSMutableArray arrayWithArray:@[@[viewModel.applyType?viewModel.applyType:@""],@[viewModel.applyReason?viewModel.applyReason:@""],[NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@""]],@[@""],@[@""],@[@""],@[@""]]];
    [self reloadData];
}

#pragma mark - TextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSIndexPath *indexPath = textField.indexPath;
    NSString *str = textField.text;
    NSString *titleStr = self.titleMArray[indexPath.section][indexPath.row];
    if ([titleStr isEqualToString:@"报销事由"]) {
        self.viewModel.applyReason = str;
        self.contentMArray[indexPath.section] = @[str];
    } else {
        self.contentMArray[indexPath.section][indexPath.row] = str;
        ApprovalGoodsModel *model = self.viewModel.goodsMArr[indexPath.section-2];
        model.expenseFee = str;
    }
}

#pragma mark - TextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    ApprovalGoodsModel *model = self.viewModel.goodsMArr[textView.indexPath.section-2];
    model.note = textView.text;
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
    UIKeyboardType kbType = [self.keyboardTypeMArr[indexPath.section][indexPath.row] integerValue];
    if ([titleStr isEqualToString:@"费用明细"]) {
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
        cell.tv.keyboardType = kbType;
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
        cell.requireLa.hidden = [titleStr isEqualToString:@"报销事由"] ? YES : !require;
        cell.titleLa.hidden = [titleStr isEqualToString:@"报销事由"] ? YES : NO;
        cell.tf.hidden = [titleStr isEqualToString:@"报销事由"] ? YES : NO;
        cell.line.hidden = [self.titleMArray[indexPath.section] count] == 1;
        cell.tf.placeholder = placeStr;
        cell.tf.indexPath = indexPath;
        cell.tf.delegate = self;
        cell.tf.text = contentStr;
        cell.tf.userInteractionEnabled = !accessType;
        cell.accessoryType = accessType;
        cell.tf.keyboardType = kbType;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = self.titleMArray[indexPath.section][indexPath.row];
    if ([titleStr isEqualToString:@"费用明细"]) {
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
   } else if ([titleStr isEqualToString:@"报销事由"]) {
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
    if ([arr[0] isEqualToString:@"发生时间"] || section == 1) {
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
        la.text = NSStringFormate(@"报销明细(%li)",section - 1);
        [headView addSubview:la];
        UIButton *deletBtn = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width-46, 0, 46, 39)];
        deletBtn.title = @"删除";
        deletBtn.hidden = self.viewModel.goodsMArr.count < 2;
        deletBtn.titleLabel.font = SYS_FONT(12);
        deletBtn.titleColor = HexColor(@"#43A0E5");
        deletBtn.tag = section;
        [deletBtn addTarget:self action:@selector(deletBtnClicked:)];
        [headView addSubview:deletBtn];
        return headView;
    }
    return nil;
}

- (void)deletBtnClicked:(UIButton *)btn {
    GeneralWarningAlertView *alertView = [[GeneralWarningAlertView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width-60, 191)];
    alertView.titleStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
    alertView.contentStr = [[NSMutableAttributedString alloc] initWithString:NSStringFormate(@"是否删除报销明细（%li）",btn.tag-2)];
    [alertView animation];
    [alertView.sureSubject subscribeNext:^(id  _Nullable x) {
        [self.titleMArray removeObjectAtIndex:btn.tag];
        [self.requreMArray removeObjectAtIndex:btn.tag];
        [self.placeHolderMArray removeObjectAtIndex:btn.tag];
        [self.accessTypeArray removeObjectAtIndex:btn.tag];
        [self.contentMArray removeObjectAtIndex:btn.tag];
        [self.viewModel.goodsMArr removeObjectAtIndex:btn.tag-2];
        [self reloadData];
    }];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = self.titleMArray[indexPath.section][indexPath.row];
    if ([titleStr isEqualToString:@"报销类型"]) {
        GeneralScrollCateView *alertView = [[GeneralScrollCateView alloc] initWithFrame:CGRectMake(0, Screen_Height-451, Screen_Width, 451)];
        NSArray *arr = self.viewModel.approvalTypeList.count?self.viewModel.approvalTypeList: @[@"差旅费",@"交通费",@"招待费",@"其他"];
        alertView.dataArr = arr;
        [alertView show];
        @weakify(self);
        [alertView.sureSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.viewModel.applyType = x;
            self.contentMArray[indexPath.section] = @[self.viewModel.applyType];
            [self reloadData];
        }];
    } else if ([titleStr isEqualToString:@"费用类型"]) {
        GeneralScrollCateView *alertView = [[GeneralScrollCateView alloc] initWithFrame:CGRectMake(0, Screen_Height-451, Screen_Width, 451)];
        NSArray *arr = @[@"飞机票",@"汽车票",@"火车票",@"的士费",@"住宿费",@"餐饮费",@"礼品费",@"活动费",@"通讯费",@"补助",@"其他"];
        alertView.dataArr = arr;
        [alertView show];
        @weakify(self);
        [alertView.sureSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            ApprovalGoodsModel *model = self.viewModel.goodsMArr[indexPath.section-2];
            model.expenseFeeType = x;
            self.contentMArray[indexPath.section][indexPath.row] = x;
            [self reloadData];
        }];
        
    } else if ([titleStr isEqualToString:@"发生时间"]) {
        GeneralTimeSelectorView *timeView = [[GeneralTimeSelectorView alloc] initDayPickWithFrame:CGRectMake(0, Screen_Height-451, Screen_Width, 451)];
        [timeView show];
        @weakify(self);
        [timeView.sureSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            GeneralTimeModel *model = (GeneralTimeModel *)x;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            formatter.dateFormat = @"yyyy.MM.dd";
            ApprovalGoodsModel *mmodel = self.viewModel.goodsMArr[indexPath.section-2];
            mmodel.RequiredDate = [formatter stringFromDate:model.startDate];
            self.contentMArray[indexPath.section][indexPath.row] = [formatter stringFromDate:model.startDate];
            [self reloadData];
        }];
    } else if ([titleStr isEqualToString:@"增加"]) {
        [self.titleMArray insertObject:self.detailTitleArray atIndex:indexPath.section];
        [self.requreMArray insertObject:self.detailRequireArray atIndex:indexPath.section];
        [self.placeHolderMArray insertObject:self.detailPlaceHolderArray atIndex:indexPath.section];
        [self.accessTypeArray insertObject:self.detailAccessTypeArray atIndex:indexPath.section];
        [self.contentMArray insertObject:[NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@""]] atIndex:indexPath.section];
        [self.viewModel.goodsMArr addObject:[ApprovalGoodsModel new]];
        [self.keyboardTypeMArr insertObject:self.detailKeyboardTypeArr atIndex:indexPath.section];
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
            cell.nameLa.text = dict[@"姓名"];
            return cell;
        }
    } else {
        NSDictionary *dict = self.viewModel.ccList[indexPath.item];
        CCListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCListCell" forIndexPath:indexPath];
        cell.nameLa.text = dict[@"姓名"];
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
