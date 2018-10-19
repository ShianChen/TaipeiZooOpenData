//
//  WebManager.m
//  TaipeiZooOpenData
//
//  Created by NT30338 on 2018/10/19.
//  Copyright © 2018年 NT30338. All rights reserved.
//

#import "WebManager.h"
#import "AFNetworking.h"

static NSString *zooOpenDataUrl = @"https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613";

@implementation WebManager

+ (void)queryZooOpenDataWithLimit:(NSInteger)limit
                           offset:(NSInteger)offset
                   successHandler:(void (^) (NSDictionary *response))successHandler
                      failHandler:(void (^) (NSDictionary *response))failHandler {
    NSDictionary *parameters = @{@"limit":  [NSNumber numberWithInteger:limit],
                                 @"offset": [NSNumber numberWithInteger:offset]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:zooOpenDataUrl
      parameters:parameters
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             id jsonData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                           options:kNilOptions
                                                             error:nil];
             NSDictionary *dataDict = nil;
             if ([jsonData isKindOfClass:[NSDictionary class]]) {
                 dataDict = (NSDictionary*)jsonData;
             }
             
             if (successHandler) {
                 successHandler(dataDict);
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"error = %@", error.description);
         }];
    [manager invalidateSessionCancelingTasks:NO];
}

@end
