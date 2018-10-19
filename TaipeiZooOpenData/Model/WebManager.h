//
//  WebManager.h
//  TaipeiZooOpenData
//
//  Created by NT30338 on 2018/10/19.
//  Copyright © 2018年 NT30338. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebManager : NSObject

+ (void)queryZooOpenDataWithLimit:(NSInteger)limit
                           offset:(NSInteger)offset
                   successHandler:(void (^) (NSDictionary *response))successHandler
                      failHandler:(void (^) (NSDictionary *response))failHandler;

@end

NS_ASSUME_NONNULL_END
