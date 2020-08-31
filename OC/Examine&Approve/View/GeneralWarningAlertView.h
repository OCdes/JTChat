//
//  GeneralWarningAlertView.h
//  JingTeYuHui
//
//  Created by LJ on 2019/3/21.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSubject;
NS_ASSUME_NONNULL_BEGIN

@interface GeneralWarningAlertView : UIView

@property (nonatomic, strong) NSMutableAttributedString *titleStr, *contentStr;

@property (nonatomic, strong) NSString  *cancleStr, *sureStr;

@property (nonatomic, strong) RACSubject *sureSubject, *cancleSubject;

- (void)animation;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
