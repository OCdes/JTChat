//
//  RoomNoteEditTableView.h
//  JingTeYuHui
//
//  Created by LJ on 2019/3/11.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebDataPicker.h"
#import "TotalGuestNumView.h"
@class RACSubject;
@class RoomNoteViewModel;
NS_ASSUME_NONNULL_BEGIN

@interface RoomNoteEditTableView : UITableView

@property (nonatomic, strong) RoomNoteViewModel *viewModel;

@property (nonatomic, strong) RACSubject *giftSubject, *openSubject, *getSubject, *saveSubject, *waitressSubject, *cashierSubject, *fuwuyuanSubject, *sijiuSubject, *pimpSubject, *xiaojiuSubject;

@property (nonatomic, strong) WebDataPicker *picker, *endPicker, *datePicker;

@property (nonatomic, strong) TotalGuestNumView *guestNumView;

@end

@interface RoomNoteEditCell : UITableViewCell

@property (nonatomic, strong) UITextField *textF;

@property (nonatomic, strong) UILabel *titleLa;

@property (nonatomic, strong) UIButton *skipBtn;

@end

@interface RoomSubCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLa, *numLa;

@property (nonatomic, strong) UIButton *subBtn;

@property (nonatomic, strong) UITextField *textF;

@end

@interface RoomAddCell : UITableViewCell

@property (nonatomic, strong) UILabel *numLa;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UITextField *textF;

@end

@interface RoomSituationCell : UITableViewCell

@property (nonatomic, strong) UITextView *tv;

@end

NS_ASSUME_NONNULL_END
