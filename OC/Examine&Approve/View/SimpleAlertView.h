//
//  SimpleAlertView.h
//  JingTeYuHui
//
//  Created by LJ on 2019/10/11.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSubject;
NS_ASSUME_NONNULL_BEGIN

@interface SimpleAlertView : UIView

@property (nonatomic, strong) RACSubject *sureSubject;

@property (nonatomic, strong) NSString *sureTitle, *contentStr;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
