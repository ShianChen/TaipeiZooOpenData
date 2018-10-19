//
//  ZooDataModel.m
//  TaipeiZooOpenData
//
//  Created by NT30338 on 2018/10/19.
//  Copyright © 2018年 NT30338. All rights reserved.
//

#import "ZooDataModel.h"
#import "WebManager.h"

static int limint = 30;
static int offset = 30;

@interface ZooDataModel()

@property (strong, nonatomic) NSMutableArray<ZooData *> *zooDatas;
@property (assign, nonatomic) NSInteger count;

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
    
    self.count = 0;
    self.zooDatas = [NSMutableArray<ZooData *> new];
    return self;
}

#pragma mark - Private

- (NSMutableArray<ZooData *> *)getZooDatas {
    return self.zooDatas;
}

- (void)queryZooOpenDataWithSuccessHandler:(void (^) (NSDictionary *response))successHandler
                               failHandler:(void (^) (NSDictionary *response))failHandler {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        void (^newSuccessHandler)(NSDictionary*) = ^(NSDictionary *response) {
            weakSelf.count++;
            NSDictionary *result = response[@"result"];
            NSArray<NSDictionary*> *results = result[@"results"];
            
            [results enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.zooDatas addObject:[[ZooData alloc] initWithDictionary:obj]];
            }];
            
            if (successHandler) {
                successHandler(response);
            }
        };
        
        [WebManager queryZooOpenDataWithLimit:limint
                                       offset:(offset * weakSelf.count)
                               successHandler:newSuccessHandler
                                  failHandler:failHandler];
    });
}


@end
