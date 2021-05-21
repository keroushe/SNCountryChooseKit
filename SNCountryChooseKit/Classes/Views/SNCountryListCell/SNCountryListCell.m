//
//  SNCountryListCell.m
//  Video
//
//  Created by hexs on 2021/1/29.
//  Copyright © 2021 cnest. All rights reserved.
//

#import "SNCountryListCell.h"
#import <SNCountryCodeFlagManage/SNCountryCodeFlagManage.h>
#import <SDWebImage/SDWebImage.h>
#import "UIImage+SNCountryChoose.h"
#import "NSBundle+SNCountryChoose.h"

@interface SNCountryListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *lefticonIV;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightIV;

@property (weak, nonatomic) IBOutlet UILabel *leftCodeLabel;
// 15/60
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lefticonIVLeftConstraint;

@property (nonatomic, strong) SNCountryListCountryData *celldata;
@property (nonatomic, assign) BOOL isPhoneCode;

@end

@implementation SNCountryListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSString *imgPath = [[NSBundle sn_countryChooseBundle] pathForResource:@"row_right_arrow_icon@3x" ofType:@"png"];
    _rightIV.image = [UIImage imageWithContentsOfFile:imgPath];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadCellData:(SNCountryListCountryData *)celldata
{
    _celldata = celldata;
    _isPhoneCode = NO;
    [self reloadCellData];
}

- (void)loadCodeCellData:(SNCountryListCountryData *)celldata
{
    _celldata = celldata;
    _isPhoneCode = YES;
    [self reloadCellData];
}

- (void)reloadCellData
{
    NSString *fileUrl = [SNCountryCodeFlagManage.sharedInstance getCountryFlagUrl:_celldata.code ResourceFolderUrl:@"https://s3.amazonaws.com/akasotech.net/CountryFlags"];
    if (fileUrl)
    {
        [_lefticonIV sd_setImageWithURL:[NSURL URLWithString:fileUrl] placeholderImage:[UIImage sn_imageWithColor:[UIColor colorWithRed:0xD8/255.0 green:0xD8/255.0 blue:0xD8/255.0 alpha:1.0]] options:SDWebImageRetryFailed|SDWebImageAllowInvalidSSLCertificates];
    }
    else
    {
        _lefticonIV.image = [UIImage sn_imageWithColor:[UIColor colorWithRed:0xD8/255.0 green:0xD8/255.0 blue:0xD8/255.0 alpha:1.0]];
    }
    
    _leftCodeLabel.text = (_isPhoneCode ? [NSString stringWithFormat:@"+%@", _celldata.phone_code] : @"");
    _lefticonIVLeftConstraint.constant = _isPhoneCode ? 60 : 15;
    _titleTextLabel.text = _celldata.name;
    _rightIV.hidden = _isPhoneCode ? YES : ((_celldata.list.count > 0) ? NO : YES);
}

@end
