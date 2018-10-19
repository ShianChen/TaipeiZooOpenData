//
//  ZooData.m
//  TaipeiZooOpenData
//
//  Created by NT30338 on 2018/10/19.
//  Copyright © 2018年 NT30338. All rights reserved.
//

#import "ZooData.h"

@implementation ZooData

- (instancetype)initWithDictionary:(NSDictionary *)dataDictionary {
    if ((self = [super init]) == nil) {
        return nil;
    }
    self.name = nonEmptyString(dataDictionary[@"A_Name_Ch"]);
    self.location = nonEmptyString(dataDictionary[@"A_Location"]);
    
    NSString *behaviorString = nonEmptyString(dataDictionary[@"A_Behavior"]);
    self.behavior = behaviorString.length == 0 ? @"查無資料" : behaviorString;
    self.imgUrl = nonEmptyString(dataDictionary[@"A_Pic01_URL"]);
    
    return self;
}

@end
