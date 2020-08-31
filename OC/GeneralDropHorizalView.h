//
//  GeneralDropHorizalView.h
//  JingTeYuHui
//
//  Created by LJ on 2019/3/20.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSubject;
NS_ASSUME_NONNULL_BEGIN

@interface GeneralDropHorizalView : UIView

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) NSString *seleKey;

@property (nonatomic, copy) void(^didSelectCallback)(NSInteger index, NSString *content);

@property (nonatomic, strong) RACSubject *hideSubject;

- (void)animationInView:(UIView *)v;

- (void)hide;

- (void)resetFrame:(CGRect )frame;

@end

@interface GeneralDropCell : UITableViewCell

@property (nonatomic, strong) NSString *contentStr;

@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
