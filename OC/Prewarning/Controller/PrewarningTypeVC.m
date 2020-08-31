//
//  PrewarningTypeVC.m
//  JingTeYuHui
//
//  Created by LJ on 2019/5/31.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "PrewarningTypeVC.h"

@interface PrewarningTypeVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation PrewarningTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArr = @[@{@"name":@"营收预警",@"type":@""},@{@"name":@"充值预警",@"type":@""},@{@"name":@"消费预警",@"type":@""},@{@"name":@"营收预警",@"type":@""},@{@"name":@"营收预警",@"type":@""},@{@"name":@"营收预警",@"type":@""}];
}


#pragma mark - UICollectionViewDelegate&UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
