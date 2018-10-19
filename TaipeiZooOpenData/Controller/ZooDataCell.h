//
//  ZooDataCell.h
//  TaipeiZooOpenData
//
//  Created by NT30338 on 2018/10/19.
//  Copyright © 2018年 NT30338. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZooData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZooDataCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *behaviorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImage;
@property (nonatomic, strong) ZooData *data;

//- (void)setupUI:(ZooData *)data;
@end

NS_ASSUME_NONNULL_END
