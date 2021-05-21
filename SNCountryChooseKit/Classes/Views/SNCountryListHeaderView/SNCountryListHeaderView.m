//
//  SNCountryListHeaderView.m
//  Video
//
//  Created by saina on 2020/12/10.
//  Copyright © 2020 cnest. All rights reserved.
//

#import "SNCountryListHeaderView.h"
#import <Masonry/Masonry.h>
#import "SNCountryChooseLanHandle.h"

@implementation SNCountryListHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIImageView *bakIV = [[UIImageView alloc] init];
    bakIV.backgroundColor = [UIColor colorWithRed:0xF8/255.0f green:0xF8/255.0f blue:0xF8/255.0f alpha:1.0f];
    [self.contentView addSubview:bakIV];
    [bakIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = SNCountryChooseLanHandle.sharedInstance.keyNewCityChoose_UseCur_Location;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).mas_offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    _titleLabel = titleLabel;
}

@end
