//
//  ApplyDetailTableView.h
//  JingTeYuHui
//
//  Created by LJ on 2019/9/18.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyDetailViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ApplyDetailTableView : UITableView

@property (nonatomic, strong) ApplyDetailViewModel *viewModel;

@end

@interface ApplyDetailTextCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLa, *contentLa;

@end

@interface ApplyDetailPicCell : UITableViewCell

@property (nonatomic, strong) UILabel *stateLa;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@interface ApplyDetailApprovalCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLa, *stateLa, *topLine, *bottomLine;

@property (nonatomic, strong) UIImageView *imgv;

@property (nonatomic, strong) NSDictionary *dict;

@end

NS_ASSUME_NONNULL_END
