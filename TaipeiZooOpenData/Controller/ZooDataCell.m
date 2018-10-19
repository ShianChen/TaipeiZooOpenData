//
//  ZooDataCell.m
//  TaipeiZooOpenData
//
//  Created by NT30338 on 2018/10/19.
//  Copyright © 2018年 NT30338. All rights reserved.
//

#import "ZooDataCell.h"

@implementation ZooDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupUI:self.data];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupUI:(ZooData *)data {
    self.nameLabel.text = data.name;
    self.locationLabel.text = data.behavior;
    self.behaviorLabel.text = data.location;
    [self.picImage sd_setImageWithURL:[NSURL URLWithString:data.imgUrl]
                     placeholderImage:[UIImage imageNamed:@""]];
}

@end
