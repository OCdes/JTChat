//
//  GeneralSheetAlertView.h
//  JingTeYuHui
//
//  Created by LJ on 2019/3/27.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZiModel.h"
@class RACSubject;
NS_ASSUME_NONNULL_BEGIN

@interface GeneralSheetAlertView : UIView

@property (nonatomic, strong) RACSubject *tapItemSubject;

- (instancetype)init;

@property (nonatomic, strong) NSArray *titleArr;

- (void)animation;

- (void)hide;

@end


@interface SheetCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) NSString *contentStr;

@end

NS_ASSUME_NONNULL_END
