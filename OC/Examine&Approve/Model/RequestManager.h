//
//  RequestManager.h
//  Swift-jtyh
//
//  Created by LJ on 2020/6/2.
//  Copyright © 2020 WanCai. All rights reserved.
//

#import "OCBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestManager : OCBaseViewModel

+ (void)postWithApi:(NSString *)api params:(NSDictionary *)params success:(nullable void (^)(NSNumber *code, NSString *msg, NSDictionary *data))success failure:(nullable void (^)(NSNumber *code, NSString *msg))failure;


@end

NS_ASSUME_NONNULL_END
