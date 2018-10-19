//
//  ZooDataModel.h
//  TaipeiZooOpenData
//
//  Created by NT30338 on 2018/10/19.
//  Copyright © 2018年 NT30338. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZooData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZooDataModel : NSObject

+ (ZooDataModel *)sharedInstance;
- (NSMutableArray<ZooData *> *)getZooDatas;
- (void)queryZooOpenDataWithSuccessHandler:(void (^) (NSDictionary *response))successHandler
                               failHandler:(void (^) (NSDictionary *response))failHandler;

@end

NS_ASSUME_NONNULL_END
