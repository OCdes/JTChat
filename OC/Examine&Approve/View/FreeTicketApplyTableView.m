//
//  FreeTicketApplyTableView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/23.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "FreeTicketApplyTableView.h"
#import "PurchaseApplyTableView.h"
#import "GeneralSheetAlertView.h"
#import "GeneralTimeSelectorView.h"
#import "GeneralTimeManager.h"
#import "GeneralScrollCateView.h"
#import "PCHeader.h"
#import <TZImagePickerController/TZImagePickerController.h>
@interface FreeTicketApplyTableView () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *titleMArray, *requreMArray, *accessTypeArray, *placeHolderMArray, *contentMArray, *keyboardTypeMArr;

@end

@implementation FreeTicketApplyTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = 0;
        self.titleMArray = [NSMutableArray arrayWithArray:@[@[@"免票类型"],@[@"申请事由"],@[@"限免次数"],@[@"发生日期"],@[@"备注"],@[@"审批流程"],@[@"抄送人"]]];
        self.keyboardTypeMArr = [NSMutableArray arrayWithArray:@[@[@(UIKeyboardTypeDefault)],@[@(UIKeyboardTypeDefault)],@[@(UIKeyboardTypePhonePad)],@[@(UIKeyboardTypeDefault)],@[@(UIKeyboardTypeDefault)],@[@(UIKeyboardTypeDefault)],@[@(UIKeyboardTypeDefault)]]];
        self.requreMArray = [NSMutableArray arrayWithArray:@[@[@(1)],@[@(1)],@[@(1)],@[@(1)],@[@(0)],@[@(0)],@[@(0)]]];
        self.accessTypeArray = [NSMutableArray arrayWithArray:@[@[@(UITableViewCellAccessoryDisclosureIndicator)],@[@(UITableViewCellAccessoryNone)],@[@(UITableViewCellAccessoryNone)],@[@(UITableViewCellAccessoryDisclosureIndicator)],@[@(UITableViewCellAccessoryNone)],@[@(UITableViewCellAccessoryNone)],@[@(UITableViewCellAccessoryNone)]]];
        self.placeHolderMArray = [NSMutableArray arrayWithArray:@[@[@"请选择"],@[@"请输入"],@[@"请输入"],@[@"请选择"],@[@"请输入"],@[@""],@[@""]]];
        self.contentMArray = [NSMutableArray arrayWithArray:@[@[@""],@[@""],@[@""],@[@""],@[@""],@[@""],@[@""]]];
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
    [self.viewModel.submitFreeTicketCommand execute:nil];

}

- (void)setViewModel:(PurchaseApplyViewModel *)viewModel {
    _viewModel = viewModel;
    self.contentMArray = [NSMutableArray arrayWithArray:@[@[viewModel.applyReason?viewModel.applyReason:@""],@[viewModel.applyType?viewModel.applyType:@""],@[viewModel.applyDate?viewModel.applyDate:@""],@[@""],@[@""],@[@""],@[@""]]];
    [self reloadData];
}

#pragma mark - TextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSIndexPath *indexPath = textField.indexPath;
    NSString *str = textField.text;
    NSString *titleStr = self.titleMArray[indexPath.section][indexPath.row];
    if ([titleStr isEqualToString:@"限免次数"]) {
        self.viewModel.freeNum = str;
    }
    self.contentMArray[indexPath.section] = @[str];
    
    
}

#pragma mark - TextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString *str = textView.text;
    NSString *titleStr = self.titleMArray[textView.indexPath.section][textView.indexPath.row];
    if ([titleStr isEqualToString:@"申请事由"]) {
        self.viewModel.applyReason = str;
        self.contentMArray[textView.indexPath.section] = @[str];
    } else {
        self.viewModel.applyNote = str;
        self.contentMArray[textView.indexPath.section] = @[str];
    }
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
    if ([titleStr isEqualToString:@"备注"] || [titleStr isEqualToString:@"申请事由"]) {
        static NSString *identifier = @"PurchaseApplyNoteCell";
        PurchaseApplyNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PurchaseApplyNoteCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        cell.titleLa.text = titleStr;
        cell.requireLa.hidden = [titleStr isEqualToString:@"申请事由"] ? YES : !require;
        cell.titleLa.hidden = [titleStr isEqualToString:@"申请事由"] ? YES : NO;
        cell.tv.hidden = [titleStr isEqualToString:@"申请事由"] ? YES : NO;
        cell.tv.indexPath = indexPath;
        cell.tv.delegate = self;
        cell.tv.text = contentStr;
        cell.tv.keyboardType = kbType;
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
    } else {
        static NSString *identifier = @"PurchaseApplyCell";
        PurchaseApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PurchaseApplyCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        }
        cell.titleLa.text = titleStr;
        cell.requireLa.hidden = !require;
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
    if ([titleStr isEqualToString:@"备注"]) {
        return 120;
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
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
   return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = self.titleMArray[indexPath.section][indexPath.row];
    if ([titleStr isEqualToString:@"免票类型"]) {
        GeneralScrollCateView *alertView = [[GeneralScrollCateView alloc] initWithFrame:CGRectMake(0, Screen_Height-451, Screen_Width, 451)];
        NSArray *arr = @[@"当天全免",@"当天限免"];
        alertView.dataArr = arr;
        [alertView show];
        @weakify(self);
        [alertView.sureSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.viewModel.applyType = x;
            self.contentMArray[indexPath.section] = @[self.viewModel.applyType];
            if ([x isEqualToString:@"当天全免"]) {
                if (self.titleMArray.count == 7) {
                    self.viewModel.freeNum = @"";
                    [self.titleMArray removeObjectAtIndex:2];
                    [self.contentMArray removeObjectAtIndex:2];
                    [self.requreMArray removeObjectAtIndex:2];
                    [self.accessTypeArray removeObjectAtIndex:2];
                    [self.placeHolderMArray removeObjectAtIndex:2];
                    [self.keyboardTypeMArr removeObjectAtIndex:2];
                }
            } else {
                if (self.titleMArray.count == 6) {
                    [self.titleMArray insertObject:@[@"限免次数"] atIndex: 2];
                    [self.contentMArray insertObject:@[@""] atIndex: 2];
                    [self.requreMArray insertObject:@[@(1)] atIndex: 2];
                    [self.accessTypeArray insertObject:@[@(UITableViewCellAccessoryNone)] atIndex: 2];
                    [self.placeHolderMArray insertObject:@[@"请输入"] atIndex: 2];
                    [self.keyboardTypeMArr insertObject:@[@(UIKeyboardTypePhonePad)] atIndex:2];
                }
            }
            
            [self reloadData];
        }];
    } else if ([titleStr isEqualToString:@"发生日期"]) {
        GeneralTimeSelectorView *timeView = [[GeneralTimeSelectorView alloc] initInfinitDayPickWithFrame:CGRectMake(0, Screen_Height-451, Screen_Width, 451)];
        [timeView show];
        @weakify(self);
        [timeView.sureSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            GeneralTimeModel *model = (GeneralTimeModel *)x;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            formatter.dateFormat = @"yyyy.MM.dd";
            self.viewModel.applyDate = [formatter stringFromDate:model.startDate];
            self.contentMArray[indexPath.section] = @[self.viewModel.applyDate];
            [self reloadData];
        }];
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
