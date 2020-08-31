//
//  PrewarningDataManager.h
//  Swift-jtyh
//
//  Created by LJ on 2020/6/10.
//  Copyright © 2020 WanCai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrewarningDataManager : NSObject

+ (instancetype)manager;

@property (nonatomic, strong) NSArray *latestPrewarningList, *prewarningList;

@end

NS_ASSUME_NONNULL_END
