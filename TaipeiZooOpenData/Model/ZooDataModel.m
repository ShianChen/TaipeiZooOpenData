//
//  ZooDataModel.m
//  TaipeiZooOpenData
//
//  Created by NT30338 on 2018/10/19.
//  Copyright © 2018年 NT30338. All rights reserved.
//

#import "ZooDataModel.h"
#import "WebManager.h"

static int zooDataLimint = 30;
static int zooOffset = 30;

@interface ZooDataModel()

@property (strong, nonatomic) NSMutableArray<ZooData *> *zooDatas;
@property (assign, nonatomic) NSInteger queryCount;
@property (assign, nonatomic) NSInteger zooDataMaxCount;

@end

@implementation ZooDataModel

#pragma mark - sharedInstance

+ (ZooDataModel *)sharedInstance {
    static dispatch_once_t pred;
    static ZooDataModel *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[ZooDataModel alloc] init];
    });
    return shared;
}

#pragma mark - life cycle

- (instancetype)init {
    if ((self = [super init]) == nil) {
        return nil;
    }
    
    self.queryCount = 0;
    self.zooDataMaxCount = 0;
    self.zooDatas = [NSMutableArray<ZooData *> new];
    return self;
}

#pragma mark - Private

- (NSMutableArray<ZooData *> *)getZooDatas {
    return self.zooDatas;
}

- (void)queryZooOpenDataWithSuccessHandler:(void (^) (NSDictionary *response))successHandler
                               failHandler:(void (^) (NSDictionary *response))failHandler {
    if (self.zooDataMaxCount <= self.zooDatas.count &&
        self.zooDatas.count != 0) {
        //比數大於等於maxCount就return
        if (successHandler) {
            successHandler(nil);
        }
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        void (^newSuccessHandler)(NSDictionary*) = ^(NSDictionary *response) {
            weakSelf.queryCount++;
            NSDictionary *result = response[@"result"];
            self.zooDataMaxCount = [result[@"count"] integerValue];
            NSArray<NSDictionary*> *results = result[@"results"];
            
            NSLog(@"Zoo_count = %@", result[@"count"]);
            NSLog(@"Zoo_limit = %@", result[@"limit"]);
            NSLog(@"Zoo_offset = %@", result[@"offset"]);
            NSLog(@"Zoo_results.count = %ld", (long)results.count);
            
            [results enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.zooDatas addObject:[[ZooData alloc] initWithDictionary:obj]];
            }];
            
            NSLog(@"self.zooDatas.count = %ld", (long)self.zooDatas.count);
            
            if (successHandler) {
                successHandler(response);
            }
        };
        
        [WebManager queryZooOpenDataWithLimit:zooDataLimint
                                       offset:(zooOffset * weakSelf.queryCount)
                               successHandler:newSuccessHandler
                                  failHandler:failHandler];
    });
}


@end
