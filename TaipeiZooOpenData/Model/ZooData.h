//
//  ZooData.h
//  TaipeiZooOpenData
//
//  Created by NT30338 on 2018/10/19.
//  Copyright © 2018年 NT30338. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZooData : NSObject

@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) NSString *location;
@property (nonatomic, strong, nonnull) NSString *behavior;
@property (nonatomic, strong, nonnull) NSString *imgUrl;

- (instancetype)initWithDictionary:(NSDictionary *)dataDictionary;
@end

NS_ASSUME_NONNULL_END
