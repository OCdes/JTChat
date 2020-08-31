//
//  PrewarningDataManager.m
//  Swift-jtyh
//
//  Created by LJ on 2020/6/10.
//  Copyright © 2020 WanCai. All rights reserved.
//

#import "PrewarningDataManager.h"
static PrewarningDataManager *_dataManager = nil;
@implementation PrewarningDataManager

+ (instancetype)manager {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (_dataManager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _dataManager = [super allocWithZone:zone];
        });
    }
    return _dataManager;
}

- (NSArray *)latestPrewarningList {
    NSArray *arr = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"latestPrewarningList"];
    return arr;
}

- (NSArray *)prewarningList {
    NSArray *arr = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"prewarningList"];
    return arr;
}

- (void)setLatestPrewarningList:(NSArray *)latestPrewarningList {
    if (latestPrewarningList != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:latestPrewarningList forKey:@"latestPrewarningList"];
    }
}

- (void)setPrewarningList:(NSArray *)prewarningList {
    if (prewarningList != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:prewarningList forKey:@"prewarningList"];
    }
}

@end
