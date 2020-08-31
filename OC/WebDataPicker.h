//
//  WebDataPicker.h
//  JingTeYuHui
//
//  Created by LJ on 2019/1/28.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebDataPicker : UIView

@property (nonatomic, strong) NSString *timeStr, *maxTimeStr, *minTimeStr;

@property (nonatomic, strong) void(^timeChangeBlock)(NSString *timeStr);

@property (nonatomic, strong) void(^dateChangeBlock)(NSDate *date);


@property (nonatomic, assign) UIDatePickerMode pickerModel;

@property (nonatomic, assign) BOOL isFull;

@property (nonatomic, assign) BOOL hasShow;

- (void)animation;

@end

NS_ASSUME_NONNULL_END
