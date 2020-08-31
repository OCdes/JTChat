//
//  PrewarningTableView.h
//  JingTeYuHui
//
//  Created by LJ on 2019/5/31.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSubject;
NS_ASSUME_NONNULL_BEGIN

@interface PrewarningTableView : UITableView

@property (nonatomic, strong) RACSubject *readedSubject;

@property (nonatomic, assign) BOOL hasReaded;

@property (nonatomic, strong) NSArray *dataArr;

@end

@interface PrewarningCell : UITableViewCell

@property (nonatomic, strong) UIButton *readedBtn;

@property (nonatomic, strong) NSDictionary *dict;

@end

NS_ASSUME_NONNULL_END
