//
//  PurchaseApplyTableView.h
//  JingTeYuHui
//
//  Created by LJ on 2019/9/11.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseApplyViewModel.h"
@class LineView;
NS_ASSUME_NONNULL_BEGIN

@interface PurchaseApplyTableView : UITableView

@property (nonatomic, strong) PurchaseApplyViewModel *viewModel;

@end

@interface PurchaseApplyCell : UITableViewCell

@property (nonatomic, strong) UITextField *tf;

@property (nonatomic, strong) UILabel *titleLa, *requireLa;

@property (nonatomic, strong) LineView *line;

@end

@interface PurchaseGoodsAddCell : UITableViewCell

@end

@interface PurchaseApplyNoteCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLa, *requireLa;

@property (nonatomic, strong) UITextView *tv;

@end

@interface PurchaseApplyPicCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLa, *requireLa;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@interface ApplyPicCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgv;

@property (nonatomic, strong) UIButton *deletBtn;

@end

@interface ApplyPicAddCell : UICollectionViewCell

@end

@interface PurchaseApplyApproveCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLa, *requireLa;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@interface ApplyApprovArrowCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *arrowImgv;

@end

@interface ApplyApproveCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgv;

@property (nonatomic, strong) UILabel *nameLa;

@property (nonatomic, strong) UIButton *deletBtn;



@end

@interface ApplyApproveAddCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgv;

@end

@interface ApplyCCListCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLa, *requireLa;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@interface CCListCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgv;

@property (nonatomic, strong) UILabel *nameLa;

@property (nonatomic, strong) UIButton *deletBtn;

@end

NS_ASSUME_NONNULL_END
